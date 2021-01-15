import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/i18n/wallet.i18n.dart';
import 'package:seeds/models/Currencies.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/firebase/firebase_database_service.dart';
import 'package:seeds/providers/services/firebase/firebase_datastore_service.dart';
import 'package:seeds/screens/app/wallet/receive/amount_field_receive.dart';
import 'package:seeds/utils/double_extension.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/main_text_field.dart';

class ProductsCatalog extends StatefulWidget {
  final Function onTap;

  ProductsCatalog(this.onTap);

  @override
  _ProductsCatalogState createState() => _ProductsCatalogState();
}

class _ProductsCatalogState extends State<ProductsCatalog> {

  final editKey = GlobalKey<FormState>();
  final priceKey = GlobalKey<FormState>();
  final nameKey = GlobalKey<FormState>();
  var savingLoader = GlobalKey<MainButtonState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  String productName = "";
  double seedsValue = 0;
  Currency currency;
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
  }

  Future<void> createNewProduct(String userAccount, BuildContext context) async {
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
      price: seedsValue,
      picture: downloadUrl,
      currency: currency,
    );

    FirebaseDatabaseService().createProduct(product, userAccount).then((value) => closeBottomSheet(context));
  }

  Future<void> editProduct(ProductModel productModel, String userAccount , BuildContext context) async {
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
        price: seedsValue,
        picture: downloadUrl,
        id: productModel.id,
        currency: currency);

    FirebaseDatabaseService().updateProduct(product, userAccount).then((value) => closeBottomSheet(context));
  }

  void closeBottomSheet(BuildContext context) {
    Navigator.pop(context);
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
          title: Text('Delete'.i18n + " ${productModel.name} ?"),
          actions: [
            FlatButton(
              child: Text("Delete".i18n),
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
        Text("Change Picture".i18n),
      ];
    } else if (imageUrl != null && imageUrl.isNotEmpty) {
      children = [
        CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
          radius: 20,
        ),
        SizedBox(width: 10),
        Text('Change Picture'.i18n),
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
        Text('Add Picture'.i18n),
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
    currency = productModel.currency;

    showModalBottomSheet<void>(isScrollControlled: true,context: context, builder: (BuildContext context) {
      return SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                blurRadius: 16,
                color: AppColors.blue,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Form(
            key: editKey,
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
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
                      labelText: 'Name'.i18n,
                      controller: nameController,
                      validator: (String name) {
                        String error;

                        if (name == null || name.isEmpty) {
                          error = 'Name cannot be empty'.i18n;
                        }
                        return error;
                      },
                      onChanged: (name) {
                        editKey.currentState.validate();
                      }),
                  AmountField(
                      currentCurrency: currency,
                      priceController: priceController,
                      onChanged: (amount, input, validate) => {
                        validate ? editKey.currentState.validate() : null,
                        seedsValue = amount,
                        currency = input,
                      }),
                  MainButton(
                    key: savingLoader,
                    title: 'Edit Product'.i18n,
                    onPressed: () {
                      if (editKey.currentState.validate()) {
                        editProduct(productModel, userAccount, context);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });

    setState(() {});
  }



  void showNewProduct(BuildContext context, String accountName) {
    nameController.clear();
    priceController.clear();
    localImagePath = "";
    currency = Currency.SEEDS;

    showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    blurRadius: 16,
                    color: AppColors.blue,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Form(
                key: priceKey,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 15,
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
                      Form(
                        key: nameKey,
                        child: MainTextField(
                            labelText: 'Name'.i18n,
                            controller: nameController,
                            validator: (String name) {
                              String error;

                              if (name == null || name.isEmpty) {
                                error = 'Name cannot be empty'.i18n;
                              }
                              return error;
                            },
                            onChanged: (name) {
                              nameKey.currentState.validate();
                            }),
                      ),
                      AmountField(
                          currentCurrency: currency,
                          priceController: priceController,
                          onChanged: (amount, currencyInput, validate) => {
                            validate ? priceKey.currentState.validate() : "",
                            seedsValue = amount,
                            currency = currencyInput,
                          }),
                      MainButton(
                        key: savingLoader,
                        title: 'Add Product'.i18n,
                        onPressed: () {
                          nameKey.currentState.validate();
                          if (priceKey.currentState.validate() && nameKey.currentState.validate()) {
                            createNewProduct(accountName, context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
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
          builder: (context) =>
              FloatingActionButton(
                backgroundColor: AppColors.blue,
                onPressed: () => showNewProduct(context, accountName),
                child: Icon(Icons.add),
              )
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
                          products[index].name == null
                              ? ""
                              :products[index].name.characters.first,
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
                      products[index].name == null
                          ? ""
                          :products[index].name,
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

                            setState(() {});

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