import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/providers/notifiers/auth_notifier.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/components/scanner/seeds_qr_code_scanner_widget.dart';
import 'package:seeds/v2/components/text_form_field_light_custom.dart';
import 'package:seeds/utils/invites.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/design/app_theme.dart';
import 'interactor/claim_invite_code_bloc.dart';


class ClaimInviteCodeScreen extends StatefulWidget {

  const ClaimInviteCodeScreen({Key key,})
      : super(key: key);

  @override
  _ClaimInviteCodeScreenState createState() => _ClaimInviteCodeScreenState();
}

class _ClaimInviteCodeScreenState extends State<ClaimInviteCodeScreen> {
  ClaimInviteCodeBloc _ClaimInviteCodeBloc;
  final _keyController = TextEditingController();
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    super.initState();
    _ClaimInviteCodeBloc = ClaimInviteCodeBloc(SettingsNotifier.of(context), AuthNotifier.of(context));
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
            children: [
              const SizedBox(
                height: 60,
              ),
              const Text(
                "Scan QR Code",
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 50,
              ),
              SeedsQRCodeScannerWidget(
                onQRViewCreated: _onQRViewCreated,
                qrKey: _qrKey,
              ),
              const SizedBox(
                height: 75,
              ),
              Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
                    color: AppColors.white),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Or enter by yourself below',
                          style: Theme.of(context).textTheme.subtitle2Black,
                          textAlign: TextAlign.end,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormFieldLightCustom(
                          controller: _keyController,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onQRViewCreated(QRViewController controller) async {
  }

  @override
  void dispose() {
  }

  void _onSubmitted() {

  }
}
