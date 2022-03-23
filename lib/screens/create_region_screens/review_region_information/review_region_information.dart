import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/create_region_screens/interactor/viewmodels/create_region_bloc.dart';
import 'package:seeds/screens/create_region_screens/review_region_information/components/review_region_header.dart';
import 'package:seeds/utils/build_context_extension.dart';

class ReviewRegion extends StatelessWidget {
  const ReviewRegion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateRegionBloc, CreateRegionState>(
      builder: (context, state) {
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
                        title: "Publish",
                        onPressed: () => BlocProvider.of<CreateRegionBloc>(context).add(const OnCreateRegionTapped()))),
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
