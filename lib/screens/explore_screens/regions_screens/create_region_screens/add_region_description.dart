import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/text_form_field_custom.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/screens/explore_screens/regions_screens/create_region_screens/interactor/viewmodels/create_region_bloc.dart';
import 'package:seeds/utils/build_context_extension.dart';

class AddRegionDescription extends StatelessWidget {
  const AddRegionDescription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateRegionBloc, CreateRegionState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            BlocProvider.of<CreateRegionBloc>(context).add(const OnBackPressed());
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
                leading:
                    BackButton(onPressed: () => BlocProvider.of<CreateRegionBloc>(context).add(const OnBackPressed())),
                title: Text(context.loc.createRegionSelectRegionAppBarTitle)),
            body: SafeArea(
              minimum: const EdgeInsets.all(horizontalEdgePadding),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormFieldCustom(
                          initialValue: state.regionDescription,
                          autofocus: true,
                          maxLines: 10,
                          labelText: context.loc.createRegionAddDescriptionInputFormTitle,
                          onChanged: (text) {
                            BlocProvider.of<CreateRegionBloc>(context).add(OnRegionDescriptionChange(text));
                          },
                        ),
                        const SizedBox(height: 20),
                        Text(context.loc.createRegionAddDescriptionPageInfo,
                            style: Theme.of(context).textTheme.subtitle2OpacityEmphasis)
                      ],
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: FlatButtonLong(
                          enabled: state.regionDescription.isNotEmpty,
                          title: "${context.loc.createRegionSelectRegionButtonTitle} (4/5)",
                          onPressed: () => BlocProvider.of<CreateRegionBloc>(context).add(const OnNextTapped())))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
