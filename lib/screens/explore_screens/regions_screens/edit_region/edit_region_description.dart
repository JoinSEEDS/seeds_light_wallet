import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/text_form_field_custom.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/screens/explore_screens/regions_screens/edit_region/interactor/viewmodel/edit_region_bloc.dart';
import 'package:seeds/utils/build_context_extension.dart';

class EditRegionDescription extends StatelessWidget {
  const EditRegionDescription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditRegionBloc, EditRegionState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text("Edit Region")),
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
                          BlocProvider.of<EditRegionBloc>(context).add(OnRegionDescriptionChange(text));
                        },
                      ),
                      Text(context.loc.createRegionAddDescriptionPageInfo,
                          style: Theme.of(context).textTheme.subtitle2OpacityEmphasis)
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: FlatButtonLong(
                    enabled: state.regionDescription.isNotEmpty,
                    title: "Save Changes",
                    onPressed: () => BlocProvider.of<EditRegionBloc>(context).add(
                      const OnEditRegionSaveChangesTapped(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
