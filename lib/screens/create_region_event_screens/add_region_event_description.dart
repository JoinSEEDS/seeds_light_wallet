import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/text_form_field_custom.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/screens/create_region_event_screens/interactor/viewmodels/create_region_event_bloc.dart';

class AddRegionEventDescription extends StatelessWidget {
  const AddRegionEventDescription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateRegionEventBloc, CreateRegionEventState>(builder: (context, state) {
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
                  child: Stack(children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          TextFormFieldCustom(
                            initialValue: state.eventDescription,
                            autofocus: true,
                            maxLines: 10,
                            labelText: "Description",
                            onChanged: (text) {
                              BlocProvider.of<CreateRegionEventBloc>(context).add(OnRegionEventDescriptionChange(text));
                            },
                          ),
                          const SizedBox(height: 10),
                          Text(
                              "Enter a description for your Event. Be clear about the what activities will be taking place at the event so people know what to expect.",
                              style: Theme.of(context).textTheme.subtitle2OpacityEmphasis)
                        ],
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: FlatButtonLong(
                            enabled: state.eventDescription.isNotEmpty,
                            title: "Next (3/5)",
                            onPressed: () => BlocProvider.of<CreateRegionEventBloc>(context).add(const OnNextTapped())))
                  ]))));
    });
  }
}
