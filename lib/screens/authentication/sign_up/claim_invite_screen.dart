import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/blocs/deeplink/viewmodels/deeplink_bloc.dart';
import 'package:seeds/components/scanner/scanner_view.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/images/signup/claim_invite/invite_link_success.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/authentication/sign_up/components/invite_link_fail_dialog.dart';
import 'package:seeds/screens/authentication/sign_up/viewmodels/page_commands.dart';
import 'package:seeds/screens/authentication/sign_up/viewmodels/signup_bloc.dart';
import 'package:seeds/utils/build_context_extension.dart';

class ClaimInviteScreen extends StatefulWidget {
  const ClaimInviteScreen({super.key});

  @override
  _ClaimInviteScreenState createState() => _ClaimInviteScreenState();
}

class _ClaimInviteScreenState extends State<ClaimInviteScreen> {
  late SignupBloc _signupBloc;
  late ScannerView _scannerWidget;

  @override
  void initState() {
    super.initState();
    _signupBloc = BlocProvider.of<SignupBloc>(context);
    _scannerWidget = ScannerView(onCodeScanned: (scannedLink) => _signupBloc.add(OnQRScanned(scannedLink)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, SignupState>(
      listenWhen: (_, current) => current.pageCommand != null,
      listener: (context, state) async {
        final pageCommand = state.pageCommand;
        _signupBloc.add(const ClearSignupPageCommand());
        if (pageCommand is StartScan) {
          _scannerWidget.scan();
        } else if (pageCommand is ShowErrorMessage) {
          await showDialog<void>(
            context: context,
            builder: (_) => const InviteLinkFailDialog(),
          ).whenComplete(() {
            if (state.fromDeepLink) {
              BlocProvider.of<DeeplinkBloc>(context).add(const ClearDeepLink());
              NavigationService.of(context).pushAndRemoveAll(Routes.login); // return user to login
            } else {
              _signupBloc.add(OnInvalidInviteDialogClosed()); // init scan again
            }
          });
        }
      },
      child: BlocBuilder<SignupBloc, SignupState>(
        builder: (context, state) {
          final view = state.claimInviteView;
          switch (view) {
            case ClaimInviteView.scanner:
              return Scaffold(appBar: AppBar(title: Text(context.loc.signUpScanQRCode)), body: _scannerWidget);
            case ClaimInviteView.processing:
            case ClaimInviteView.success:
            case ClaimInviteView.fail:
              return Scaffold(
                backgroundColor: AppColors.primary,
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          if (view == ClaimInviteView.processing)
                            Column(
                              children: [
                                const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.green1),
                                  backgroundColor: Colors.transparent,
                                ),
                                const SizedBox(height: 30),
                                Text(
                                  context.loc.signUpProcessingYourInvitation,
                                  style: Theme.of(context).textTheme.headline7,
                                )
                              ],
                            ),
                          if (view == ClaimInviteView.success)
                            Column(
                              children: [
                                const CustomPaint(size: Size(70, 70), painter: InviteLinkSuccess()),
                                const SizedBox(height: 30),
                                Text(context.loc.signUpSuccess, style: Theme.of(context).textTheme.headline7),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
