import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/i18n/set_currency.i18n.dart';
import 'package:seeds/v2/components/text_form_field_custom.dart';
import 'package:seeds/v2/datasource/local/models/currency.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/screens/profile_screens/set_currency/interactor/viewmodels/bloc.dart';

class SetCurrencyScreen extends StatefulWidget {
  const SetCurrencyScreen({Key key}) : super(key: key);

  @override
  _SetCurrencyScreenState createState() => _SetCurrencyScreenState();
}

class _SetCurrencyScreenState extends State<SetCurrencyScreen> {
  SetCurrencyBloc _setCurrencyBloc;
  final _queryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setCurrencyBloc = SetCurrencyBloc();
    _queryController.addListener(_onQueryChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _setCurrencyBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Select Currency'.i18n),
          elevation: 0.0,
        ),
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
                      break;
                    case PageState.loading:
                      return const Center(child: CircularProgressIndicator());
                      break;
                    case PageState.success:
                      return ListView.builder(
                        itemCount: state.queryCurrenciesResults.length,
                        itemBuilder: (ctx, index) => ListTile(
                          leading: Text(countryCodeToEmoji(state.queryCurrenciesResults[index]),
                              style: Theme.of(context).textTheme.headline4),
                          title: Text(state.queryCurrenciesResults[index].code),
                          subtitle: Text(state.queryCurrenciesResults[index].name),
                          onTap: () {
                            settingsStorage.saveSelectedFiatCurrency(state.queryCurrenciesResults[index].code);
                            Navigator.of(context).pop(state.queryCurrenciesResults[index].code);
                          },
                        ),
                      );
                      break;
                    default:
                      return const SizedBox.shrink(); // An error view??
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String countryCodeToEmoji(Currency currency) {
    final String countryCode = currency.flag;
    // 0x41 is Letter A
    // 0x1F1E6 is Regional Indicator Symbol Letter A
    // Example :
    // firstLetter U => 20 + 0x1F1E6
    // secondLetter S => 18 + 0x1F1E6
    // See: https://en.wikipedia.org/wiki/Regional_Indicator_Symbol
    final int firstLetter = countryCode.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final int secondLetter = countryCode.codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
  }

  void _onQueryChanged() {
    _setCurrencyBloc.add(OnQueryChanged(query: _queryController.text));
  }
}
