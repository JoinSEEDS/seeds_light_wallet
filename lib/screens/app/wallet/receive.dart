import 'package:flutter/material.dart' hide Action;
import 'package:hive/hive.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/utils/extensions/SafeHive.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/main_text_field.dart';
import 'package:seeds/i18n/wallet.i18n.dart';
import 'package:seeds/utils/double_extension.dart';

class Receive extends StatefulWidget {
  Receive({Key key}) : super(key: key);

  @override
  _ReceiveState createState() => _ReceiveState();
}

class _ReceiveState extends State<Receive> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: ReceiveForm(),
      ),
    );
  }
}

class ProductsCatalog extends StatefulWidget {
  final Function onTap;
  ProductsCatalog(this.onTap);

  @override
  _ProductsCatalogState createState() => _ProductsCatalogState();
}

class _ProductsCatalogState extends State<ProductsCatalog> {
  Box<ProductModel> box;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  PersistentBottomSheetController bottomSheetController;

  List<ProductModel> products = List();

  @override
  void initState() {
    loadProducts();

    super.initState();
  }

  void loadProducts() async {
    box = await SafeHive.safeOpenBox<ProductModel>("products");

    setState(() {
      products.addAll(box.values);
    });

    box.watch().listen((event) {
      setState(() {
        products.clear();
        products.addAll(box.values);
      });
    });
  }

  void createNewProduct() {
    final product = ProductModel(
      name: nameController.text,
      price: double.parse(priceController.text),
      picture: '',
    );

    box.add(product);
  }

  void editProduct(int index) {
    final product = ProductModel(
      name: nameController.text,
      price: double.parse(priceController.text),
      picture: '',
    );

    box.putAt(index, product);
  }

  void deleteProduct(int index) {
    box.deleteAt(index);
  }

  Future<void> showDeleteProduct(BuildContext context, int index) {
    final product = products[index];

    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete ${product.name} ?"),
          actions: [
            FlatButton(
              child: Text("Approve"),
              onPressed: () {
                deleteProduct(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showEditProduct(BuildContext context, int index) {
    nameController.text = products[index].name;
    priceController.text = products[index].price.toString();

    bottomSheetController = Scaffold.of(context).showBottomSheet(
      (context) => Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
        child: Wrap(
          runSpacing: 10.0,
          children: <Widget>[
            MainTextField(
              labelText: 'Name',
              controller: nameController,
            ),
            MainTextField(
              labelText: 'Price',
              controller: priceController,
              endText: 'SEEDS',
              keyboardType:
                  TextInputType.numberWithOptions(signed: false, decimal: true),
            ),
            MainButton(
              title: 'Edit Product',
              onPressed: () {
                editProduct(index);
                bottomSheetController.close();
                bottomSheetController = null;
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );

    setState(() {});
  }

  void showNewProduct(BuildContext context) {
    nameController.clear();
    priceController.clear();

    bottomSheetController = Scaffold.of(context).showBottomSheet(
      (context) => Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
        child: Wrap(
          runSpacing: 10.0,
          children: <Widget>[
            MainTextField(
              labelText: 'Name',
              controller: nameController,
            ),
            MainTextField(
              labelText: 'Price',
              controller: priceController,
              endText: 'SEEDS',
              keyboardType:
                  TextInputType.numberWithOptions(signed: false, decimal: true),
            ),
            MainButton(
              title: 'Add Product',
              onPressed: () {
                createNewProduct();
                bottomSheetController.close();
                bottomSheetController = null;
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Your Products'.i18n,
          style: TextStyle(color: Colors.black87),
        ),
      ),
      floatingActionButton: Builder(
        builder: (context) => bottomSheetController == null
            ? FloatingActionButton(
                backgroundColor: AppColors.blue,
                onPressed: () => showNewProduct(context),
                child: Icon(Icons.add),
              )
            : FloatingActionButton(
                backgroundColor: AppColors.blue,
                onPressed: () {
                  bottomSheetController.close();
                  bottomSheetController = null;
                  setState(() {});
                },
                child: Icon(Icons.close),
              ),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: products.length,
        itemBuilder: (ctx, index) => ListTile(
          title: Material(
            child: Text(
              products[index].name,
              style: TextStyle(
                  fontFamily: "worksans", fontWeight: FontWeight.w500),
            ),
          ),
          subtitle: Material(
            child: Text(
              products[index].price.seedsFormatted + " SEEDS",
              style: TextStyle(
                  fontFamily: "worksans", fontWeight: FontWeight.w400),
            ),
          ),
          trailing: Builder(
            builder: (context) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    showEditProduct(context, index);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDeleteProduct(context, index);
                  },
                ),
              ],
            ),
          ),
          onTap: () {
            widget.onTap(products[index]);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}

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

  void addProductToCart(ProductModel product) {
    setState(() {
      cart.add(product);
      invoiceAmountDouble += product.price;
      invoiceAmount = invoiceAmountDouble.toString();
      controller.text = invoiceAmount;
    });
  }

  void showMerchantCatalog() {
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

  Widget maybeDonationOrDiscount() {
    final cartTotalPrice = cart
        .map((product) => product.price)
        .reduce((value, element) => value + element);

    final difference = cartTotalPrice - invoiceAmountDouble;

    if (difference > 0) {
      return Text("- $difference " + "(Discount)".i18n);
    } else if (difference < 0) {
      return Text("+ ${difference.abs()} " + "(Donation)".i18n);
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          MainTextField(
            suffixIcon: IconButton(
              icon: Icon(Icons.add_shopping_cart, color: AppColors.blue),
              onPressed: () {
                FocusScope.of(context).requestFocus(FocusNode());
                showMerchantCatalog();
              },
            ),
            keyboardType:
                TextInputType.numberWithOptions(signed: false, decimal: true),
            controller: controller,
            labelText: 'Receive (SEEDS)'.i18n,
            autofocus: true,
            validator: (String amount) {
              String error;

              double receiveAmount = double.tryParse(amount);

              if (amount == null || amount.isEmpty) {
                error = null;
              } else if (receiveAmount == 0.0) {
                error = "Amount cannot be 0.".i18n;
              } else if (receiveAmount < 0.0001) {
                error = "Amount must be > 0.0001".i18n;
              } else if (receiveAmount == null) {
                error = "Receive amount is not valid".i18n;
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
          cart.length > 0
              ? Container(
                  padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      ...cart
                          .map((product) =>
                              Text("+ ${product.price} (${product.name})"))
                          .toList(),
                      maybeDonationOrDiscount()
                    ],
                  ),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 33, 0, 0),
            child: MainButton(
                title: "Next".i18n,
                active: invoiceAmountDouble != 0,
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  NavigationService.of(context)
                      .navigateTo(Routes.receiveQR, invoiceAmountDouble);
                }),
          ),
        ],
      ),
    );
  }
}
