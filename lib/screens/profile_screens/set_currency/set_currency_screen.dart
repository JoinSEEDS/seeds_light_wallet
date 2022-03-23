import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/components/text_form_field_custom.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/profile_screens/set_currency/interactor/viewmodels/set_currency_bloc.dart';
import 'package:seeds/utils/build_context_extension.dart';

class SetCurrencyScreen extends StatefulWidget {
  const SetCurrencyScreen({Key? key}) : super(key: key);

  @override
  _SetCurrencyScreenState createState() => _SetCurrencyScreenState();
}

class _SetCurrencyScreenState extends State<SetCurrencyScreen> {
  late SetCurrencyBloc _setCurrencyBloc;
  final _queryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setCurrencyBloc = SetCurrencyBloc()
      ..add(LoadCurrencies(BlocProvider.of<RatesBloc>(context).state.fiatRate?.rates ?? {}));
    _queryController.addListener(() {
      _setCurrencyBloc.add(OnQueryChanged(_queryController.text));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _setCurrencyBloc,
      child: Scaffold(
        appBar: AppBar(title: Text(context.loc.selectCurrencyTitle)),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormFieldCustom(
                controller: _queryController,
                textCapitalization: TextCapitalization.characters,
                hintText: context.loc.selectCurrencySearchHint,
                suffixIcon: const Icon(Icons.search),
              ),
            ),
            Expanded(
              child: BlocBuilder<SetCurrencyBloc, SetCurrencyState>(
                builder: (context, state) {
                  switch (state.pageState) {
                    case PageState.initial:
                      return const SizedBox.shrink();
                    case PageState.loading:
                      return const FullPageLoadingIndicator();
                    case PageState.failure:
                      return const FullPageErrorIndicator();
                    case PageState.success:
                      return SafeArea(
                        child: ListView.builder(
                          itemCount: state.queryCurrenciesResults!.length,
                          itemBuilder: (_, index) => ListTile(
                            key: Key(state.queryCurrenciesResults![index].code),
                            leading: Text(state.queryCurrenciesResults![index].flagEmoji,
                                style: Theme.of(context).textTheme.headline4),
                            title: Text(
                              state.queryCurrenciesResults![index].code,
                              style: Theme.of(context).textTheme.button,
                            ),
                            subtitle: Text(state.queryCurrenciesResults![index].name,
                                style: Theme.of(context).textTheme.subtitle4),
                            onTap: () {
                              settingsStorage.saveSelectedFiatCurrency(state.queryCurrenciesResults![index].code);
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ),
                      );
                    default:
                      return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
