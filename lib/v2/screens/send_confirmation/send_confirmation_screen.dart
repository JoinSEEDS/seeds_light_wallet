import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/components/full_page_error_indicator.dart';
import 'package:seeds/v2/components/full_page_loading_indicator.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/send_confirmation/interactor/send_confirmation_bloc.dart';
import 'package:seeds/v2/screens/send_confirmation/interactor/viewmodels/send_confirmation_arguments.dart';
import 'package:seeds/v2/screens/send_confirmation/interactor/viewmodels/send_confirmation_events.dart';
import 'package:seeds/v2/screens/send_confirmation/interactor/viewmodels/send_confirmation_state.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/transaction_details.dart';

/// SendConfirmation SCREEN
class SendConfirmationScreen extends StatelessWidget {
  final SendConfirmationArguments arguments;

  const SendConfirmationScreen({Key key, this.arguments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SendConfirmationBloc()..add(InitSendConfirmationWithArguments(arguments: arguments)),
      child: Scaffold(
        body: BlocBuilder<SendConfirmationBloc, SendConfirmationState>(
          builder: (context, SendConfirmationState state) {
            switch (state.pageState) {
              case PageState.initial:
                return const SizedBox.shrink();
              case PageState.loading:
                return const FullPageLoadingIndicator();
              case PageState.failure:
                return const FullPageErrorIndicator();
              case PageState.success:
                return Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                      icon: Icon(Icons.close, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  backgroundColor: Colors.white,
                  body: Container(
                    margin: EdgeInsets.symmetric(horizontal: 17),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          TransactionDetails(
                            image: Image.asset(
                              'assets/images/seeds.png',
                              height: 33,
                            ),
                            title: state.name,
                            beneficiary: state.account,
                          ),
                          SizedBox(height: 8),
                          Column(
                            children: <Widget>[
                              ...state.data.entries
                                  .map(
                                    (e) => Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      e.key,
                                      style: TextStyle(
                                        fontFamily: "heebo",
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      e.value.toString(),
                                      style: TextStyle(
                                        fontFamily: "heebo",
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                                  .toList(),
                            ],
                          ),
                          SizedBox(height: 8),
                          MainButton(
                            margin: EdgeInsets.only(top: 25),
                            title: 'Send',
                            onPressed: (){},
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
