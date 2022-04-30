import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/datasource/remote/model/firebase_models/region_event_model.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/screens/create_region_event_screens/components/date_time_row.dart';
import 'package:seeds/screens/explore_screens/regions_screens/edit_region_event/interactor/viewmodel/edit_region_event_bloc.dart';

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
            final pageCommand = state.pageCommand;
            if (pageCommand is ShowErrorMessage) {
              eventBus.fire(ShowSnackBar(pageCommand.message));
            }
            BlocProvider.of<EditRegionEventBloc>(context).add(const ClearEditRegionEventPageCommand());
          },
          builder: (context, state) {
            return SafeArea(
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
                            BlocProvider.of<EditRegionEventBloc>(context).add(OnSelectDateChanged(selected));
                          },
                          timeInfo: state.eventDateAndTimeInfo),
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
                          BlocProvider.of<EditRegionEventBloc>(context).add(OnStartTimeChanged(picked));
                        },
                        timeInfo: state.startTimeInfo,
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
                            BlocProvider.of<EditRegionEventBloc>(context).add(OnEndTimeChanged(picked));
                          },
                          timeInfo: state.endTimeInfo),
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
