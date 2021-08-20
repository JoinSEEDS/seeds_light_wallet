import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/quadstate_clipboard_icon_button.dart';
import 'package:seeds/components/search_result_row.dart';
import 'package:seeds/components/text_form_field_custom.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/authentication/recover/recover_account_search/interactor/recover_account_bloc.dart';
import 'package:seeds/screens/authentication/recover/recover_account_search/interactor/viewmodels/recover_account_events.dart';
import 'package:seeds/screens/authentication/recover/recover_account_search/interactor/viewmodels/recover_account_page_command.dart';
import 'package:seeds/screens/authentication/recover/recover_account_search/interactor/viewmodels/recover_account_state.dart';
import 'package:seeds/utils/debouncer.dart';
import 'package:seeds/i18n/authentication/recover/recover.i18n.dart';

class RecoverAccountScreen extends StatefulWidget {
  const RecoverAccountScreen({Key? key}) : super(key: key);

  @override
  _RecoverAccountScreenState createState() => _RecoverAccountScreenState();
}

class _RecoverAccountScreenState extends State<RecoverAccountScreen> {
  final TextEditingController _keyController = TextEditingController();
  final Debouncer _debouncer = Debouncer(milliseconds: 600);

  @override
  void initState() {
    super.initState();
    _keyController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RecoverAccountBloc(),
      child: BlocConsumer<RecoverAccountBloc, RecoverAccountState>(
        listenWhen: (_, current) => current.pageCommand != null,
        listener: (context, state) {
          final pageCommand = state.pageCommand;
          if (pageCommand is NavigateToRecoverAccountFound) {
            NavigationService.of(context).navigateTo(Routes.recoverAccountFound, pageCommand.userAccount);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            bottomSheet: Padding(
              padding: const EdgeInsets.all(horizontalEdgePadding),
              child: FlatButtonLong(
                title: 'Next'.i18n,
                enabled: state.isGuardianActive,
                onPressed: () {
                  BlocProvider.of<RecoverAccountBloc>(context).add(OnNextButtonTapped());
                },
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormFieldCustom(
                    maxLength: 12,
                    counterText: null,
                    labelText: "Username".i18n,
                    controller: _keyController,
                    suffixIcon: QuadStateClipboardIconButton(
                      isChecked: state.isGuardianActive,
                      onClear: () {
                        _keyController.clear();
                      },
                      isLoading: state.pageState == PageState.loading,
                      canClear: _keyController.text.isNotEmpty,
                    ),
                    onChanged: (String value) {
                      _debouncer.run(() {
                        BlocProvider.of<RecoverAccountBloc>(context).add(OnUsernameChanged(value));
                      });
                    },
                  ),
                  if (state.isValidAccount)
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.darkGreen2,
                        borderRadius: BorderRadius.circular(defaultCardBorderRadius),
                      ),
                      child: SearchResultRow(
                        imageUrl: state.accountImage,
                        account: state.userName!,
                        name: state.accountName,
                        resultCallBack: () => BlocProvider.of<RecoverAccountBloc>(context).add(OnNextButtonTapped()),
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                  const SizedBox(height: 30),
                  if (state.errorMessage != null)
                    Center(
                      child: Text(
                        state.errorMessage!,
                        style: Theme.of(context).textTheme.subtitle3Red,
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
