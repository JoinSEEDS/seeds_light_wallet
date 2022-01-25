import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/quadstate_clipboard_icon_button.dart';
import 'package:seeds/components/search_result_row.dart';
import 'package:seeds/components/text_form_field_custom.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/authentication/recover/recover_account_search/interactor/viewmodels/recover_account_page_command.dart';
import 'package:seeds/screens/authentication/recover/recover_account_search/interactor/viewmodels/recover_account_search_bloc.dart';
import 'package:seeds/utils/debouncer.dart';

class RecoverAccountSearchScreen extends StatefulWidget {
  const RecoverAccountSearchScreen({Key? key}) : super(key: key);

  @override
  _RecoverAccountSearchScreenState createState() => _RecoverAccountSearchScreenState();
}

class _RecoverAccountSearchScreenState extends State<RecoverAccountSearchScreen> {
  final TextEditingController _keyController = TextEditingController();
  final Debouncer _debouncer = Debouncer(milliseconds: 600);

  @override
  void initState() {
    super.initState();
    _keyController.text = '';
  }

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (_) => RecoverAccountSearchBloc(),
      child: BlocConsumer<RecoverAccountSearchBloc, RecoverAccountSearchState>(
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
                title: localization.recoverAccountSearchButtonTitle,
                enabled: state.isGuardianActive,
                onPressed: () => BlocProvider.of<RecoverAccountSearchBloc>(context).add(const OnNextButtonTapped()),
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormFieldCustom(
                      maxLength: 12,
                      counterText: null,
                      labelText: localization.recoverAccountSearchTextFormTitle,
                      controller: _keyController,
                      suffixIcon: QuadStateClipboardIconButton(
                        isChecked: state.isGuardianActive,
                        onClear: () => _keyController.clear(),
                        isLoading: state.pageState == PageState.loading,
                        canClear: _keyController.text.isNotEmpty,
                      ),
                      onChanged: (value) {
                        _debouncer.run(
                            () => BlocProvider.of<RecoverAccountSearchBloc>(context).add(OnUsernameChanged(value)));
                      },
                    ),
                    if (state.accountFound)
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.darkGreen2,
                          borderRadius: BorderRadius.circular(defaultCardBorderRadius),
                        ),
                        child: SearchResultRow(
                          member: state.accountInfo!,
                          onTap: () =>
                              BlocProvider.of<RecoverAccountSearchBloc>(context).add(const OnNextButtonTapped()),
                        ),
                      ),
                    const SizedBox(height: 30),
                    if (state.errorMessage != null)
                      Center(
                        child: Text(
                          state.errorMessage!,
                          style: Theme.of(context).textTheme.subtitle3Red,
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
