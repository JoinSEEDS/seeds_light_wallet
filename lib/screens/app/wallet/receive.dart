import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/i18n/wallet.i18n.dart';
import 'package:seeds/models/Currencies.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/rate_notiffier.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/firebase/firebase_database_service.dart';
import 'package:seeds/providers/services/firebase/firebase_datastore_service.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/utils/double_extension.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/main_text_field.dart';

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


  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  var savingLoader = GlobalKey<MainButtonState>();

  PersistentBottomSheetController bottomSheetController;

  List<ProductModel> products = List();

  String localImagePath = '';

  @override
  void initState() {
    super.initState();
  }

  void chooseProductPicture() async {
    final PickedFile image = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 20);

    if (image == null) return;

    File localImage = File(image.path);

    final String path = (await getApplicationDocumentsDirectory()).path;
    final fileName = basename(image.path);
    final fileExtension = extension(image.path);

    localImage = await localImage.copy("$path/$fileName$fileExtension");

    setState(() {
      localImagePath = localImage.path;
    });

    bottomSheetController.setState(() {});
  }

  Future<void> createNewProduct(String userAccount) async {
    if (products.indexWhere((element) => element.name == nameController.text) != -1) return;

    String downloadUrl;
    setState(() {
      savingLoader.currentState.loading();
    });

    if (localImagePath != null && localImagePath.isNotEmpty) {
      TaskSnapshot image = await FirebaseDataStoreService().uploadPic(File(localImagePath), userAccount);
      downloadUrl = await image.ref.getDownloadURL();
      localImagePath = '';
    }

    final product = ProductModel(
      name: nameController.text,
      price: double.parse(priceController.text),
      picture: downloadUrl,
      currency: Currency.SEEDS
    );

    FirebaseDatabaseService().createProduct(product, userAccount).then((value) => closeBottomSheet());
  }

  Future<void> editProduct(ProductModel productModel, String userAccount) async {
    String downloadUrl;
    setState(() {
      savingLoader.currentState.loading();
    });

    if (localImagePath != null && localImagePath.isNotEmpty) {
      TaskSnapshot image = await FirebaseDataStoreService().uploadPic(File(localImagePath), userAccount);
      downloadUrl = await image.ref.getDownloadURL();
      localImagePath = '';
    }

    final product = ProductModel(
        name: nameController.text,
        price: double.parse(priceController.text),
        picture: downloadUrl,
        id: productModel.id);

    FirebaseDatabaseService().updateProduct(product, userAccount).then((value) => closeBottomSheet());
  }

  void closeBottomSheet() {
    bottomSheetController.close();
    bottomSheetController = null;
    setState(() {});
  }

  void deleteProduct(ProductModel productModel, String userAccount) {
    FirebaseDatabaseService().deleteProduct(productModel, userAccount);
  }

  Future<void> showDeleteProduct(BuildContext context, ProductModel productModel, String userAccount) {

    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete ${productModel.name} ?"),
          actions: [
            FlatButton(
              child: Text("Delete"),
              onPressed: () {
                deleteProduct(productModel, userAccount);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildPictureWidget(String imageUrl) {
    var children;
    if (localImagePath.isNotEmpty) {
      children = [
        CircleAvatar(
          backgroundImage: FileImage(File(localImagePath)),
          radius: 20,
        ),
        SizedBox(width: 10),
        Text("Change Picture"),
      ];
    } else if (imageUrl != null && imageUrl.isNotEmpty) {
      children = [
        CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
          radius: 20,
        ),
        SizedBox(width: 10),
        Text("Change Picture"),
      ];
    } else {
      children = [
        CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(
            Icons.add,
            color: Colors.black,
            size: 15,
          ),
          radius: 15,
        ),
        Text("Add Picture"),
      ];
    }

    return Container(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ));
  }

  void showEditProduct(BuildContext context, ProductModel productModel, String userAccount) {
    nameController.text = productModel.name;
    priceController.text = productModel.price.toString();

    bottomSheetController = Scaffold.of(context).showBottomSheet(
      (context) => Container(
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              blurRadius: 8,
              color: AppColors.blue,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Wrap(
          runSpacing: 10.0,
          children: <Widget>[
            DottedBorder(
              color: AppColors.grey,
              strokeWidth: 1,
              child: GestureDetector(
                onTap: chooseProductPicture,
                child: buildPictureWidget(productModel.picture),
              ),
            ),
            MainTextField(
              labelText: 'Name',
              controller: nameController,
            ),
            MainTextField(
              labelText: 'Price',
              controller: priceController,
              endText: 'SEEDS',
              keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
            ),
            MainButton(
              key: savingLoader,
              title: 'Edit Product',
              onPressed: () {
                editProduct(productModel, userAccount);
              },
            ),
          ],
        ),
      ),
    );

    setState(() {});
  }

  void showNewProduct(BuildContext context, String accountName) {
    nameController.clear();
    priceController.clear();
    localImagePath = "";

    bottomSheetController = Scaffold.of(context).showBottomSheet(
      (context) => Container(
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              blurRadius: 8,
              color: AppColors.blue,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Wrap(
          runSpacing: 10.0,
          children: <Widget>[
            DottedBorder(
              color: AppColors.grey,
              strokeWidth: 1,
              child: GestureDetector(
                onTap: chooseProductPicture,
                child: buildPictureWidget(null),
              ),
            ),
            MainTextField(
              labelText: 'Name',
              controller: nameController,
            ),
            MainTextField(
              labelText: 'Price',
              controller: priceController,
              endText: 'SEEDS',
              keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
            ),
            MainButton(
              key: savingLoader,
              title: 'Add Product',
              onPressed: () {
                createNewProduct(accountName);
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
    var accountName = EosService.of(context, listen: false).accountName;
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
                onPressed: () => showNewProduct(context, accountName),
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
      body: StreamBuilder<List<ProductModel>>(
          stream: FirebaseDatabaseService().getProductsForUser(accountName),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SizedBox.shrink();
            } else {
              var products = snapshot.data;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: products.length,
                itemBuilder: (ctx, index) => ListTile(
                  leading: CircleAvatar(
                    backgroundImage: products[index].picture.isNotEmpty ? NetworkImage(products[index].picture) : null,
                    child: products[index].picture.isEmpty
                        ? Container(
                            color: AppColors.getColorByString(products[index].name),
                            child: Center(
                              child: Text(
                                products[index].name.characters.first,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          )
                        : null,
                    radius: 20,
                  ),
                  title: Material(
                    child: Text(
                      products[index].name,
                      style: TextStyle(fontFamily: "worksans", fontWeight: FontWeight.w500),
                    ),
                  ),
                  subtitle: Material(
                    child: Text(
                      getProductPrice(products[index]),
                      style: TextStyle(fontFamily: "worksans", fontWeight: FontWeight.w400),
                    ),
                  ),
                  trailing: Builder(
                    builder: (context) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            showEditProduct(context, products[index], accountName);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            showDeleteProduct(context, products[index], accountName);
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
              );
            }
          }),
    );
  }

  String getProductPrice(ProductModel product) {
    return "${product.price.seedsFormatted} ${product.currency.name}";
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
  Map<String, int> cartQuantity = Map();

  void changeTotalPrice(double amount) {
    invoiceAmountDouble += amount;
    invoiceAmount = invoiceAmountDouble.toString();
    controller.text = invoiceAmount;
  }

  void removeProductFromCart(ProductModel product) {
    setState(() {
      cartQuantity[product.name]--;

      if (cartQuantity[product.name] == 0) {
        cart.removeWhere((element) => element.name == product.name);
        cartQuantity[product.name] = null;
      }

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
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 5, 0, 0),
                    child: Consumer<RateNotifier>(
                      builder: (context, rateNotifier, child) {
                        return Text(
                          rateNotifier
                            .amountToString(invoiceAmountDouble, SettingsNotifier.of(context).selectedFiatCurrency), 
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
                                backgroundImage: FileImage(File(product.picture)),
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
                            removeProductFromCart(product);
                          },
                        ),
                      ),
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
      final price = difference.abs();

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
                    price.toString(),
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
