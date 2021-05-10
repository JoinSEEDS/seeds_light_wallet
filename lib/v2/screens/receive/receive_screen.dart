import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/v2/screens/receive/components/receive_selection_card.dart';
import 'package:seeds/v2/screens/receive/interactor/viewmodels/receive_events.dart';
import '../../navigation/navigation_service.dart';
import 'interactor/receive_bloc.dart';
import 'interactor/viewmodels/receive_state.dart';
import 'package:seeds/design/app_theme.dart';

/// Receive selection screen
class ReceiveScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ReceiveBloc(),
        child: BlocListener<ReceiveBloc, ReceiveState>(
          listenWhen: (previous, current) => current.receiveStates != ReceiveStates.initial,
          listener: (context, state) {
            if (state.receiveStates == ReceiveStates.navigateToInputSeeds) {
              NavigationService.of(context).navigateTo(Routes.receive);
            } else {
              NavigationService.of(context).navigateTo(Routes.receive);
            }
          },
          child: BlocBuilder<ReceiveBloc, ReceiveState>(
            buildWhen: (context, state) => state.receiveStates == ReceiveStates.initial,
            builder: (context, state) {
              return Scaffold(
                  appBar: AppBar(
                    title: Text(
                      "Choose an option",
                      style: Theme.of(context).textTheme.headline7,
                    ),
                  ),
                  body: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
                        child: Row(mainAxisSize: MainAxisSize.max, children: [
                          Expanded(
                              child: ReceiveSelectionCard(
                                  icon: SvgPicture.asset('assets/images/receive/receive_input_seeds.svg'),
                                  title: "Input Seeds or Other Currency",
                                  onTap: () {
                                    BlocProvider.of<ReceiveBloc>(context).add(TapInputSeedsCard());
                                  })),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                              child: ReceiveSelectionCard(
                                  icon: SvgPicture.asset('assets/images/receive/merchant.svg'),
                                  title: "Select a Product or Service",
                                  onTap: () {
                                    BlocProvider.of<ReceiveBloc>(context).add(TapMerchantCard());
                                  })),
                        ]),
                      ),
                    ],
                  ));
            },
          ),
        ));
  }
}
