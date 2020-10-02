import 'package:flutter/material.dart' hide Action;
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/main_text_field.dart';
import 'package:seeds/i18n/wallet.i18n.dart';

class Merchant extends StatefulWidget {
  Merchant({Key key}) : super(key: key);

  @override
  _MerchantState createState() => _MerchantState();
}

class _MerchantState extends State<Merchant> {
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController(text: '');
  String invoiceAmount = '0.00 SEEDS';
  double invoiceAmountDouble = 0;

  bool isMerchantMode = true;

  List<ItemModel> items = [
    ItemModel(
      name: 'Cake #1',
      price: 1.0000,
    ),
    ItemModel(
      name: 'Cake #2',
      price: 2.0000,
    ),
  ];

  void generateInvoice(String amount) async {
    double receiveAmount = double.tryParse(amount) ?? 0;

    setState(() {
      invoiceAmountDouble = receiveAmount;
      invoiceAmount = receiveAmount.toStringAsFixed(4);
    });
  }

  Widget buildMerchant() {
    return ListView.builder(
      itemBuilder: (ctx, index) => ListTile(
        title: Text(items[index].name),
        subtitle: Text(items[index].price.toString()),
      ),
      itemCount: items.length,
    );
  }

  Widget buildInvoice() {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            MainTextField(
              keyboardType:
                  TextInputType.numberWithOptions(signed: false, decimal: true),
              controller: controller,
              labelText: 'Receive'.i18n,
              endText: 'SEEDS',
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
      ),
    );
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  Widget buildAddSheet() {
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets +
          EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 15,
          ),
      duration: Duration(milliseconds: 100),
      curve: Curves.decelerate,
      child: Container(
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
              title: 'Add Item',
              onPressed: () {
                items.add(ItemModel(
                  name: nameController.text,
                  price: double.parse(priceController.text),
                ));
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              Switch(
                onChanged: (val) {
                  setState(() {
                    isMerchantMode = val;
                  });
                },
                value: isMerchantMode,
              ),
            ],
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              EosService.of(context).accountName,
              style: TextStyle(color: Colors.black87),
            )),
        backgroundColor: Colors.white,
        floatingActionButton: isMerchantMode
            ? FloatingActionButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (ctx) {
                      return buildAddSheet();
                    },
                  );
                },
                child: Icon(
                  Icons.add,
                ),
              )
            : Container(),
        body: isMerchantMode ? buildMerchant() : buildInvoice());
  }
}
