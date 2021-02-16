import 'package:flutter/material.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/v2/screens/settings/edit_name/components/flat_button_long.dart';
import 'package:seeds/v2/screens/settings/edit_name/components/text_form_field_custom.dart';
import 'package:seeds/v2/screens/settings/edit_name/interactor/edit_name_bloc.dart';
import 'package:seeds/v2/screens/settings/edit_name/viewmodels/edit_name_event.dart';

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
    _editNameBloc = EditNameBloc(
        // profileRepository: RepositoryProvider.of<ProfileRepository>(context),
        );
    _nameController.text = 'Raul';
    _nameController.addListener(_onNameChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(title: Text('Edit Display Name'), elevation: 0.0),
      body: Form(
        key: _formKeyPassword,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormFieldCustom(
                controller: _nameController,
                onFieldSubmitted: (_) => _onSubmitted(),
                // maxLength: state.password.maxLengthRequired,
                // hintText: state.password.placeHolder,
                // labelText: state.password.label,
                labelText: 'Display name',
                hintText: '',
                // validator: (_) {
                //   return state.password.isValid == true ? null : state.password.error;
                // },
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: FlatButtonLong(title: 'Save Changes', onPressed: () {}),
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
    if (_formKeyPassword.currentState.validate()) {
      // _editNameBloc.add(SubmitName());
    } else {
      // _editNameBloc.add(ActivateAutoValidate());
    }
  }
}
