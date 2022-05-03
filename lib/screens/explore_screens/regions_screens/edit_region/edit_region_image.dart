import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/select_picture_box/select_picture_box.dart';
import 'package:seeds/datasource/remote/model/region_model.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/explore_screens/regions_screens/edit_region/interactor/viewmodel/edit_region_bloc.dart';
import 'package:seeds/screens/explore_screens/regions_screens/edit_region/interactor/viewmodel/edit_region_page_commads.dart';
import 'package:seeds/utils/build_context_extension.dart';

class EditRegionImage extends StatelessWidget {
  const EditRegionImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final region = ModalRoute.of(context)!.settings.arguments as RegionModel?;

    return BlocProvider(
      create: (_) => EditRegionBloc(region!),
      child: BlocConsumer<EditRegionBloc, EditRegionState>(
        listenWhen: (previous, current) => current.pageCommand != null,
        listener: (context, state) {
          if (state.pageCommand != null) {
            final pageCommand = state.pageCommand;

            //need  a page command for this screen
            if (pageCommand is RemoveAuthenticationScreen) {
              // This pop remove the authentication screen
              Navigator.of(context).pop();
            } else if (pageCommand is ShowErrorMessage) {
              eventBus.fire(ShowSnackBar(pageCommand.message));
            } else if (pageCommand is NavigateToRoute) {
              NavigationService.of(context).pushAndRemoveUntil(route: pageCommand.route, from: Routes.app);
            }

            BlocProvider.of<EditRegionBloc>(context).add(const ClearEditRegionPageCommand());
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text("Edit Region")),
            bottomNavigationBar: SafeArea(
                minimum: const EdgeInsets.all(horizontalEdgePadding),
                child: FlatButtonLong(
                    isLoading: state.isSaveChangesButtonLoading,
                    enabled: state.isSaveChangesButtonEnable,
                    title: "Save Image",
                    // TODO(gguij004): next pr
                    onPressed: () => {})),
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
                      onTap: () => BlocProvider.of<EditRegionBloc>(context).add(const OnPickImage())),
                  const SizedBox(height: 10),
                  if (state.file != null)
                    Center(
                      child: MaterialButton(
                          color: AppColors.green1,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                          child: const Text("Replace Image"),
                          onPressed: () => BlocProvider.of<EditRegionBloc>(context).add(const OnPickImage())),
                    )
                  else
                    const SizedBox.shrink(),
                  const SizedBox(height: 20),
                  Text(context.loc.createRegionAddBackGroundImageDescription,
                      style: Theme.of(context).textTheme.subtitle2OpacityEmphasis),
                  Text("${context.loc.createRegionAddBackGroundImageAcceptedFilesTitle}: .png//.jpg",
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
