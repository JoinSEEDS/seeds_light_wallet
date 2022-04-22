import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/screens/create_region_event_screens/components/date_time_row.dart';
import 'package:seeds/screens/create_region_event_screens/interactor/viewmodels/create_region_event_bloc.dart';

class ChoseEventDateAndTime extends StatelessWidget {
  const ChoseEventDateAndTime({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateRegionEventBloc, CreateRegionEventState>(
      builder: (context, CreateRegionEventState state) {
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
                      const SizedBox(height: 20),
                      DateTimeRow(
                        label: "Select Event Date",
                        icon: const Icon(Icons.calendar_today_outlined),
                        onWidgetTapped: () async {
                          final DateTime? selected = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2099),
                          );
                          // ignore: use_build_context_synchronously
                          BlocProvider.of<CreateRegionEventBloc>(context).add(OnSelectDateChanged(selected));
                        },
                        timeInfo:
                            state.eventDate != null ? DateFormat.yMMMMEEEEd().format(state.eventDateAndTime!) : "",
                      ),
                      const SizedBox(height: 30),
                      DateTimeRow(
                        label: "Select Event Start Time",
                        icon: const Icon(Icons.access_time),
                        onWidgetTapped: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: const TimeOfDay(hour: 00, minute: 00),
                          );
                          // ignore: use_build_context_synchronously
                          BlocProvider.of<CreateRegionEventBloc>(context).add(OnSelectTimeChanged(picked));
                        },
                        timeInfo: state.eventStartTime != null
                            ? "${DateFormat.jm().format(state.eventDateAndTime!)} - Starts"
                            : "",
                      ),
                      const SizedBox(height: 30),
                      DateTimeRow(
                        label: "Select Event End Time",
                        icon: const Icon(Icons.access_time),
                        onWidgetTapped: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: const TimeOfDay(hour: 00, minute: 00),
                          );
                          // ignore: use_build_context_synchronously
                          BlocProvider.of<CreateRegionEventBloc>(context).add(OnEndTimeChanged(picked));
                        },
                        timeInfo: state.eventEndTime != null ? "${state.eventEndTime!.format(context)} - Ends" : "",
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FlatButtonLong(
                      enabled: state.eventDate != null && state.eventStartTime != null && state.eventEndTime != null,
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
