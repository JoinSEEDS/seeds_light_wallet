import 'package:flutter/material.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/widgets/account_name_field.dart';
import 'package:seeds/widgets/main_button.dart';

class RequestRecovery extends StatefulWidget {
  final Function? onRequestRecovery;
  const RequestRecovery({this.onRequestRecovery});

  @override
  _RequestRecoveryState createState() => _RequestRecoveryState();
}

class _RequestRecoveryState extends State<RequestRecovery> {
  final TextEditingController accountNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool?>(
        future: checkGuardiansExists(accountNameController.text),
        builder: (context, snapshot) {
          return buildAccountForm(snapshot);
        });
  }

  Widget buildAccountForm(snapshot) {
    var status = AccountNameStatus.initial;
    if (snapshot.connectionState != ConnectionState.done) {
      status = AccountNameStatus.loading;
    } else {
      final hasGuardians = snapshot.data;

      if (hasGuardians == true) {
        status = AccountNameStatus.acceptable;
      } else {
        status = AccountNameStatus.unacceptable;
      }
    }

    return Container(
      child: Form(
        child: Container(
          margin: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
          padding: const EdgeInsets.only(bottom: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AccountNameField(
                onChanged: (value) => setState(() {}),
                controller: accountNameController,
                status: status,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: AnimatedCrossFade(
                    firstChild: MainButton(
                      title: "Recover account",
                      onPressed: () {
                        widget.onRequestRecovery!(accountNameController.text);
                      },
                    ),
                    secondChild: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        'Only accounts protected by guardians are accessible for recovery',
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    crossFadeState:
                        status == AccountNameStatus.acceptable ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 500)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> checkGuardiansExists(String accountName) async {
    final guardians = await HttpService.of(context).getAccountGuardians(accountName);

    return guardians!.exists;
  }
}
