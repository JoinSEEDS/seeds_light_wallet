import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/text_form_field_custom.dart';
import 'package:seeds/datasource/remote/model/firebase_models/region_event_model.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/explore_screens/regions_screens/edit_region_event/interactor/viewmodel/edit_region_event_bloc.dart';
import 'package:seeds/utils/build_context_extension.dart';

class EditRegionEventNameAndDescription extends StatelessWidget {
  const EditRegionEventNameAndDescription({super.key});

  @override
  Widget build(BuildContext context) {
    final event = ModalRoute.of(context)!.settings.arguments as RegionEventModel?;
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Region Event")),
      body: BlocProvider(
        create: (_) => EditRegionEventBloc(event!),
        child: BlocConsumer<EditRegionEventBloc, EditRegionEventState>(
          listenWhen: (_, current) => current.pageCommand != null,
          listener: (context, state) {
            final pageCommand = state.pageCommand;

            if (pageCommand is NavigateToRoute) {
              NavigationService.of(context).pushAndRemoveUntil(route: pageCommand.route, from: Routes.app);
            } else if (pageCommand is ShowErrorMessage) {
              eventBus.fire(ShowSnackBar(pageCommand.message));
            }

            BlocProvider.of<EditRegionEventBloc>(context).add(const ClearEditRegionEventPageCommand());
          },
          builder: (context, state) {
            return SafeArea(
              minimum: const EdgeInsets.all(horizontalEdgePadding),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormFieldCustom(
                          initialValue: state.event.eventName,
                          autofocus: true,
                          labelText: "Event Name",
                          onChanged: (text) {
                            BlocProvider.of<EditRegionEventBloc>(context).add(OnEventNameChange(text));
                          },
                        ),
                        TextFormFieldCustom(
                          initialValue: state.event.eventDescription,
                          autofocus: true,
                          maxLines: 14,
                          labelText: context.loc.createRegionAddDescriptionInputFormTitle,
                          onChanged: (text) {
                            BlocProvider.of<EditRegionEventBloc>(context).add(OnEventDescriptionChange(text));
                          },
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FlatButtonLong(
                        enabled: state.isSaveChangesButtonEnable,
                        isLoading: state.isSaveChangesButtonLoading,
                        title: "Save Changes",
                        onPressed: () =>
                            BlocProvider.of<EditRegionEventBloc>(context).add(const OnSaveChangesTapped())),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
