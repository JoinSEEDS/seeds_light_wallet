import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/flat_button_short.dart';
import 'package:seeds/components/select_picture_box/select_picture_box.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/screens/explore_screens/regions_screens/create_region_event_screens/interactor/viewmodels/create_region_event_bloc.dart';
import 'package:seeds/screens/explore_screens/regions_screens/create_region_event_screens/interactor/viewmodels/create_region_events_page_commands.dart';
import 'package:seeds/utils/build_context_extension.dart';

class AddRegionEventImage extends StatelessWidget {
  const AddRegionEventImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateRegionEventBloc, CreateRegionEventState>(
        listenWhen: (previous, current) => current.pageCommand != null,
        listener: (context, state) {
          if (state.pageCommand != null) {
            final pageCommand = state.pageCommand;

            if (pageCommand is ShowErrorMessage) {
              eventBus.fire(ShowSnackBar(pageCommand.message));
            }

            if (pageCommand is RemoveAuthenticationScreen) {
              // This pop remove the authentication screen
              Navigator.of(context).pop();
            }

            BlocProvider.of<CreateRegionEventBloc>(context).add(const ClearCreateRegionEventPageCommand());
          }
        },
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async {
              BlocProvider.of<CreateRegionEventBloc>(context).add(const OnBackPressed());
              return false;
            },
            child: Scaffold(
              appBar: AppBar(
                leading: BackButton(
                    onPressed: () => BlocProvider.of<CreateRegionEventBloc>(context).add(const OnBackPressed())),
                title: const Text("Create Event"),
              ),
              bottomNavigationBar: SafeArea(
                  minimum: const EdgeInsets.all(horizontalEdgePadding),
                  child: FlatButtonLong(
                      isLoading: state.isNextButtonLoading,
                      enabled: state.file != null,
                      title: "Next (5/5)",
                      onPressed: () =>
                          BlocProvider.of<CreateRegionEventBloc>(context).add(const OnPickImageNextTapped()))),
              body: SafeArea(
                minimum: const EdgeInsets.all(horizontalEdgePadding),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(height: 20),
                  SelectPictureBox(
                      pictureBoxState: state.pictureBoxState,
                      backgroundImage: state.file,
                      title: context.loc.createRegionAddBackGroundImageBoxTitle,
                      onTap: () => BlocProvider.of<CreateRegionEventBloc>(context).add(const OnPickImage())),
                  const SizedBox(height: 10),
                  if (state.file != null && !state.isNextButtonLoading)
                    FlatButtonShort(
                        title: 'Replace Image',
                        onPressed: () => BlocProvider.of<CreateRegionEventBloc>(context).add(const OnPickImage()))
                  else
                    const SizedBox.shrink(),
                  const SizedBox(height: 20),
                  Text(context.loc.createRegionAddBackGroundImageAcceptedFilesTitle,
                      style: Theme.of(context).textTheme.subtitle2OpacityEmphasis)
                ]),
              ),
            ),
          );
        });
  }
}
