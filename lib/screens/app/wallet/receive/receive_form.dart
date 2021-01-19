import 'package:flutter/material.dart' hide Action;
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/i18n/wallet.i18n.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/rate_notiffier.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/firebase/firebase_database_service.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/screens/app/wallet/receive/product_catalog.dart';
import 'package:seeds/utils/double_extension.dart';
import 'package:seeds/utils/user_input_number_formatter.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/main_text_field.dart';

class ReceiveForm extends StatefulWidget {
  @override
  _ReceiveFormState createState() => _ReceiveFormState();
}

class _ReceiveFormState extends State<ReceiveForm> {
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController(text: '');
  String invoiceAmount = '0.00 SEEDS';
  double invoiceAmountDouble = 0;

  List<ProductModel> cart = List();
  Map<String, int> cartQuantity = Map();

  @override
  void didChangeDependencies() {
    loadProducts();
    super.didChangeDependencies();
  }

  void loadProducts() async {
    final accountName = EosService.of(this.context).accountName;

    final products = await FirebaseDatabaseService().getProductsForUser(accountName).first;

    products.forEach((product) {
      cart.add(product);
      cartQuantity[product.name] = 0;
    });

    setState(() {});
  }

  void changeTotalPrice(double amount) {
    invoiceAmountDouble += amount;
    invoiceAmount = invoiceAmountDouble.toString();
    controller.text = invoiceAmount;
  }

  void removeProductFromCart(ProductModel product) {
    setState(() {
      cartQuantity[product.name]--;

      changeTotalPrice(-product.price);
    });
  }

  void removePriceDifference() {
    final difference = donationOrDiscountAmount();

    setState(() {
      changeTotalPrice(difference);
    });
  }

  void addProductToCart(ProductModel product) {
    setState(() {
      if (cartQuantity[product.name] == null) {
        cart.add(product);
        cartQuantity[product.name] = 1;
      } else {
        cartQuantity[product.name]++;
      }

      changeTotalPrice(product.price);
    });
  }

  void showMerchantCatalog(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductsCatalog(addProductToCart),
        maintainState: true,
        fullscreenDialog: true,
      ),
    );
  }

  void generateInvoice(String amount) async {
    double receiveAmount = double.tryParse(amount) ?? 0;

    setState(() {
      invoiceAmountDouble = receiveAmount;
      invoiceAmount = receiveAmount.toStringAsFixed(4);
    });
  }

  double donationOrDiscountAmount() {
    final cartTotalPrice =
        cart.map((product) => product.price * cartQuantity[product.name]).reduce((value, element) => value + element);

    final difference = cartTotalPrice - invoiceAmountDouble;

    return difference;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            MainTextField(
              suffixIcon: IconButton(
                icon: Icon(Icons.add_shopping_cart, color: AppColors.blue),
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  showMerchantCatalog(context);
                },
              ),
              keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
              controller: controller,
              labelText: 'Receive (SEEDS)'.i18n,
              autofocus: true,
              inputFormatters: [
                UserInputNumberFormatter(),
              ],
              validator: (String amount) {
                String error;
                double receiveAmount;

                if (double.tryParse(amount) == null) {
                  if (amount.isEmpty) {
                    error = null;
                  } else {
                    error = "Receive amount is not valid".i18n;
                  }
                } else {
                  receiveAmount = double.parse(amount);

                  if (amount == null || amount.isEmpty) {
                    error = null;
                  } else if (receiveAmount == 0.0) {
                    error = "Amount cannot be 0.".i18n;
                  } else if (receiveAmount < 0.0001) {
                    error = "Amount must be > 0.0001".i18n;
                  }
                }

                return error;
              },
              onChanged: (String amount) {
                if (formKey.currentState.validate()) {
                  generateInvoice(amount);
                } else {
                  setState(() {
                    invoiceAmountDouble = 0;
                  });
                }
              },
            ),
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 5, 0, 0),
                    child: Consumer<RateNotifier>(
                      builder: (context, rateNotifier, child) {
                        return Text(
                          rateNotifier.amountToString(
                              invoiceAmountDouble, SettingsNotifier.of(context).selectedFiatCurrency),
                          style: TextStyle(color: Colors.blue),
                        );
                      },
                    ))),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 33, 0, 0),
              child: MainButton(
                  title: "Next".i18n,
                  active: invoiceAmountDouble != 0,
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    NavigationService.of(context).navigateTo(Routes.receiveQR, invoiceAmountDouble);
                  }),
            ),
            cart.length > 0 ? buildCart() : Container(),
          ],
        ),
      ),
    );
  }

  Widget buildCart() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GridView(
        physics: ScrollPhysics(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200.0,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
        ),
        shrinkWrap: true,
        children: [
          ...cart
              .map(
                (product) => GridTile(
                  header: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        product.picture.isNotEmpty
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(product.picture),
                                radius: 20,
                              )
                            : Container(),
                        Row(
                          children: [
                            Text(
                              product.price.toString(),
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Image.asset(
                              'assets/images/seeds.png',
                              height: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.getColorByString(product.name),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          blurRadius: 15,
                          color: AppColors.getColorByString(product.name),
                          offset: Offset(6, 10),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        product.name.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  footer: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      cartQuantity[product.name] > 0
                          ? SizedBox(
                              width: 48,
                              height: 48,
                              child: FlatButton(
                                padding: EdgeInsets.zero,
                                color: AppColors.red,
                                child: Icon(
                                  Icons.remove,
                                  size: 21,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  removeProductFromCart(product);
                                },
                              ),
                            )
                          : SizedBox(width: 48, height: 48),
                      Text(
                        cartQuantity[product.name].toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                      SizedBox(
                        width: 48,
                        height: 48,
                        child: FlatButton(
                          padding: EdgeInsets.zero,
                          color: AppColors.green,
                          child: Icon(
                            Icons.add,
                            size: 21,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            addProductToCart(product);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
          buildDonationOrDiscountItem(),
        ],
      ),
    );
  }

  Widget buildDonationOrDiscountItem() {
    double difference = donationOrDiscountAmount();

    if (difference == 0) {
      return Container();
    } else {
      final name = difference > 0 ? "Discount" : "Donation";
      final price = difference;

      return GridTile(
        header: Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: AppColors.blue,
                child: Icon(difference > 0 ? Icons.remove : Icons.add, color: Colors.white),
                radius: 20,
              ),
              Row(
                children: [
                  Text(
                    price.seedsFormatted,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Image.asset(
                    'assets/images/seeds.png',
                    height: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.getColorByString(name),
            boxShadow: <BoxShadow>[
              BoxShadow(
                blurRadius: 15,
                color: AppColors.getColorByString(name),
                offset: Offset(6, 10),
              ),
            ],
          ),
          child: Center(
            child: Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        footer: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 48,
              height: 48,
              child: FlatButton(
                padding: EdgeInsets.zero,
                color: AppColors.blue,
                child: Icon(
                  Icons.cancel_outlined,
                  size: 21,
                  color: Colors.white,
                ),
                onPressed: removePriceDifference,
              ),
            ),
          ],
        ),
      );
    }
  }
}
