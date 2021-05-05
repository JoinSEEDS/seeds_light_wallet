import 'package:flutter/material.dart' hide Action;
import 'package:flutter/rendering.dart';
import 'package:seeds/models/cart_model.dart';
import 'package:seeds/v2/navigation/navigation_service.dart';
import 'package:seeds/widgets/cart_list_view.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/i18n/wallet.i18n.dart';

class ReceiveConfirmation extends StatefulWidget {
  final CartModel? cart;

  const ReceiveConfirmation({Key? key, required this.cart}) : super(key: key);

  @override
  _ReceiveConfirmationState createState() => _ReceiveConfirmationState();
}

class _ReceiveConfirmationState extends State<ReceiveConfirmation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Receipt',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: MainButton(
            title: "Next".i18n,
            active: widget.cart!.total != 0,
            onPressed: () {
              FocusScope.of(context).unfocus();
              NavigationService.of(context).navigateTo(Routes.receiveQR, widget.cart!.total);
            }),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 15, right: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: CartListView(
                  cart: widget.cart,
                  onChange: () => setState(() {}),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
