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
import 'package:seeds/widgets/seeds_button.dart';
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
          'Your Products',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () => showNewProduct(context),
          child: Icon(Icons.add),
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
          trailing: Text(products[index].price.toString()),
          onTap: () {
            widget.onTap(products[index]);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Box<ProductModel> box;

  List<ProductModel> products = List();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

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

    nameController.clear();
    priceController.clear();
  }

  void showNewProduct(BuildContext context) {
    Scaffold.of(context).showBottomSheet(
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
                Navigator.pop(context);
              },
            ),
          ],
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

    Scaffold.of(context).showBottomSheet(
      (context) => Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
        child: Wrap(
          runSpacing: 10.0,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[],
            ),
          ],
        ),
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          MainTextField(
            suffixIcon: IconButton(
              icon: Icon(Icons.add_shopping_cart),
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
          Container(
            child: ListView(
              shrinkWrap: true,
              children: cart
                  .map((product) => Text("${product.name} - ${product.price}"))
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 33, 0, 0),
            child: MainButton(
                title: "Next",
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
