import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/i18n/set_currency.i18n.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/bloc.dart';
import 'package:seeds/v2/components/full_page_error_indicator.dart';
import 'package:seeds/v2/components/full_page_loading_indicator.dart';
import 'package:seeds/v2/components/text_form_field_custom.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/screens/profile_screens/set_currency/interactor/viewmodels/bloc.dart';

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
      ..add(LoadCurrencies(rates: BlocProvider.of<RatesBloc>(context).state.fiatRate!.rates));
    _queryController.addListener(_onQueryChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _setCurrencyBloc,
      child: Scaffold(
        appBar: AppBar(title: Text('Select Currency'.i18n)),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormFieldCustom(
                controller: _queryController,
                textCapitalization: TextCapitalization.characters,
                hintText: "Search..".i18n,
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                ),
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
                      return ListView.builder(
                        itemCount: state.queryCurrenciesResults!.length,
                        itemBuilder: (ctx, index) => ListTile(
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

  void _onQueryChanged() {
    _setCurrencyBloc.add(OnQueryChanged(query: _queryController.text));
  }
}
