import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/i18n/edit_name.i18n.dart';
import 'package:seeds/v2/datasource/remote/model/profile_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/components/text_form_field_custom.dart';
import 'package:seeds/v2/components/full_page_error_indicator.dart';
import 'package:seeds/v2/components/full_page_loading_indicator.dart';
import 'package:seeds/v2/screens/profile_screens/edit_name/interactor/viewmodels/bloc.dart';

class EditNameScreen extends StatefulWidget {
  const EditNameScreen({Key? key}) : super(key: key);

  @override
  _EditNameScreenState createState() => _EditNameScreenState();
}

class _EditNameScreenState extends State<EditNameScreen> {
  late EditNameBloc _editNameBloc;
  ProfileModel? _profileModel;
  final _nameController = TextEditingController();
  final _formKeyName = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _editNameBloc = EditNameBloc();
    _nameController.addListener(_onNameChanged);
  }

  @override
  Widget build(BuildContext context) {
    // TODO(raul): I do not like this way to retrive a value from navigation, https://github.com/JoinSEEDS/seeds_light_wallet/issues/500.
    _profileModel = ModalRoute.of(context)!.settings.arguments as ProfileModel?;
    _nameController.text = _profileModel!.nickname!;
    return Scaffold(
      appBar: AppBar(title: Text('Edit Name'.i18n)),
      body: BlocProvider(
        create: (context) => _editNameBloc,
        child: BlocConsumer<EditNameBloc, EditNameState>(
            listenWhen: (previous, current) =>
                previous.pageState != PageState.success && current.pageState == PageState.success,
            listener: (context, state) => Navigator.of(context).pop(state.name),
            builder: (context, state) {
              switch (state.pageState) {
                case PageState.initial:
                  return Form(
                    key: _formKeyName,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextFormFieldCustom(
                            labelText: 'Name'.i18n,
                            controller: _nameController,
                            onFieldSubmitted: (_) => _onSubmitted(),
                            validator: (value) {
                              if (value!.length > 42) {
                                return 'Please enter a smaller name'.i18n;
                              }
                              return null;
                            },
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: FlatButtonLong(title: 'Save Changes'.i18n, onPressed: () => _onSubmitted()),
                          )
                        ],
                      ),
                    ),
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

  void _onSubmitted() {
    if (_formKeyName.currentState!.validate()) {
      _editNameBloc.add(SubmitName(profile: _profileModel));
    }
  }
}
