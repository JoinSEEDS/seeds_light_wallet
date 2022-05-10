import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/screens/explore_screens/regions_screens/create_region_event_screens/components/date_time_row.dart';
import 'package:seeds/screens/explore_screens/regions_screens/create_region_event_screens/interactor/viewmodels/create_region_event_bloc.dart';
import 'package:seeds/screens/explore_screens/regions_screens/create_region_event_screens/interactor/viewmodels/create_region_events_page_commands.dart';

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
          final initialTime = state.eventEndTime ?? TimeOfDay.now();
          showTimePicker(context: context, initialTime: initialTime).then((selected) {
            BlocProvider.of<CreateRegionEventBloc>(context).add(
              command is ShowStartTimePicker ? OnStartTimeChanged(selected) : OnEndTimeChanged(selected),
            );
          });
        } else if (command is ShowStartDatePicker) {
          final endDate = state.eventEndDate ?? DateTime(2099);
          showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: endDate,
          ).then((selected) {
            BlocProvider.of<CreateRegionEventBloc>(context).add(OnStartDateChanged(selected));
          });
        } else if (command is ShowEndDatePicker) {
          final initialDate = state.eventStartDate ?? DateTime.now();
          showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: initialDate,
            lastDate: DateTime(2099),
          ).then((selected) {
            BlocProvider.of<CreateRegionEventBloc>(context).add(OnEndDateChanged(selected));
          });
        } else if (command is ShowErrorMessage) {
          eventBus.fire(ShowSnackBar(command.message));
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
                          BlocProvider.of<CreateRegionEventBloc>(context).add(const OnSelectStartDateButtonTapped());
                        },
                        timeInfo:
                            state.eventStartDate != null ? DateFormat.yMMMMEEEEd().format(state.eventStartDate!) : "",
                      ),
                      const SizedBox(height: 30),
                      DateTimeRow(
                        label: "Select Event Start Time",
                        icon: const Icon(Icons.access_time),
                        onTap: () {
                          BlocProvider.of<CreateRegionEventBloc>(context).add(const OnSelectStartTimeButtonTapped());
                        },
                        timeInfo: state.eventStartTime != null ? state.eventStartTime!.format(context) : "",
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
                        timeInfo: state.eventEndDate != null ? DateFormat.yMMMMEEEEd().format(state.eventEndDate!) : "",
                      ),
                      const SizedBox(height: 30),
                      DateTimeRow(
                        label: "Select Event End Time",
                        icon: const Icon(Icons.access_time),
                        onTap: () async {
                          BlocProvider.of<CreateRegionEventBloc>(context).add(const OnSelectEndTimeButtonTapped());
                        },
                        timeInfo: state.eventEndTime != null ? state.eventEndTime!.format(context) : "",
                      ),
                    ],
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: FlatButtonLong(
                          enabled: state.isDateTimeNextButtonEnabled,
                          title: "Next (4/5)",
                          onPressed: () =>
                              BlocProvider.of<CreateRegionEventBloc>(context).add(const OnSelectDateNextTapped())))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
