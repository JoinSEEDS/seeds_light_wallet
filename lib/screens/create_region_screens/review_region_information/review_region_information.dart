import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/create_region_screens/viewmodels/create_region_bloc.dart';
import 'package:seeds/utils/build_context_extension.dart';

// TODO(gguij004): No UI for this page yet.

class ReviewRegion extends StatelessWidget {
  const ReviewRegion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateRegionBloc, CreateRegionState>(builder: (context, state) {
      switch (state.pageState) {
        case PageState.loading:
          return const FullPageLoadingIndicator();
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
                          title: "Create Region",
                          onPressed: () =>
                              BlocProvider.of<CreateRegionBloc>(context).add(const OnCreateRegionTapped()))),
                  body: SafeArea(minimum: const EdgeInsets.all(16), child: Column())));
        default:
          return const SizedBox.shrink();
      }
    });
  }
}
