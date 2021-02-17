import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/settings/edit_name/interactor/set_currency/interactor/viewmodels/bloc.dart';

class SetCurrencyScreen extends StatelessWidget {
  const SetCurrencyScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SetCurrencyBloc()..add(LoadCurrencies()),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          title: TextField(
            decoration: InputDecoration(
              hintText: "Search..",
              hintStyle: Theme.of(context).textTheme.subtitle2,
              suffixIcon: IconButton(
                onPressed: () {},
                icon: Icon(Icons.search),
              ),
            ),
          ),
        ),
        body: BlocBuilder<SetCurrencyBloc, SetCurrencyState>(
          builder: (context, state) {
            switch (state.pageState) {
              case PageState.loading:
                return const Center(child: CircularProgressIndicator());
                break;
              case PageState.success:
                return ListView.builder(
                  itemCount: state.fiatRateModel.currencies.length,
                  itemBuilder: (ctx, index) => ListTile(
                    title: Text(state.fiatRateModel.currencies[index]),
                    onTap: () {
                      // SettingsNotifier.of(context).saveSelectedFiatCurrency(currencies[index]);
                      Navigator.of(context).pop();
                    },
                  ),
                );
                break;
              default:
                return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
