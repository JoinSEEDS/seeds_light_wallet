import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/create_region_screens/components/create_region_confirmation_dialog.dart';
import 'package:seeds/screens/create_region_screens/components/review_region_header.dart';
import 'package:seeds/screens/create_region_screens/interactor/viewmodels/create_region_bloc.dart';
import 'package:seeds/screens/create_region_screens/interactor/viewmodels/create_region_page_commands.dart';

import 'package:seeds/utils/build_context_extension.dart';

class ReviewRegion extends StatelessWidget {
  const ReviewRegion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateRegionBloc, CreateRegionState>(
      listenWhen: (_, current) => current.pageCommand != null,
      listener: (context, state) {
        final pageCommand = state.pageCommand;

        if (pageCommand is ShowCreateRegionConfirmation) {
          FocusScope.of(context).unfocus();
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return BlocProvider.value(
                value: BlocProvider.of<CreateRegionBloc>(context),
                child: const CreateRegionConfirmationDialog(),
              );
            },
          );
        } else if (pageCommand is NavigateToRoute) {
          NavigationService.of(context).pushAndRemoveUntil(route: pageCommand.route, from: Routes.app);
        }
        BlocProvider.of<CreateRegionBloc>(context).add(const ClearCreateRegionPageCommand());
      },
      builder: (context, state) {
        switch (state.pageState) {
          case PageState.loading:
            return const Scaffold(body: FullPageLoadingIndicator());
          case PageState.failure:
            return const FullPageErrorIndicator();
          case PageState.success:
            return WillPopScope(
              onWillPop: () async {
                BlocProvider.of<CreateRegionBloc>(context).add(const OnBackPressed());
                return false;
              },
              child: Scaffold(
                appBar: AppBar(
                    leading: BackButton(
                        onPressed: () => BlocProvider.of<CreateRegionBloc>(context).add(const OnBackPressed())),
                    title: Text(context.loc.createRegionSelectRegionAppBarTitle)),
                bottomNavigationBar: SafeArea(
                    minimum: const EdgeInsets.all(16),
                    child: FlatButtonLong(
                        title: "Publish",
                        onPressed: () =>
                            BlocProvider.of<CreateRegionBloc>(context).add(const OnPublishRegionTapped()))),
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const ReviewRegionHeader(),
                        Padding(padding: const EdgeInsets.all(16), child: Text(state.regionDescription))
                      ],
                    ),
                  ),
                ),
              ),
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
