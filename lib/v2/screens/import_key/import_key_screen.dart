import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/i18n/edit_name.i18n.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/components/full_page_error_indicator.dart';
import 'package:seeds/v2/components/full_page_loading_indicator.dart';
import 'package:seeds/v2/components/text_form_field_custom.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/import_key/interactor/import_key_bloc.dart';
import 'package:seeds/v2/screens/import_key/interactor/viewmodels/import_key_events.dart';
import 'package:seeds/v2/screens/import_key/interactor/viewmodels/import_key_state.dart';

class ImportKeyScreen extends StatefulWidget {
  const ImportKeyScreen({Key key}) : super(key: key);

  @override
  _ImportKeyScreenState createState() => _ImportKeyScreenState();
}

class _ImportKeyScreenState extends State<ImportKeyScreen> {
  ImportKeyBloc _importKeyBloc;
  final _keyController = TextEditingController();
  final _formImportKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _importKeyBloc = ImportKeyBloc();
    _keyController.text = '';
    _keyController.addListener(_onKeyChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: Column(
        children: [
          Form(
            key: _formImportKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormFieldCustom(
                    labelText: 'Private Key'.i18n,
                    controller: _keyController,
                    onFieldSubmitted: (_) => _onSubmitted(),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Private Key cannot be empty';
                      }
                      return null;
                    },
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: FlatButtonLong(title: 'Search', onPressed: () => _onSubmitted()),
                  )
                ],
              ),
            ),
          ),
          BlocProvider(
            create: (context) => _importKeyBloc,
            child: BlocBuilder<ImportKeyBloc, ImportKeyState>(builder: (context, state) {
              switch (state.pageState) {
                case PageState.initial:
                  return const SizedBox.shrink();
                case PageState.success:
                  return Container(
                    child: Text("Worked"),
                  );
                case PageState.loading:
                  return const FullPageLoadingIndicator();
                case PageState.failure:
                  return const FullPageErrorIndicator();
                default:
                  return const SizedBox.shrink();
              }
            }),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  void _onKeyChanged() {
    if (_formImportKey.currentState.validate()) {
      _importKeyBloc.add(FindAccountByKey(userKey: _keyController.text));
    }
  }

  void _onSubmitted() {
    if (_formImportKey.currentState.validate()) {
      _importKeyBloc.add(FindAccountByKey(userKey: _keyController.text));
    }
  }
}
