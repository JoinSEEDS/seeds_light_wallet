import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/screens/create_region_event_screens/components/date_time_row.dart';
import 'package:seeds/screens/create_region_event_screens/interactor/viewmodels/create_region_event_bloc.dart';
import 'package:seeds/screens/create_region_event_screens/interactor/viewmodels/create_region_events_page_commands.dart';

class ChoseEventDateAndTime extends StatelessWidget {
  const ChoseEventDateAndTime({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateRegionEventBloc, CreateRegionEventState>(
      listenWhen: (_, current) => current.pageCommand != null,
      listener: (context, state) {
        final command = state.pageCommand;
        BlocProvider.of<CreateRegionEventBloc>(context).add(const ClearCreateRegionEventPageCommand());
        if (command is ShowStartTimePicker || command is ShowEndTimePicker) {
          final initialTime = command is ShowStartTimePicker ? DateTime.now() : state.eventStartTime ?? DateTime.now();
          showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(initialTime)).then((selected) {
            if (selected != null) {
              BlocProvider.of<CreateRegionEventBloc>(context).add(
                command is ShowStartTimePicker ? OnStartTimeChanged(selected) : OnEndTimeChanged(selected),
              );
            }
          });
        } else if (command is ShowStartDatePicker || command is ShowEndDatePicker) {
          final initialDate = command is ShowStartDatePicker ? DateTime.now() : state.eventStartTime ?? DateTime.now();
          showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: initialDate,
            lastDate: DateTime(2099),
          ).then((selected) {
            if (selected != null) {
              BlocProvider.of<CreateRegionEventBloc>(context).add(
                command is ShowStartDatePicker ? OnStartDateChanged(selected) : OnEndDateChanged(selected),
              );
            }
          });
        } else if (command is ShowWrongEndTime) {
          eventBus.fire(const ShowSnackBar('End time must be after start time.'));
        }
      },
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
              title: const Text("Create Event"),
            ),
            body: SafeArea(
              minimum: const EdgeInsets.all(horizontalEdgePadding),
              child: Stack(
                children: [
                  Column(
                    children: [
                      const Text('Start Date & Time'),
                      const SizedBox(height: 20),
                      DateTimeRow(
                        label: "Select Event Start Date",
                        icon: const Icon(Icons.calendar_today_outlined),
                        onTap: () {
                          BlocProvider.of<CreateRegionEventBloc>(context).add(const OnSelectEndDateButtonTapped());
                        },
                        timeInfo:
                            state.eventStartTime != null ? DateFormat.yMMMMEEEEd().format(state.eventStartTime!) : "",
                      ),
                      const SizedBox(height: 30),
                      DateTimeRow(
                        label: "Select Event Start Time",
                        icon: const Icon(Icons.access_time),
                        onTap: () {
                          BlocProvider.of<CreateRegionEventBloc>(context).add(const OnSelectStartTimeButtonTapped());
                        },
                        timeInfo: state.eventStartTime != null
                            ? "${DateFormat.jm().format(state.eventStartTime!)} - Starts"
                            : "",
                      ),
                      const SizedBox(height: 30),
                      const Text('End Date & Time'),
                      const SizedBox(height: 20),
                      DateTimeRow(
                        label: "Select Event End Date",
                        icon: const Icon(Icons.calendar_today_outlined),
                        onTap: () {
                          BlocProvider.of<CreateRegionEventBloc>(context).add(const OnSelectEndDateButtonTapped());
                        },
                        timeInfo: state.eventEndTime != null ? DateFormat.yMMMMEEEEd().format(state.eventEndTime!) : "",
                      ),
                      const SizedBox(height: 30),
                      DateTimeRow(
                        label: "Select Event End Time",
                        icon: const Icon(Icons.access_time),
                        onTap: () async {
                          BlocProvider.of<CreateRegionEventBloc>(context).add(const OnSelectEndTimeButtonTapped());
                        },
                        timeInfo:
                            state.eventEndTime != null ? "${DateFormat.jm().format(state.eventEndTime!)} - Ends" : "",
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FlatButtonLong(
                      enabled: state.isDateTimeNextButtonEnabled,
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
