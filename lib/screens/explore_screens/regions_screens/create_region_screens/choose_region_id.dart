import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/text_form_field_custom.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/screens/explore_screens/regions_screens/create_region_screens/components/authentication_status.dart';
import 'package:seeds/screens/explore_screens/regions_screens/create_region_screens/interactor/viewmodels/create_region_bloc.dart';
import 'package:seeds/utils/build_context_extension.dart';

class ChooseRegionId extends StatelessWidget {
  const ChooseRegionId({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateRegionBloc, CreateRegionState>(
      listenWhen: (_, current) => current.pageCommand != null,
      listener: (context, state) {
        final pageCommand = state.pageCommand;

        if (pageCommand is ShowErrorMessage) {
          eventBus.fire(ShowSnackBar(pageCommand.message));
        }
        BlocProvider.of<CreateRegionBloc>(context).add(const ClearCreateRegionPageCommand());
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
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(child: AuthenticationStatus()),
                    const SizedBox(height: 10),
                    BlocBuilder<CreateRegionBloc, CreateRegionState>(
                      buildWhen: (previous, current) {
                        return previous.regionIdErrorMessage != current.regionIdErrorMessage ||
                            previous.regionId != current.regionId;
                      },
                      builder: (context, state) {
                        return TextFormFieldCustom(
                          errorText: state.regionIdErrorMessage,
                          initialValue: state.regionId,
                          maxLength: 8,
                          suffixText: ".rgn",
                          autofocus: true,
                          labelText: context.loc.createRegionChooseRegionIdInputFormTitle,
                          onChanged: (val) => BlocProvider.of<CreateRegionBloc>(context).add(OnRegionIdChange(val)),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(context.loc.createRegionChooseRegionIdDescription1,
                        style: Theme.of(context).textTheme.subtitle2OpacityEmphasis),
                    const SizedBox(height: 20),
                    Text(context.loc.createRegionChooseRegionIdDescription2,
                        style: Theme.of(context).textTheme.subtitle2OpacityEmphasis),
                    const SizedBox(height: 20),
                    Text(context.loc.createRegionChooseRegionIdDescription3,
                        style: Theme.of(context).textTheme.subtitle2OpacityEmphasis)
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: BlocBuilder<CreateRegionBloc, CreateRegionState>(
                    buildWhen: (previous, current) =>
                        previous.regionIdValidationStatus != current.regionIdValidationStatus,
                    builder: (context, state) {
                      return FlatButtonLong(
                        enabled: state.regionIdValidationStatus == RegionIdStatusIcon.valid,
                        title: "${context.loc.createRegionSelectRegionButtonTitle} (3/5)",
                        onPressed: () => BlocProvider.of<CreateRegionBloc>(context).add(const OnNextTapped()),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
