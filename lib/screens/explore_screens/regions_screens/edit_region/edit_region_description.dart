import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/text_form_field_custom.dart';
import 'package:seeds/datasource/remote/model/region_model.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/explore_screens/regions_screens/edit_region/interactor/viewmodel/edit_region_bloc.dart';
import 'package:seeds/utils/build_context_extension.dart';

class EditRegionDescription extends StatelessWidget {
  const EditRegionDescription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final region = ModalRoute.of(context)!.settings.arguments as RegionModel?;
    return BlocProvider(
      create: (_) => EditRegionBloc(region!),
      child: BlocConsumer<EditRegionBloc, EditRegionState>(
        listenWhen: (_, current) => current.pageCommand != null,
        listener: (context, state) {
          final pageCommand = state.pageCommand;

          if (pageCommand is NavigateToRoute) {
            NavigationService.of(context).pushAndRemoveUntil(route: pageCommand.route, from: Routes.app);
          } else if (pageCommand is ShowErrorMessage) {
            eventBus.fire(ShowSnackBar(pageCommand.message));
          }

          BlocProvider.of<EditRegionBloc>(context).add(const ClearEditRegionPageCommand());
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text("Edit Region")),
            body: SafeArea(
              minimum: const EdgeInsets.all(horizontalEdgePadding),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormFieldCustom(
                          initialValue: state.region.description,
                          autofocus: true,
                          maxLines: 14,
                          labelText: context.loc.createRegionAddDescriptionInputFormTitle,
                          onChanged: (text) {
                            BlocProvider.of<EditRegionBloc>(context).add(OnRegionDescriptionChange(text));
                          },
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FlatButtonLong(
                      isLoading: state.isSaveChangesButtonLoading,
                      enabled: state.newRegionDescription.isNotEmpty &&
                          state.newRegionDescription != state.region.description,
                      title: "Save Changes",
                      onPressed: () => BlocProvider.of<EditRegionBloc>(context).add(
                        const OnEditRegionSaveChangesTapped(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
