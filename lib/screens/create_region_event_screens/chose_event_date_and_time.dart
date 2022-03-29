import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/screens/create_region_event_screens/components/date_time_widget_row.dart';
import 'package:seeds/screens/create_region_event_screens/interactor/viewmodels/create_region_event_bloc.dart';
import 'package:seeds/screens/create_region_event_screens/interactor/viewmodels/create_region_events_page_commands.dart';

class ChoseEventDateAndTime extends StatelessWidget {
  const ChoseEventDateAndTime({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateRegionEventBloc, CreateRegionEventState>(
      listenWhen: (_, current) => current.pageCommand != null,
      listener: (context, state) async {
        final pageCommand = state.pageCommand;

        if (pageCommand is ShowPickDate) {
          final selected = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2099),
          );
          if (selected != null) {
            // ignore: use_build_context_synchronously
            BlocProvider.of<CreateRegionEventBloc>(context).add(OnSelectDateChanged(selected));
          }
        } else if (pageCommand is ShowPickTime) {
          final TimeOfDay? picked = await showTimePicker(
            context: context,
            initialTime: const TimeOfDay(hour: 00, minute: 00),
          );
          if (picked != null) {
            // ignore: use_build_context_synchronously
            BlocProvider.of<CreateRegionEventBloc>(context).add(OnSelectTimeChanged(picked));
          }
        }
      },
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
                      DateTimeWidgetRow(
                        label: "Select Event Date",
                        icon: const Icon(Icons.calendar_today_outlined),
                        onWidgetTapped: () =>
                            BlocProvider.of<CreateRegionEventBloc>(context).add(const OnSelectDateTapped()),
                        timeInfo:
                            state.eventDate != null ? DateFormat.yMMMMEEEEd().format(state.eventDateAndTime!) : "",
                      ),
                      const SizedBox(height: 30),
                      DateTimeWidgetRow(
                        label: "Select Event Time",
                        icon: const Icon(Icons.access_time),
                        onWidgetTapped: () =>
                            BlocProvider.of<CreateRegionEventBloc>(context).add(const OnSelectTimeTapped()),
                        timeInfo: state.eventTime != null ? DateFormat.jm().format(state.eventDateAndTime!) : "",
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FlatButtonLong(
                      enabled: state.eventDate != null && state.eventTime != null,
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
