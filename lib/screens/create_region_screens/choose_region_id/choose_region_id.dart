import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/components/text_form_field_custom.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/screens/create_region_screens/interactor/viewmodels/create_region_bloc.dart';
import 'package:seeds/utils/build_context_extension.dart';

class ChooseRegionId extends StatelessWidget {
  const ChooseRegionId({Key? key}) : super(key: key);

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
                  body: SafeArea(
                      minimum: const EdgeInsets.all(horizontalEdgePadding),
                      child: Stack(children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            TextFormFieldCustom(
                                suffixText: ".TODO",
                                autofocus: true,
                                labelText: context.loc.createRegionChooseRegionIdInputFormTitle),
                            const SizedBox(height: 20),
                            Text(context.loc.createRegionChooseRegionIdDescription,
                                style: Theme.of(context).textTheme.subtitle2OpacityEmphasis)
                          ],
                        ),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: FlatButtonLong(
                                title: "${context.loc.createRegionSelectRegionButtonTitle} (3/5)",
                                onPressed: () => BlocProvider.of<CreateRegionBloc>(context).add(const OnNextTapped())))
                      ]))));

        default:
          return const SizedBox.shrink();
      }
    });
  }
}
