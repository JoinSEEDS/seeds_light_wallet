import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/screens/settings/edit_name/viewmodels/bloc.dart';
import 'package:seeds/i18n/edit_name.i18n.dart';

class EditNameScreen extends StatefulWidget {
  const EditNameScreen({Key key}) : super(key: key);

  @override
  _EditNameScreenState createState() => _EditNameScreenState();
}

class _EditNameScreenState extends State<EditNameScreen> {
  EditNameBloc _editNameBloc;
  final _nameController = TextEditingController();
  final _formKeyPassword = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _editNameBloc = EditNameBloc();
    _nameController.text = 'Raul';
    _nameController.addListener(_onNameChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Display Name'.i18n)),
      body: Form(
        key: _formKeyPassword,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                style: Theme.of(context).textTheme.button,
                onFieldSubmitted: (_) => _onSubmitted(),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: FlatButtonLong(title: 'Save Changes'.i18n, onPressed: _onSubmitted()),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onNameChanged() {
    _editNameBloc.add(OnNameChanged(name: _nameController.text));
  }

  _onSubmitted() {
    // if (_formKeyPassword.currentState.validate()) {
    //   // _editNameBloc.add(SubmitName());
    // } else {
    //   // _editNameBloc.add(ActivateAutoValidate());
    // }
  }
}
