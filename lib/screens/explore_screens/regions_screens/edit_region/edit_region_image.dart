import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/select_picture_box/select_picture_box.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/interactor/viewmodel/region_bloc.dart';
import 'package:seeds/utils/build_context_extension.dart';

class EditRegionImage extends StatelessWidget {
  const EditRegionImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegionBloc, RegionState>(
      listenWhen: (previous, current) => current.pageCommand != null,
      listener: (context, state) {
        if (state.pageCommand != null) {
          final pageCommand = state.pageCommand;

          if (pageCommand is ShowErrorMessage) {
            eventBus.fire(ShowSnackBar(pageCommand.message));
          } else if (pageCommand is RemoveAuthenticationScreen) {
            // This pop remove the authentication screen
            Navigator.of(context).pop();
          }

          BlocProvider.of<RegionBloc>(context).add(const ClearRegionPageCommand());
        }
      },
      builder: (context, RegionState state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Edit Region"),
          ),
          bottomNavigationBar: SafeArea(
              minimum: const EdgeInsets.all(horizontalEdgePadding),
              child: FlatButtonLong(
                  isLoading: state.isSaveChangesButtonLoading,
                  enabled: state.newImageFile != null,
                  title: "Save changes",
                  // change name
                  onPressed: () => BlocProvider.of<RegionBloc>(context).add(const OnPickImageNextTapped()))),
          body: SafeArea(
            minimum: const EdgeInsets.all(horizontalEdgePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                SelectPictureBox(
                    pictureBoxState: state.pictureBoxState,
                    backgroundImage: state.newImageFile,
                    title: context.loc.createRegionAddBackGroundImageBoxTitle,
                    onTap: () => BlocProvider.of<RegionBloc>(context).add(const OnPickImage())),
                const SizedBox(height: 10),
                if (state.newImageFile != null)
                  Center(
                    child: MaterialButton(
                        color: AppColors.green1,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        child: const Text("Replace Image"),
                        onPressed: () => BlocProvider.of<RegionBloc>(context).add(const OnPickImage())),
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
    );
  }
}
