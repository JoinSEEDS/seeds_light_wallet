import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/screens/create_region_event_screens/interactor/viewmodels/create_region_event_bloc.dart';

class ChoseEventDateAndTime extends StatelessWidget {
  const ChoseEventDateAndTime({Key? key}) : super(key: key);

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
                      Text("Pick event Date and Time", style: Theme.of(context).textTheme.headline6),
                      const SizedBox(height: 30),
                      Container(
                        height: 250,
                        child: CupertinoDatePicker(
                          backgroundColor: AppColors.lightGrey,
                          initialDateTime: DateTime.now(),
                          onDateTimeChanged: (DateTime newDateTime) {
                            BlocProvider.of<CreateRegionEventBloc>(context).add(OnSelectDateChanged(newDateTime));
                          },
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FlatButtonLong(
                      enabled: state.eventDateTime != null,
                      title: "Next (4/5)",
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
