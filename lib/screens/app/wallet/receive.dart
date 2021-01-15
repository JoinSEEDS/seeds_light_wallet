import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/i18n/wallet.i18n.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/rate_notiffier.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/firebase/firebase_database_map_keys.dart';
import 'package:seeds/providers/services/firebase/firebase_database_service.dart';
import 'package:seeds/providers/services/firebase/firebase_datastore_service.dart';
import 'package:seeds/providers/services/navigation_service.dart';
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
  double seedsValue = 0;
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
      price: seedsValue,
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
        price: seedsValue,
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

  void showEditProduct(
      BuildContext context, ProductModel productModel, String userAccount) {
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
                          onChanged: (amount, input, validate) => {
                                validate
                                    ? editKey.currentState.validate()
                                    : null,
                                seedsValue = amount,
                                currency = input,
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
                          onChanged: (amount, currencyInput, validate) => {
                                validate
                                    ? priceKey.currentState.validate()
                                    : "",
                                seedsValue = amount,
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
                        leading: buildCircleAvatar(product),
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

CircleAvatar buildCircleAvatar(ProductModel product, {double size = 20}) {
  return CircleAvatar(
    backgroundImage:
        product.picture.isNotEmpty ? NetworkImage(product.picture) : null,
    child: product.picture.isEmpty
        ? Container(
            color: AppColors.getColorByString(product.name),
            child: Center(
              child: Text(
                product.name == null ? "" : product.name.characters.first,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        : null,
    radius: size,
  );
}

class ReceiveForm extends StatefulWidget {
  @override
  _ReceiveFormState createState() => _ReceiveFormState();
}

class LineItem {
  ProductModel product;
  int quantity;

  LineItem({this.product, this.quantity});

  double seedsPrice(CurrencyConverter converter) {
    return quantity * product.seedsPrice(converter);   
  }
}

class CartModel {
  var lineItems = List<LineItem>();
  double donationDiscount = 0; // 0 - 1, negative for discount
  double customAmount = 0;

  CurrencyConverter currencyConverter;

  LineItem itemFor(ProductModel product) {
    return lineItems.firstWhere((e) => e.product.name == product.name, orElse: () => null);
  }

  int quantityFor(ProductModel product) {
    return itemFor(product)?.quantity ?? 0;
  }

  void add(ProductModel product, int quantity) {
    var item = itemFor(product);
    if (item != null) {
      item.quantity += quantity;
      if (item.quantity <= 0) {
        lineItems.remove(item);
      }
    } else {
      if (quantity > 0)
        lineItems.add(LineItem(product: product, quantity: quantity));
    }
  }

  void clear() {
    lineItems.clear();
  }

  bool isEmpty() {
    return lineItems.isEmpty;
  }

  double total() {
    if (lineItems.isEmpty) {
      return customAmount;
    } else {
      double total = 0;
      lineItems.forEach((item) {
        total =
            total + item.seedsPrice(currencyConverter);
      });
      return total + total * donationDiscount;
    }
  }
}

class _ReceiveFormState extends State<ReceiveForm> {
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController(text: '');

  final cart = CartModel();
  final products = List<ProductModel>();

  @override
  void didChangeDependencies() {
    loadProducts();
    super.didChangeDependencies();
  }

  void loadProducts() async {
    final accountName = EosService.of(this.context).accountName;

    final fbProducts =
        await FirebaseDatabaseService().getProductsForUser(accountName).first;

    products.clear();

    fbProducts.forEach((product) {
      products.add(product);
    });

    setState(() {});
  }

  void removeProductFromCart(ProductModel product, RateNotifier rateNotifier) {
    cart.currencyConverter = rateNotifier;
    setState(() {
      cart.add(product, -1);
    });
  }

  void removePriceDifference() {
    setState(() {
      cart.donationDiscount = 0;
    });
  }

  void addProductToCart(ProductModel product, RateNotifier rateNotifier) {
    cart.currencyConverter = rateNotifier;
    setState(() {
      cart.add(product, 1);
    });
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

  void generateInvoice(String amount) async {
    //double receiveAmount = double.tryParse(amount) ?? 0;

    setState(() {
      // invoiceAmountDouble = receiveAmount;
      // invoiceAmount = receiveAmount.toStringAsFixed(4);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!cart.isEmpty()) {
      controller.text = cart.total().seedsFormatted;
    }

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            MainTextField(
              focusNode: FocusNode(),
              suffixIcon: IconButton(
                icon: Icon(Icons.add_shopping_cart, color: AppColors.blue),
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  showMerchantCatalog(context);
                },
              ),
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
                          rateNotifier.amountToString(
                              cart.total(),
                              SettingsNotifier.of(context)
                                  .selectedFiatCurrency),
                          style: TextStyle(color: Colors.blue),
                        );
                      },
                    ))),
            cart.isEmpty()
                ? Container()
                : Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Consumer<RateNotifier>(
                        builder: (context, rateNotifier, child) => Column(
                            children: List<Widget>.of(
                                cart.lineItems.map((e) => Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                  child: Row(children: [
                                        buildCircleAvatar(e.product, size: 14),
                                        SizedBox(width:10),
                                        e.quantity > 1 ? Text("${e.quantity} x ",
                                          style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: "worksans")) : Container(),
                                        //SizedBox(width: 10),
                                        Text(e.product.name,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: "worksans")),
                                        Spacer(),
                                        // Text(
                                        //     e.quantity > 1
                                        //         ? e.quantity.toString()
                                        //         : "",
                                        //     style: TextStyle(
                                        //         fontSize: 14,
                                        //         fontWeight: FontWeight.w400,
                                        //         fontFamily: "worksans")),
                                        // SizedBox(width: 10),
                                        Text(
                                            e.seedsPrice(rateNotifier)
                                                .seedsFormatted,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: "worksans")),
                                      ]),
                                ))))),
                  ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 33, 0, 0),
              child: MainButton(
                  title: "Next".i18n,
                  active: cart.total() != 0,
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    NavigationService.of(context)
                        .navigateTo(Routes.receiveQR, cart.total());
                  }),
            ),
            products.length > 0 ? buildProductsList() : Container(),
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
