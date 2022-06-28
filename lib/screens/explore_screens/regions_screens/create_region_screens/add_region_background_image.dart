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
import 'package:seeds/screens/explore_screens/regions_screens/create_region_screens/interactor/viewmodels/create_region_bloc.dart';
import 'package:seeds/utils/build_context_extension.dart';

class AddRegionBackgroundImage extends StatelessWidget {
  const AddRegionBackgroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateRegionBloc, CreateRegionState>(
      listenWhen: (previous, current) => current.pageCommand != null,
      listener: (context, state) {
        if (state.pageCommand != null) {
          final pageCommand = state.pageCommand;
          if (pageCommand is ShowErrorMessage) {
            eventBus.fire(ShowSnackBar(pageCommand.message));
          }
          BlocProvider.of<CreateRegionBloc>(context).add(const ClearCreateRegionPageCommand());
        }
      },
      child: WillPopScope(
        onWillPop: () async {
          BlocProvider.of<CreateRegionBloc>(context).add(const OnBackPressed());
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            leading: BackButton(onPressed: () => BlocProvider.of<CreateRegionBloc>(context).add(const OnBackPressed())),
            title: Text(context.loc.createRegionSelectRegionAppBarTitle),
          ),
          body: SafeArea(
            minimum: const EdgeInsets.all(horizontalEdgePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                BlocBuilder<CreateRegionBloc, CreateRegionState>(
                  buildWhen: (previous, current) {
                    return previous.pictureBoxState != current.pictureBoxState || previous.file != current.file;
                  },
                  builder: (context, state) {
                    return SelectPictureBox(
                      pictureBoxState: state.pictureBoxState,
                      backgroundImage: state.file,
                      title: context.loc.createRegionAddBackGroundImageBoxTitle,
                      onTap: () => BlocProvider.of<CreateRegionBloc>(context).add(const OnPickImage()),
                    );
                  },
                ),
                const SizedBox(height: 10),
                BlocBuilder<CreateRegionBloc, CreateRegionState>(
                  buildWhen: (previous, current) => previous.file != current.file,
                  builder: (context, state) {
                    return state.file != null
                        ? FlatButtonShort(
                            title: 'Replace Image',
                            onPressed: () => BlocProvider.of<CreateRegionBloc>(context).add(const OnPickImage()),
                          )
                        : const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 20),
                Text(context.loc.createRegionAddBackGroundImageAcceptedFilesTitle,
                    style: Theme.of(context).textTheme.subtitle2OpacityEmphasis)
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            minimum: const EdgeInsets.all(horizontalEdgePadding),
            child: BlocBuilder<CreateRegionBloc, CreateRegionState>(
              buildWhen: (previous, current) {
                return previous.isNextButtonLoading != current.isNextButtonLoading || previous.file != current.file;
              },
              builder: (context, state) {
                return FlatButtonLong(
                  isLoading: state.isNextButtonLoading,
                  enabled: state.file != null,
                  title: "${context.loc.createRegionSelectRegionButtonTitle} (5/5)",
                  onPressed: () => BlocProvider.of<CreateRegionBloc>(context).add(const OnPickImageNextTapped()),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
