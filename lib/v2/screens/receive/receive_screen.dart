import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/v2/screens/receive/components/receive_selection_card.dart';
import 'package:seeds/v2/screens/receive/interactor/viewmodels/receive_events.dart';
import 'interactor/receive_bloc.dart';
import 'interactor/viewmodels/receive_state.dart';

/// Receive selection screen
class ReceiveScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ReceiveBloc(),
        child: BlocListener<ReceiveBloc, ReceiveState>(
          listenWhen: (previous, current) => current.receiveStates != ReceiveStates.initial,
          listener: (context, state) {
            if(state.receiveStates == ReceiveStates.goToInputSeeds) {
              NavigationService.of(context).navigateTo(Routes.receive);
            } else {
              NavigationService.of(context).navigateTo(Routes.receive);
            }
          },
          child: BlocBuilder<ReceiveBloc, ReceiveState>(
            buildWhen: (context, state) => state.receiveStates == ReceiveStates.initial,
            builder: (context, state) {
              return  Scaffold(
                  body: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
                        child: Row(mainAxisSize: MainAxisSize.max, children: [
                          Expanded(
                              child: ReceiveSelectionCard(
                                  icon: SvgPicture.asset('assets/images/receive/receive_input_seeds.svg'),
                                  title: " Input Seeds or Other Currency ",
                                  callback: () {
                                    BlocProvider.of<ReceiveBloc>(context).add(GoToInputSeeds());
                                  })),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                              child: ReceiveSelectionCard(
                                  icon: SvgPicture.asset('assets/images/receive/merchant.svg'),
                                  title: "Select a Product or Service",
                                  callback: () {
                                    BlocProvider.of<ReceiveBloc>(context).add(GoToMerchant());
                                  })),
                        ]),
                      ),
                    ],
                  )
              );
            },
          ),
        )

        // BlocConsumer<ReceiveBloc, ReceiveState>(
        //  listenWhen: (previous, current) =>  previous.receiveStates != ReceiveStates.initial,
        //     listener: (context, state) => Navigator.of(context).pop(state.receiveStates),
        //      builder: (context, state) {
        //        switch (state.receiveStates) {
        //       case ReceiveStates.goToInputSeeds:
        //        NavigationService.of(context).navigateTo(Routes.receive);
        //          return const SizedBox.shrink();
        //       case ReceiveStates.goToMerchant:
        //       return const SizedBox.shrink();
        //      case ReceiveStates.initial:
        //        return Scaffold(

        //
        //     create: (context) => ReceiveBloc()..add(ClearState()),
        // child: Scaffold(
        // body: BlocBuilder<ReceiveBloc, ReceiveState>(
        // builder: (context, state) {
        // switch (state.receiveStates) {
        //   case ReceiveStates.goToInputSeeds:
        //     NavigationService.of(context).navigateTo(Routes.receive);
        //     return const SizedBox.shrink();
        // case ReceiveStates.goToMerchant:
        // return const SizedBox.shrink();
        // case ReceiveStates.initial:
        // return Scaffold(

        // BlocBuilder<ReceiveBloc, ReceiveState>(builder: (BuildContext context, ReceiveState state) {
        //   print("State is valid : " + state.receiveStates.toString());
        //
        //   if (state.receiveStates == ReceiveStates.goToInputSeeds) {
        //     NavigationService.of(context).navigateTo(Routes.receive);
        //     BlocProvider.of<ReceiveBloc>(context).add(ClearState());
        //   } else if (state.receiveStates == ReceiveStates.goToMerchant) {
        //     BlocProvider.of<ReceiveBloc>(context).add(ClearState());
        //     NavigationService.of(context).navigateTo(Routes.dashboard);
        //   }

        // appBar: AppBar(
        //   title: Text(
        //     "Choose an option",
        //     style: Theme.of(context).textTheme.headline6,
        //   ),
        // ),

        //       body: ListView(
        //         children: [
        //           Padding(
        //             padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
        //             child: Row(mainAxisSize: MainAxisSize.max, children: [
        //               Expanded(
        //                   child: ReceiveSelectionCard(
        //                       icon: SvgPicture.asset('assets/images/receive/receive_input_seeds.svg'),
        //                       title: " Input Seeds or Other Currency ",
        //                       callback: () {
        //                         BlocProvider.of<ReceiveBloc>(context).add(GoToInputSeeds());
        //                       })),
        //               const SizedBox(
        //                 width: 20,
        //               ),
        //               Expanded(
        //                   child: ReceiveSelectionCard(
        //                       icon: SvgPicture.asset('assets/images/receive/merchant.svg'),
        //                       title: "Select a Product or Service",
        //                       callback: () {
        //                         BlocProvider.of<ReceiveBloc>(context).add(GoToMerchant());
        //                       })),
        //             ]),
        //           ),
        //         ],
        //      ));
        //       default:
        //       return const SizedBox.shrink();
        //
        // }}

        // )

        );
  }
}
