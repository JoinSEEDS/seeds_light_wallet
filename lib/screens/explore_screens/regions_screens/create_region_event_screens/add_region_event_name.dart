import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/text_form_field_custom.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/screens/explore_screens/regions_screens/create_region_event_screens/interactor/viewmodels/create_region_event_bloc.dart';

class AddRegionEventName extends StatelessWidget {
  const AddRegionEventName({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateRegionEventBloc, CreateRegionEventState>(
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
                title: const Text("Create Event")),
            body: SafeArea(
              minimum: const EdgeInsets.all(horizontalEdgePadding),
              child: Stack(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 10),
                      TextFormFieldCustom(
                        initialValue: state.eventName,
                        maxLength: 36,
                        autofocus: true,
                        labelText: "Event Name",
                        onChanged: (text) {
                          BlocProvider.of<CreateRegionEventBloc>(context).add(OnRegionEventNameChange(text));
                        },
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FlatButtonLong(
                      enabled: state.eventName.isNotEmpty,
                      title: "Next (2/5)",
                      onPressed: () => BlocProvider.of<CreateRegionEventBloc>(context).add(const OnNextTapped()),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
