import 'package:flutter/material.dart' hide Action;
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/i18n/wallet.i18n.dart';
import 'package:seeds/models/cart_model.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/rate_notiffier.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/firebase/firebase_database_service.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/screens/app/wallet/products_catalog.dart';
import 'package:seeds/utils/double_extension.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/main_text_field.dart';
import 'package:seeds/utils/user_input_number_formatter.dart';

class Receive extends StatefulWidget {
  Receive({Key key}) : super(key: key);

  @override
  _ReceiveState createState() => _ReceiveState();
}

class _ReceiveState extends State<Receive> {
  CartModel cart = CartModel();

  @override
  Widget build(BuildContext context) {
    var fiat = SettingsNotifier.of(context).selectedFiatCurrency;
    var rate = RateNotifier.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
            resizeToAvoidBottomPadding: true,
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                EosService.of(context).accountName ?? '',
                style: TextStyle(color: Colors.black87),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    showMerchantCatalog(context);
                  },
                )
              ],
            ),
            backgroundColor: Colors.white,
            body: Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: ReceiveForm(cart, () => setState(() {})),
            ),
            bottomNavigationBar: BottomAppBar(
              child: Container(
                  margin:
                      EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${cart.itemCount} Items",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "worksans")),
                          Spacer(),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("${cart.total.seedsFormatted} SEEDS",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "worksans")),
                              Text("${rate.currencyString(cart.total, fiat)}",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.blue,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "worksans")),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      MainButton(
                          title: "Next".i18n,
                          active: !cart.isEmpty,
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            NavigationService.of(context)
                                .navigateTo(Routes.receiveConfirmation, cart);
                          }),
                    ],
                  )),
            )),
      ),
    );
  }

  void showMerchantCatalog(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductsCatalog(),
        maintainState: true,
        fullscreenDialog: true,
      ),
    );
  }
}

class ReceiveForm extends StatefulWidget {
  final CartModel cart;
  final Function onChange;

  ReceiveForm(this.cart, this.onChange);

  @override
  _ReceiveFormState createState() => _ReceiveFormState(cart);
}

class _ReceiveFormState extends State<ReceiveForm> {
  final CartModel cart;
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController(text: '');

  final products = List<ProductModel>();

  _ReceiveFormState(this.cart);

  @override
  void didChangeDependencies() {
    loadProducts();
    super.didChangeDependencies();
  }

  void loadProducts() async {
    // kinda don't need load productS? TODO
    final accountName = EosService.of(this.context).accountName;

    final fbProducts = await FirebaseDatabaseService()
        .getOrderedProductsForUser(accountName)
        .first;

    products.clear();

    fbProducts.docs.forEach((data) {
      var product = ProductModel.fromSnapshot(data);
      products.add(product);
    });

    setState(() {});
    widget.onChange();
  }

  void removeProductFromCart(ProductModel product, RateNotifier rateNotifier) {
    cart.currencyConverter = rateNotifier;
    setState(() {
      cart.remove(product, deleteOnZero: true);
    });
    widget.onChange();
  }

  void removePriceDifference() {
    setState(() {
      cart.donationDiscount = 0;
    });
    widget.onChange();
  }

  void addProductToCart(ProductModel product, RateNotifier rateNotifier) {
    cart.currencyConverter = rateNotifier;
    setState(() {
      cart.add(product);
    });
    widget.onChange();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            products.length == 0
                ? buildEntryField()
                : FlatButton(
                color: Colors.white,
                height: 33,
                child: Text(
                  'Custom Amount'.i18n,
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () {
                    NavigationService.of(context)
                          .navigateTo(Routes.receiveCustom);
                    },
              ),
              products.length > 0
                ? buildProductsList()
                : Column(
                  children: [
                    MainButton(
                        title: "Next".i18n,
                        active: cart.total > 0,
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          NavigationService.of(context)
                              .navigateTo(Routes.receiveConfirmation, cart);
                        }),
                    
                        
                  ],
                ),
          ],
        ),
      ),
    );
  }

  Widget buildEntryField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        children: [
        MainTextField(
          //focusNode: FocusNode(),
          keyboardType:
              TextInputType.numberWithOptions(signed: false, decimal: true),
          controller: controller,
          labelText: 'Receive (SEEDS)'.i18n,
          autofocus: false,
          inputFormatters: [
            UserInputNumberFormatter(),
          ],
          validator: (String amount) {
            String error;
            double receiveAmount;

            if (!cart.isEmpty) {
              return null;
            }

            if (amount == null || amount == "") {
              return "Amount cannot be empty".i18n;
            }

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
              setState(() {
                cart.customAmount = double.tryParse(amount);
              });
            } else {
              setState(() {
                cart.customAmount = 0;
              });
            }
          },
        ),
        Align(
            alignment: Alignment.topLeft,
            child: Padding(
                padding: EdgeInsets.fromLTRB(16, 4, 0, 0),
                child: Consumer<RateNotifier>(
                  builder: (context, rateNotifier, child) {
                    return Text(
                      rateNotifier.amountToString(cart.total,
                          SettingsNotifier.of(context).selectedFiatCurrency),
                      style: TextStyle(color: Colors.blue),
                    );
                  },
                )))
      ]),
    );
  }

  Widget buildProductsList() {
    return Consumer<RateNotifier>(
      builder: (context, rateNotifier, child) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 24),
          child: GridView(
            physics: ScrollPhysics(),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200.0,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
            ),
            shrinkWrap: true,
            children: [
              ...products
                  .map(
                    (product) => GridTile(
                      header: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            product.picture.isNotEmpty
                                ? CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(product.picture),
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
                          SizedBox(
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
                                removeProductFromCart(product, rateNotifier);
                              },
                            ),
                          ),
                          Text(
                            productQuantity(product),
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
                                addProductToCart(product, rateNotifier);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              //buildDonationOrDiscountItem(),
            ],
          ),
        );
      },
    );
  }

  String productQuantity(ProductModel product) {
    int quantity = cart.quantityFor(product);
    return quantity > 0 ? "$quantity" : "";
  }

  Widget buildDonationOrDiscountItem() {
    double difference = cart.donationDiscount;

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
                child: Icon(difference > 0 ? Icons.remove : Icons.add,
                    color: Colors.white),
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

class AmountField extends StatefulWidget {
  const AmountField(
      {Key key,
      this.onChanged,
      this.priceController,
      this.currentCurrency,
      this.fiatCurrency})
      : super(key: key);

  final TextEditingController priceController;
  final Function onChanged;
  final String currentCurrency;
  final String fiatCurrency;

  @override
  _AmountFieldState createState() =>
      _AmountFieldState(double.tryParse(priceController.text), currentCurrency);
}

class _AmountFieldState extends State<AmountField> {
  _AmountFieldState(this.price, this.currentCurrency);

  bool validate = false;
  double price;
  String currentCurrency;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MainTextField(
          labelText: 'Price'.i18n,
          suffixIcon: Container(
            height: 35,
            margin: EdgeInsets.only(top: 8, bottom: 8, right: 16),
            child: OutlineButton(
              onPressed: () {
                _toggleInput(widget.fiatCurrency);
              },
              child: Text(
                currentCurrency == SEEDS ? 'SEEDS' : widget.fiatCurrency,
                style: TextStyle(color: AppColors.grey, fontSize: 16),
              ),
            ),
          ),
          keyboardType:
              TextInputType.numberWithOptions(signed: false, decimal: true),
          controller: widget.priceController,
          inputFormatters: [
            UserInputNumberFormatter(),
          ],
          validator: (String amount) {
            String error;

            double receiveAmount = double.tryParse(amount);

            if (amount == null) {
              error = null;
            } else if (amount.isEmpty) {
              error = 'Price field is empty'.i18n;
            } else if (receiveAmount == null) {
              error = 'Price needs to be a number'.i18n;
            }

            return error;
          },
          onChanged: (amount) {
            if (double.tryParse(amount) != null) {
              setState(() {
                price = double.tryParse(amount);
                validate = true;
              });
              widget.onChanged(price, currentCurrency, validate);
            } else {
              setState(() {
                price = 0;
                validate = true;
              });
              widget.onChanged(0, currentCurrency, validate);
            }
          },
        ),
      ],
    );
  }

  void _toggleInput(String fiat) {
    setState(() {
      if (currentCurrency == SEEDS) {
        currentCurrency = fiat;
        validate = false;
        widget.onChanged(price, currentCurrency, validate);
      } else {
        currentCurrency = SEEDS;
        validate = false;
        widget.onChanged(price, currentCurrency, validate);
      }
    });
  }
}
