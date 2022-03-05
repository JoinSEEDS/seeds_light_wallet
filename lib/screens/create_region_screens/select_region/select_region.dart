import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/create_region_screens/viewmodels/create_region_bloc.dart';
import 'package:seeds/utils/build_context_extension.dart';

class SelectRegion extends StatelessWidget {
  const SelectRegion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateRegionBloc, CreateRegionState>(
        listenWhen: (_, current) => current.pageCommand != null,
        listener: (context, state) {},
        child: BlocBuilder<CreateRegionBloc, CreateRegionState>(builder: (context, state) {
          switch (state.pageState) {
            case PageState.loading:
              return const FullPageLoadingIndicator();
            case PageState.failure:
              return const FullPageErrorIndicator();
            case PageState.success:
              return Scaffold(
                  appBar: AppBar(title: Text(context.loc.createRegionSelectRegionAppBarTitle)),
                  bottomNavigationBar: SafeArea(
                      minimum: const EdgeInsets.all(16),
                      child: FlatButtonLong(
                          title: "${context.loc.createRegionSelectRegionButtonTitle} (1/5)",
                          onPressed: () => BlocProvider.of<CreateRegionBloc>(context).add(const OnNextTapped()))),
                  body: SafeArea(
                      minimum: const EdgeInsets.all(16),
                      child: Column(children: [
                        Text(context.loc.createRegionSelectRegionDescription),
                        // TODO(gguij004): Waiting on map component.
                      ])));
            default:
              return const SizedBox.shrink();
          }
        }));
  }
}
