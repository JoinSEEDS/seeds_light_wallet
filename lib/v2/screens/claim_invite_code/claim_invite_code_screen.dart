import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/i18n/edit_name.i18n.dart';
import 'package:seeds/providers/notifiers/auth_notifier.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/components/scanner/seeds_qr_code_scanner_widget.dart';
import 'package:seeds/v2/components/text_form_field_custom.dart';
import 'package:seeds/v2/components/text_form_field_light_custom.dart';

import 'interactor/claim_invite_code_bloc.dart';

class ClaimInviteCodeScreen extends StatefulWidget {
  final ValueSetter<String> resultCallBack;

  const ClaimInviteCodeScreen({Key key, @required this.resultCallBack}) : super(key: key);

  @override
  _ClaimInviteCodeScreenState createState() => _ClaimInviteCodeScreenState();
}

class _ClaimInviteCodeScreenState extends State<ClaimInviteCodeScreen> {
  ClaimInviteCodeBloc _ClaimInviteCodeBloc;
  final _keyController = TextEditingController();
  final _formImportKey = GlobalKey<FormState>();
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController _controller;
  bool _handledQrCode = false;

  @override
  void initState() {
    super.initState();
    _ClaimInviteCodeBloc = ClaimInviteCodeBloc(SettingsNotifier.of(context), AuthNotifier.of(context));
    _keyController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _ClaimInviteCodeBloc,
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 60,
              ),
              Text(
                "Scan QR Code",
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 50,
              ),
              SeedsQRCodeScannerWidget(
                qrKey: _qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
              const SizedBox(
                height: 75,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
                    color: AppColors.white
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                     const  Text(
                        'Or enter by yourself below',
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.end,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormFieldLightCustom(
                        //borderColor: Colors.black,
                       // hintStyle: Theme.of(context).textTheme.subtitle2OpacityEmphasis.copyWith(color: Colors.grey),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Private Key cannot be empty';
                          }
                          return null;
                        },
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.paste,
                            color: AppColors.grey,
                          ),
                          onPressed: () async {
                            var clipboardData = await Clipboard.getData('text/plain');
                            var clipboardText = clipboardData?.text ?? '';
                            _keyController.text = clipboardText;
                            _onSubmitted();
                          },
                        ),
                        hintText: "Invite code (5 words)",
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      FlatButtonLong(title: 'Claim Code', onPressed: () => _onSubmitted()),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onQRViewCreated(QRViewController controller) async {
    _controller = controller;

    controller.scannedDataStream.listen(
      (String scanResult) async {
        if (_handledQrCode || scanResult == null) {
          return;
        }

        setState(() {
          _handledQrCode = true;
        });

        widget.resultCallBack(scanResult);
      },
    );
  }

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  void _onSubmitted() {
    FocusScope.of(context).unfocus();
    if (_formImportKey.currentState.validate()) {
      // _ClaimInviteCodeBloc.add(FindAccountByKey(userKey: _keyController.text));
    }
  }
}
