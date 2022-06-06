import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/select_picture_box/select_picture_box.dart';
import 'package:seeds/datasource/remote/model/firebase_models/region_event_model.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/explore_screens/regions_screens/edit_region_event/interactor/viewmodel/edit_region_event_bloc.dart';
import 'package:seeds/screens/explore_screens/regions_screens/edit_region_event/interactor/viewmodel/edit_region_event_page_commands.dart';
import 'package:seeds/utils/build_context_extension.dart';

class EditRegionEventImage extends StatelessWidget {
  const EditRegionEventImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final event = ModalRoute.of(context)!.settings.arguments as RegionEventModel?;

    return BlocProvider(
      create: (_) => EditRegionEventBloc(event!),
      child: BlocConsumer<EditRegionEventBloc, EditRegionEventState>(
        listenWhen: (previous, current) => current.pageCommand != null,
        listener: (context, state) {
          if (state.pageCommand != null) {
            final pageCommand = state.pageCommand;

            //need  a page command for this screen
            if (pageCommand is ShowErrorMessage) {
              eventBus.fire(ShowSnackBar(pageCommand.message));
            } else if (pageCommand is NavigateToRoute) {
              NavigationService.of(context).pushAndRemoveUntil(route: pageCommand.route, from: Routes.app);
            } else if (pageCommand is EditEventImage) {
              BlocProvider.of<EditRegionEventBloc>(context).add(const OnSaveChangesTapped());
            }

            BlocProvider.of<EditRegionEventBloc>(context).add(const ClearEditRegionEventPageCommand());
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text("Edit Event")),
            bottomNavigationBar: SafeArea(
                minimum: const EdgeInsets.all(horizontalEdgePadding),
                child: FlatButtonLong(
                    isLoading: state.isSaveChangesButtonLoading,
                    enabled: state.isSaveChangesButtonEnable,
                    title: "Save Image",
                    onPressed: () => BlocProvider.of<EditRegionEventBloc>(context).add(const OnSaveImageNextTapped()))),
            body: SafeArea(
              minimum: const EdgeInsets.all(horizontalEdgePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  SelectPictureBox(
                      pictureBoxState: state.pictureBoxState,
                      backgroundImage: state.file,
                      title: context.loc.createRegionAddBackGroundImageBoxTitle,
                      onTap: () => BlocProvider.of<EditRegionEventBloc>(context).add(const OnPickImage())),
                  const SizedBox(height: 10),
                  if (state.file != null)
                    Center(
                      child: MaterialButton(
                          color: AppColors.green1,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                          child: const Text("Replace Image"),
                          onPressed: () => BlocProvider.of<EditRegionEventBloc>(context).add(const OnPickImage())),
                    )
                  else
                    const SizedBox.shrink(),
                  const SizedBox(height: 20),
                  Text(context.loc.createRegionAddBackGroundImageAcceptedFilesTitle,
                      style: Theme.of(context).textTheme.subtitle2OpacityEmphasis)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
