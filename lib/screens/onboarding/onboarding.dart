import 'package:flutter/material.dart';
import 'package:teloswallet/providers/notifiers/settings_notifier.dart';
import 'package:teloswallet/screens/onboarding/import_account.dart';
import 'package:teloswallet/widgets/overlay_popup.dart';
import './choice_option.dart';
import './create_account.dart';
import './register_phone.dart';

enum Steps { Choice, Import, Create, Register }

class Onboarding extends StatefulWidget {
  Onboarding();

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  Steps step = Steps.Choice;

  String privateKey;
  String publicKey;
  String accountName;

  void onCreateChoice() {
    setState(() {
      step = Steps.Create;
    });
  }

  void onImportChoice() {
    setState(() {
      step = Steps.Import;
    });
  }

  void saveAccount(accountName, privateKey) {
    SettingsNotifier.of(context).saveAccount(
      accountName,
      privateKey.toString()
    );
  }

  void onImport({ accountName, privateKey }) {
    saveAccount(accountName, privateKey);
  }

  void onRegister() {
    saveAccount(accountName, privateKey);
  }

  void onCreate({ privateKey, publicKey, accountName }) {
    setState(() {
      step = Steps.Register;
      this.privateKey = privateKey;
      this.publicKey = publicKey;
      this.accountName = accountName;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget screen;

    switch (step) {
      case Steps.Choice:
        screen = ChoiceOption(
          onCreate: onCreateChoice,
          onImport: onImportChoice
        );
        break;
      case Steps.Import:
        screen = ImportAccount(
          onImport: onImport,
        );
        break;
      case Steps.Create:
        screen = CreateAccount(
          onSubmit: onCreate
        );
        break;
      case Steps.Register:
        screen = RegisterPhone(
          onSubmit: onRegister,
          publicKey: this.publicKey,
          accountName: this.accountName
        );
        break;
    }
  
    return OverlayPopup(
      backCallback: step == Steps.Choice ? null : () {
        setState(() {
          step = Steps.Choice;
        });
      },
      body: screen,
    );
  }
}
