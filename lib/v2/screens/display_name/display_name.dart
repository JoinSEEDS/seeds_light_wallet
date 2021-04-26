import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/components/text_form_field_custom.dart';
import 'package:seeds/i18n/edit_name.i18n.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/v2/screens/display_name/interactor/viewmodels/display_name_arguments.dart';
import 'interactor/display_name_bloc.dart';
import 'interactor/viewmodels/display_name_events.dart';


class DisplayName extends StatelessWidget {
  const DisplayName({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final DisplayNameArguments? arguments = ModalRoute.of(context)!.settings.arguments as DisplayNameArguments?;

    return BlocProvider(
      create: (context) => DisplayNameBloc()..add(InitDisplayNameConfirmationWithArguments(arguments: arguments!)),
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            //key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormFieldCustom(
                 // controller: _nameController,
                  labelText: 'Full Name'.i18n,
                  //onFieldSubmitted: (_) => _onSubmitted(),
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
                  onPressed: () {},
                  title: 'Next'.i18n,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // @override
  // void dispose() {
  // //  _nameController.dispose();
  //   super.dispose();
  // }

  // void _onNameChanged() {
  // //  _editNameBloc.add(OnNameChanged(name: _nameController.text));
  // }


  // void _onSubmitted() {
  //   if (_formKey.currentState!.validate()) {
  //     NavigationService.of(context).navigateTo(Routes.createUserName,[_nameController.text ]);
  //   }
  }

