import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/datasource/remote/model/firebase_models/region_event_model.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/screens/explore_screens/regions_screens/create_region_event_screens/components/date_time_row.dart';
import 'package:seeds/screens/explore_screens/regions_screens/edit_region_event/interactor/viewmodel/edit_region_event_bloc.dart';
import 'package:seeds/screens/explore_screens/regions_screens/edit_region_event/interactor/viewmodel/edit_region_event_page_commands.dart';

class EditRegionEventTimeAndDate extends StatelessWidget {
  const EditRegionEventTimeAndDate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final event = ModalRoute.of(context)!.settings.arguments as RegionEventModel?;

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Event")),
      body: BlocProvider(
        create: (_) => EditRegionEventBloc(event!),
        child: BlocConsumer<EditRegionEventBloc, EditRegionEventState>(
          listenWhen: (_, current) => current.pageCommand != null,
          listener: (context, state) {
            final command = state.pageCommand;
            BlocProvider.of<EditRegionEventBloc>(context).add(const ClearEditRegionEventPageCommand());
            if (command is ShowStartTimePicker || command is ShowEndTimePicker) {
              final initialTime = state.eventEndTime;
              showTimePicker(context: context, initialTime: initialTime).then((selected) {
                BlocProvider.of<EditRegionEventBloc>(context).add(
                  command is ShowStartTimePicker ? OnStartTimeChanged(selected) : OnEndTimeChanged(selected),
                );
              });
            } else if (command is ShowStartDatePicker) {
              final endDate = state.eventEndDate;
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: endDate,
              ).then((selected) {
                BlocProvider.of<EditRegionEventBloc>(context).add(OnStartDateChanged(selected));
              });
            } else if (command is ShowEndDatePicker) {
              final initialDate = state.eventStartDate;
              showDatePicker(
                context: context,
                initialDate: initialDate,
                firstDate: initialDate,
                lastDate: DateTime(2099),
              ).then((selected) {
                BlocProvider.of<EditRegionEventBloc>(context).add(OnEndDateChanged(selected));
              });
            } else if (command is ShowErrorMessage) {
              eventBus.fire(ShowSnackBar(command.message));
            }
          },
          builder: (context, state) {
            return SafeArea(
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
                            BlocProvider.of<EditRegionEventBloc>(context).add(const OnSelectStartDateButtonTapped());
                          },
                          timeInfo: state.startDateAndTimeFormatted),
                      const SizedBox(height: 30),
                      DateTimeRow(
                        label: "Select Event Start Time",
                        icon: const Icon(Icons.access_time),
                        onTap: () {
                          BlocProvider.of<EditRegionEventBloc>(context).add(const OnSelectStartTimeButtonTapped());
                        },
                        timeInfo: state.eventStartTime.format(context),
                      ),
                      const SizedBox(height: 30),
                      const Text('End Date & Time'),
                      const SizedBox(height: 20),
                      DateTimeRow(
                        label: "Select Event End Date",
                        icon: const Icon(Icons.calendar_today_outlined),
                        onTap: () {
                          BlocProvider.of<EditRegionEventBloc>(context).add(const OnSelectEndDateButtonTapped());
                        },
                        timeInfo: state.endDateAndTimeFormatted,
                      ),
                      const SizedBox(height: 30),
                      DateTimeRow(
                          label: "Select Event End Time",
                          icon: const Icon(Icons.access_time),
                          onTap: () {
                            BlocProvider.of<EditRegionEventBloc>(context).add(const OnSelectEndTimeButtonTapped());
                          },
                          timeInfo: state.eventEndTime.format(context)),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FlatButtonLong(
                      isLoading: state.isSaveChangesButtonLoading,
                      title: "Save Changes",
                      // TODO(gguij004): next pr
                      onPressed: () {},
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
