import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:seeds/v2/constants/app_colors.dart';
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
import 'package:seeds/widgets/receive_form.dart';

class Receive extends StatefulWidget {
  const Receive({Key? key}) : super(key: key);

  @override
  _ReceiveState createState() => _ReceiveState();
}

class _ReceiveState extends State<Receive> {
  CartModel cart = CartModel();
  List<ProductModel> products = <ProductModel>[];

  @override
  Widget build(BuildContext context) {
    final accountName = EosService.of(this.context).accountName;

    var fiat = SettingsNotifier.of(context).selectedFiatCurrency;
    var rate = RateNotifier.of(context);
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          color: Colors.white,
          child: SafeArea(
            top: false,
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseDatabaseService().getOrderedProductsForUser(accountName),
                builder: (context, snapshot) {
                  // if (!snapshot.hasData) {
                  //   return SizedBox.shrink();
                  // } else {
                  products = snapshot.hasData
                      ? List<ProductModel>.of(snapshot.data!.docs.map((QueryDocumentSnapshot p) => ProductModel.fromSnapshot(p)))
                      : <ProductModel>[];
                  return Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      title: Text(
                        'Receive'.i18n,
                        style: const TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text(
                            "Edit",
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
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      child: snapshot.hasData
                          ? ProductListForm(cart, products, () => setState(() {}))
                          : const Center(
                              child: CircularProgressIndicator(
                                  //backgroundColor: Colors.white,
                                  ),
                            ),
                    ),
                    bottomNavigationBar:
                        products.isEmpty ? const SizedBox(height: 1) : buildBottomAppBar(rate, fiat, context),
                  );
                }
                // }
                ),
          ),
        ));
  }

  BottomAppBar buildBottomAppBar(rate, fiat, BuildContext context) {
    return BottomAppBar(
      child: Container(
          margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${cart.itemCount} Items",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400, fontFamily: "worksans")),
                  const Spacer(),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("${cart.total.seedsFormatted} SEEDS",
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: "worksans")),
                      Text("${rate.currencyString(cart.total, fiat)}",
                          style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.blue,
                              fontWeight: FontWeight.w400,
                              fontFamily: "worksans")),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              MainButton(
                  title: "Next".i18n,
                  active: !cart.isEmpty,
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    NavigationService.of(context).navigateTo(Routes.receiveConfirmation, cart);
                  }),
            ],
          )),
    );
  }

  void showMerchantCatalog(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ProductsCatalog(),
        maintainState: true,
        fullscreenDialog: true,
      ),
    );
  }
}

class ProductListForm extends StatefulWidget {
  final CartModel cart;
  final Function onChange;
  final List<ProductModel> products;

  const ProductListForm(this.cart, this.products, this.onChange);

  @override
  _ProductListFormState createState() => _ProductListFormState();
}

class _ProductListFormState extends State<ProductListForm> {
  late CartModel cart;
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    cart = widget.cart;
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
            widget.products.isEmpty
                ? ReceiveForm(() => {setState(() {})})
                : MaterialButton(
                    color: Colors.white,
                    height: 33,
                    child: Text(
                      'Custom Amount'.i18n,
                      style: const TextStyle(color: Colors.blue),
                    ),
                    onPressed: () {
                      NavigationService.of(context).navigateTo(Routes.receiveCustom);
                    },
                  ),
            widget.products.isNotEmpty ? buildProductsList() : Container()
          ],
        ),
      ),
    );
  }

  Widget buildProductsList() {
    return Consumer<RateNotifier>(
      builder: (context, rateNotifier, child) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 24),
          child: GridView(
            physics: const ScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200.0,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
            ),
            shrinkWrap: true,
            children: [
              ...widget.products
                  .map(
                    (product) => buildGridTile(product, rateNotifier),
                  )
                  .toList(),
              //buildDonationOrDiscountItem(),
            ],
          ),
        );
      },
    );
  }

  GridTile buildGridTile(ProductModel product, RateNotifier rateNotifier) {
    return GridTile(
      header: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            product.picture!.isNotEmpty
                ? CircleAvatar(
                    backgroundImage: NetworkImage(product.picture!),
                    radius: 20,
                  )
                : Container(),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text(
                      product.seedsPrice(rateNotifier).fiatFormatted!,
                      style: const TextStyle(
                        fontSize: 16,
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
                product.currency == SEEDS
                    ? Container()
                    : Text(
                        product.price.fiatFormatted! + " " + product.currency!,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
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
              offset: const Offset(6, 10),
            ),
          ],
        ),
        child: Center(
          child: Text(
            product.name.toString(),
            style: const TextStyle(
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
            child: MaterialButton(
              padding: EdgeInsets.zero,
              color: AppColors.red,
              child: const Icon(
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
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
          SizedBox(
            width: 48,
            height: 48,
            child: MaterialButton(
              padding: EdgeInsets.zero,
              color: AppColors.green,
              child: const Icon(
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
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                    price.seedsFormatted!,
                    style: const TextStyle(
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
                offset: const Offset(6, 10),
              ),
            ],
          ),
          child: Center(
            child: Text(
              name,
              style: const TextStyle(
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
              child: MaterialButton(
                padding: EdgeInsets.zero,
                color: AppColors.blue,
                child: const Icon(
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
