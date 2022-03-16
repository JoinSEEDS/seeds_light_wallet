import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/screens/create_region_screens/add_region_background_image/components/upload_picture_box.dart';
import 'package:seeds/screens/create_region_screens/interactor/viewmodels/create_region_bloc.dart';
import 'package:seeds/utils/build_context_extension.dart';

class AddRegionBackgroundImage extends StatelessWidget {
  const AddRegionBackgroundImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateRegionBloc, CreateRegionState>(
        listenWhen: (previous, current) => current.pageCommand != null || previous.file != current.file,
        listener: (context, state) {
          if (state.pageCommand != null) {
            final pageCommand = state.pageCommand;

            if (pageCommand is ShowErrorMessage) {
              eventBus.fire(ShowSnackBar(pageCommand.message));
            }
          } else {
            // This pop remove the authentication screen
            Navigator.of(context).pop();
          }
        },
        builder: (context, CreateRegionState state) {
          return WillPopScope(
              onWillPop: () async {
                BlocProvider.of<CreateRegionBloc>(context).add(const OnBackPressed());
                return false;
              },
              child: Scaffold(
                  appBar: AppBar(
                    leading: BackButton(
                        onPressed: () => BlocProvider.of<CreateRegionBloc>(context).add(const OnBackPressed())),
                    title: Text(context.loc.createRegionSelectRegionAppBarTitle),
                  ),
                  bottomNavigationBar: SafeArea(
                      minimum: const EdgeInsets.all(horizontalEdgePadding),
                      child: FlatButtonLong(
                          enabled: state.isUploadImageNextButtonEnable,
                          title: "${context.loc.createRegionSelectRegionButtonTitle} (5/5)",
                          onPressed: () =>
                              BlocProvider.of<CreateRegionBloc>(context).add(const OnPickImageNextTapped()))),
                  body: SafeArea(
                      minimum: const EdgeInsets.all(horizontalEdgePadding),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const SizedBox(height: 20),
                        UploadPictureBox(
                            pictureBoxState: state.pictureBoxState,
                            backgroundImage: state.file,
                            title: context.loc.createRegionAddBackGroundImageBoxTitle,
                            onTap: () => BlocProvider.of<CreateRegionBloc>(context).add(const OnPickImage())),
                        const SizedBox(height: 10),
                        if (state.file != null)
                          Center(
                            child: MaterialButton(
                                color: AppColors.green1,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                child: const Text("Replace Image"),
                                onPressed: () => BlocProvider.of<CreateRegionBloc>(context).add(const OnPickImage())),
                          )
                        else
                          const SizedBox.shrink(),
                        const SizedBox(height: 20),
                        Text(context.loc.createRegionAddBackGroundImageDescription,
                            style: Theme.of(context).textTheme.subtitle2OpacityEmphasis),
                        Text("${context.loc.createRegionAddBackGroundImageAcceptedFilesTitle}: png//.jpg",
                            style: Theme.of(context).textTheme.subtitle2OpacityEmphasis)
                      ]))));
        });
  }
}
