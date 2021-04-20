import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/components/text_form_field_custom.dart';
import 'package:seeds/i18n/edit_name.i18n.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/v2/datasource/remote/model/profile_model.dart';
import 'interactor/display_name_bloc.dart';
import 'package:seeds/providers/services/navigation_service.dart';

class DisplayName extends StatefulWidget {
  final String? inviteSecret;
  final String? initialName;
  final Function(String? nickName)? onSubmit;

  const DisplayName({Key? key, this.inviteSecret, this.initialName, this.onSubmit}) : super(key: key);

  @override
  _DisplayNameState createState() => _DisplayNameState();
}

class _DisplayNameState extends State<DisplayName> {
  //late EditNameBloc _editNameBloc;
  late DisplayNameBloc _DisplayNameBloc;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  ProfileModel? _profileModel;


  @override
  void initState() {
    super.initState();
    _DisplayNameBloc = DisplayNameBloc();
    _nameController.addListener(_onNameChanged);
  }

  Future<void> createAccountName() async {
    print("create acct ");

    final FormState form = _formKey.currentState!;

      form.save();

      print("siubmite" + _nameController.text);

      widget.onSubmit!(_nameController.text);

  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _DisplayNameBloc,
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormFieldCustom(
                  controller: _nameController,
                  labelText: 'Full Name'.i18n,
                  onFieldSubmitted: (_) => _onSubmitted(),
                  validator: (String? value) {
                     if (value!.length > 36) {
                       return 'Maximum 36 characters.';
                     }
                    return null;
                  },
                ),
                Expanded(
                    child: Text(
                  "Enter your full name. You will be able to change this later in your profile settings.".i18n,
                  style: Theme.of(context).textTheme.subtitle2OpacityEmphasis,
                )),
                FlatButtonLong(
                  onPressed: () {_onSubmitted();},
                  title: 'Next'.i18n,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
  //  _nameController.dispose();
    super.dispose();
  }

  void _onNameChanged() {
  //  _editNameBloc.add(OnNameChanged(name: _nameController.text));
  }


  void _onSubmitted() {
    if (_formKey.currentState!.validate()) {
     // NavigationService.of(context).navigateTo(Routes.createUserName);
    }
  }
}
