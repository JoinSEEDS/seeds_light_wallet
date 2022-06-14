import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/text_form_field_custom.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/screens/profile_screens/edit_name/interactor/viewmodels/edit_name_bloc.dart';
import 'package:seeds/screens/profile_screens/edit_name/interactor/viewmodels/page_commands.dart';
import 'package:seeds/utils/build_context_extension.dart';

class EditNameScreen extends StatelessWidget {
  const EditNameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _profileModel = ModalRoute.of(context)!.settings.arguments as ProfileModel?;
    assert(_profileModel != null);
    return Scaffold(
      appBar: AppBar(title: Text(context.loc.editNameTitle)),
      body: BlocProvider(
        create: (_) => EditNameBloc(_profileModel!),
        child: BlocConsumer<EditNameBloc, EditNameState>(
          listenWhen: (_, current) => current.pageCommand != null,
          listener: (context, state) {
            final pageCommand = state.pageCommand;

            if (pageCommand is EditNameSuccess) {
              Navigator.of(context).pop(state.name);
            } else if (pageCommand is ShowErrorMessage) {
              eventBus.fire(ShowSnackBar(pageCommand.message));
              BlocProvider.of<EditNameBloc>(context).add(const ClearPageCommand());
            }
          },
          builder: (context, state) {
            switch (state.pageState) {
              case PageState.initial:
              case PageState.loading:
              case PageState.failure:
                return SafeArea(
                  minimum: const EdgeInsets.all(horizontalEdgePadding),
                  child: Form(
                    child: Column(
                      children: [
                        TextFormFieldCustom(
                          initialValue: state.name,
                          labelText: context.loc.editNameLabel,
                          onFieldSubmitted: (_) {
                            BlocProvider.of<EditNameBloc>(context).add(const SubmitName());
                          },
                          onChanged: (String value) {
                            BlocProvider.of<EditNameBloc>(context).add(OnNameChanged(name: value));
                          },
                          errorText: state.errorMessage,
                        ),
                        const Spacer(),
                        FlatButtonLong(
                          isLoading: state.pageState == PageState.loading,
                          enabled: state.isSubmitEnabled,
                          title: context.loc.editNameSaveButtonTitle,
                          onPressed: () {
                            BlocProvider.of<EditNameBloc>(context).add(const SubmitName());
                          },
                        )
                      ],
                    ),
                  ),
                );
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
