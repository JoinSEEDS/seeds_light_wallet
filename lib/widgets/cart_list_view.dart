import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/models/cart_model.dart';
import 'package:seeds/providers/notifiers/rate_notiffier.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/utils/double_extension.dart';
import 'package:seeds/widgets/circle_avatar_factory.dart';
import 'package:seeds/i18n/wallet.i18n.dart';

class CartListView extends StatefulWidget {
  const CartListView({Key key, @required this.cart, this.onChange})
      : super(key: key);

  final CartModel cart;
  final Function onChange;

  @override
  _CartListViewState createState() => _CartListViewState();
}

class _CartListViewState extends State<CartListView> {
  @override
  Widget build(BuildContext context) {
    var fiat = SettingsNotifier.of(context).selectedFiatCurrency;
    bool smallDevice = MediaQuery.of(context).size.width <= 500;

    return Consumer<RateNotifier>(
        builder: (context, rateNotifier, child) => Column(
          children: [
            Column(
                children: 
                  List<Widget>.of(widget.cart.lineItems.map((e) => Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                      child: Row(children: [
                        smallDevice ? Container() : CircleAvatarFactory.buildProductAvatar(e.product, size: 20),
                        SizedBox(width: 10),
                        SizedBox(
                          width: smallDevice ? 50 : 100,
                          child: Text(e.product.name,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "worksans")),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.remove_circle,
                          ),
                          color: Colors.redAccent,
                          disabledColor: Colors.grey,
                          onPressed: e.quantity == 0
                              ? null
                              : () {
                                  setState(() {
                                    widget.cart.remove(e.product);
                                  });
                                  widget.onChange();
                                },
                        ),
                        Text(e.quantity.toString(),
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                fontFamily: "worksans")),
                        IconButton(
                          icon: Icon(
                            Icons.add_circle,
                            color: Colors.greenAccent,
                          ),
                          onPressed: () {
                            setState(() {
                              widget.cart.add(e.product);
                            });
                            widget.onChange();
                          },
                        ),
                        Spacer(),
                        Text( (e.seedsPrice(rateNotifier) * e.quantity).seedsFormatted,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontFamily: "worksans")),
                      ]
                      ),
                    ))
                    )

                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 3,
                      height: 24,
                    ),
                    Row(
                      children:
                      [ 
                        Text("Total".i18n,
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                fontFamily: "worksans")),
                        Spacer(),
                        Text(widget.cart.total.seedsFormatted + " SEEDS",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                fontFamily: "worksans")),
                      ]
                    ),
                    Row(
                      children:
                      [ 
                        Spacer(),
                        Text( rateNotifier.seedsTo(widget.cart.total, fiat).fiatFormatted + " $fiat",
                            style: TextStyle(
                                color: AppColors.blue,
                                fontSize: 22,
                                fontWeight: FontWeight.w400,
                                fontFamily: "worksans")),
                      ]
                    )
          ],
        )
                );
  }
}