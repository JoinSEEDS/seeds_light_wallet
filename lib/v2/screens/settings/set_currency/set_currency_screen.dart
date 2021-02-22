import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/settings/set_currency/interactor/viewmodels/bloc.dart';
import 'package:seeds/v2/components/text_form_field_custom.dart';
import 'package:seeds/i18n/set_currency.i18n.dart';

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
                  icon: Icon(Icons.search),
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
                        itemCount: state.currencyResult.length,
                        itemBuilder: (ctx, index) => ListTile(
                          leading: Image.asset('assets/currency/${state.currencyResult[index].toLowerCase()}.png'),
                          title: Text(state.currencyResult[index]),
                          onTap: () {
                            // TODO: this is a shared pref value must be handled by a global bloc Example: _settingsBloc.add(OnSelectedFiatCurrency(currency: state.currencyResult[index]));

                            // SettingsNotifier.of(context).saveSelectedFiatCurrency(currencies[index]);
                            Navigator.of(context).pop();
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

  void _onQueryChanged() {
    _setCurrencyBloc.add(OnQueryChanged(query: _queryController.text));
  }
}
