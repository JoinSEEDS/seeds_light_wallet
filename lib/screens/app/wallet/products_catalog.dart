import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/rate_notiffier.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/firebase/firebase_database_map_keys.dart';
import 'package:seeds/providers/services/firebase/firebase_database_service.dart';
import 'package:seeds/providers/services/firebase/firebase_datastore_service.dart';
import 'package:seeds/screens/app/wallet/amount_field.dart';
import 'package:seeds/widgets/circle_avatar_factory.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:path/path.dart';
import 'package:seeds/i18n/wallet.i18n.dart';
import 'package:seeds/widgets/main_text_field.dart';
import 'package:seeds/utils/double_extension.dart';

class ProductsCatalog extends StatefulWidget {
  ProductsCatalog();

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
  double priceValue = 0;
  String currency;

  String localImagePath = '';

  @override
  void initState() {
    super.initState();
  }

  void chooseProductPicture() async {
    final PickedFile image = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 20);

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

  Future<void> createNewProduct(
      String userAccount, BuildContext context) async {
    if (products.indexWhere(
            (element) => element.data()['name'] == nameController.text) !=
        -1) return;

    String downloadUrl;
    setState(() {
      savingLoader.currentState.loading();
    });

    if (localImagePath != null && localImagePath.isNotEmpty) {
      TaskSnapshot image = await FirebaseDataStoreService()
          .uploadPic(File(localImagePath), userAccount);
      downloadUrl = await image.ref.getDownloadURL();
      localImagePath = '';
    }

    final product = ProductModel(
      name: nameController.text,
      price: priceValue,
      picture: downloadUrl,
      currency: currency,
      position: products.length,
    );

    FirebaseDatabaseService()
        .createProduct(product, userAccount)
        .then((value) => closeBottomSheet(context));
  }

  Future<void> editProduct(ProductModel productModel, String userAccount,
      BuildContext context) async {
    String downloadUrl;
    setState(() {
      savingLoader.currentState.loading();
    });

    if (localImagePath != null && localImagePath.isNotEmpty) {
      TaskSnapshot image = await FirebaseDataStoreService()
          .uploadPic(File(localImagePath), userAccount);
      downloadUrl = await image.ref.getDownloadURL();
      localImagePath = '';
    }

    final product = ProductModel(
        name: nameController.text,
        price: priceValue,
        picture: downloadUrl,
        id: productModel.id,
        currency: currency);

    FirebaseDatabaseService()
        .updateProduct(product, userAccount)
        .then((value) => closeBottomSheet(context));
  }

  void closeBottomSheet(BuildContext context) {
    Navigator.pop(context);
    setState(() {});
  }

  void deleteProduct(ProductModel productModel, String userAccount) {
    FirebaseDatabaseService().deleteProduct(productModel, userAccount);
  }

  Future<void> showDeleteProduct(
      BuildContext context, ProductModel productModel, String userAccount) {
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
    var fiatCurrency = currency != SEEDS
        ? currency
        : SettingsNotifier.of(context).selectedFiatCurrency;

    showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
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
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
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
                          fiatCurrency: fiatCurrency,
                          priceController: priceController,
                          validateAmount: false,
                          onChanged: (seedsAmount, fieldAmount, selectedCurrency) => {
                              //editKey.currentState.validate()
                                priceValue = fieldAmount,
                                currency = selectedCurrency,
                              }),
                      MainButton(
                        key: savingLoader,
                        title: 'Done'.i18n,
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
    currency = "SEEDS";

    showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
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
                          fiatCurrency:
                              SettingsNotifier.of(context).selectedFiatCurrency,
                          priceController: priceController,
                          validateAmount: false,
                          onChanged: (amount, currencyInput) => {
                              //priceKey.currentState.validate()
                                priceValue = amount,
                                currency = currencyInput,
                              }),
                      MainButton(
                        key: savingLoader,
                        title: 'Add Product'.i18n,
                        onPressed: () {
                          nameKey.currentState.validate();
                          if (priceKey.currentState.validate() &&
                              nameKey.currentState.validate()) {
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

  List<DocumentSnapshot> products;
  Future reordering;

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
          builder: (context) => FloatingActionButton(
                backgroundColor: AppColors.blue,
                onPressed: () => showNewProduct(context, accountName),
                child: Icon(Icons.add),
              )),
      body: FutureBuilder(
          builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.none ||
            snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder<QuerySnapshot>(
              stream: FirebaseDatabaseService()
                  .getOrderedProductsForUser(accountName),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox.shrink();
                } else {
                  products = snapshot.data.docs;
                  return ReorderableListView(
                    onReorder: (oldIndex, newIndex) {
                      if (oldIndex < newIndex) newIndex -= 1;
                      products.insert(newIndex, products.removeAt(oldIndex));
                      final futures = <Future>[];
                      for (int i = 0; i < products.length; i++) {
                        futures.add(products[i].reference.update({
                          PRODUCT_POSITION_KEY: i,
                        }));
                      }
                      setState(() {
                        reordering = Future.wait(futures);
                      });
                    },
                    children: products.map((data) {
                      var product = ProductModel.fromSnapshot(data);
                      return ListTile(
                        key: Key(data.id),
                        leading: CircleAvatarFactory.buildProductAvatar(product),
                        title: Material(
                          child: Text(
                            product.name == null ? "" : product.name,
                            style: TextStyle(
                                fontFamily: "worksans",
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        subtitle: Material(
                          child: Text(
                            getProductPrice(product),
                            style: TextStyle(
                                fontFamily: "worksans",
                                fontWeight: FontWeight.w400),
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

                                  showEditProduct(
                                      context, product, accountName);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  showDeleteProduct(
                                      context, product, accountName);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
              });
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }),
    );
  }

  String getProductPrice(ProductModel product) {
    return "${product.price.seedsFormatted} ${product.currency}";
  }
}