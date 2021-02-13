import 'package:flutter/material.dart';
import 'package:flutter_toolbox/flutter_toolbox.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/features/backup/backup_service.dart';
import 'package:seeds/i18n/wallet.i18n.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/balance_notifier.dart';
import 'package:seeds/providers/notifiers/members_notifier.dart';
import 'package:seeds/providers/notifiers/rate_notiffier.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/notifiers/transactions_notifier.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/guardian_services.dart';

// import 'package:seeds/providers/services/eos_service.dart';// the unused imports are for the sample code.
// import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/providers/useCases/dashboard_usecases.dart';
import 'package:seeds/utils/string_extension.dart';
import 'package:seeds/widgets/dashboard_widgets/receive_button.dart';
import 'package:seeds/widgets/dashboard_widgets/send_button.dart';
import 'package:seeds/widgets/empty_button.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/main_card.dart';
import 'package:seeds/widgets/read_times_tamp.dart';
import 'package:seeds/widgets/transaction_avatar.dart';
import 'package:seeds/widgets/transaction_dialog.dart';
import 'package:shimmer/shimmer.dart';

enum TransactionType { income, outcome }

class Dashboard extends StatefulWidget {
  Dashboard();

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var savingLoader = GlobalKey<MainButtonState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      DashboardUseCases()
          .shouldShowCancelGuardianAlertMessage(SettingsNotifier.of(context).accountName)
          .listen((bool showAlertDialog) {
        if (showAlertDialog) {
          showAccountUnderRecoveryDialog(context);
        }
      });
    });
  }

  Future<void> showAccountUnderRecoveryDialog(BuildContext buildContext) async {
    var service = EosService.of(buildContext, listen: false);
    var accountName = SettingsNotifier.of(buildContext, listen: false).accountName;

    return showDialog<void>(
      context: buildContext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  FadeInImage.assetNetwork(
                      placeholder: "assets/images/guardians/guardian_shield.png",
                      image: "assets/images/guardians/guardian_shield.png"),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 24, bottom: 8),
                    child: Text(
                      "Recovery Mode Initiated",
                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: new TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          TextSpan(text: 'Someone has initiated the '),
                          TextSpan(text: 'Recovery ', style: new TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text:
                                  'process for your account. If you did not request to recover your account please select cancel recovery.  '),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              MainButton(
                key: savingLoader,
                margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8),
                title: "Cancel Recovery",
                onPressed: () async {
                  savingLoader.currentState.loading();
                  GuardianServices()
                      .stopActiveRecovery(service, accountName)
                      .then((value) => Navigator.pop(context))
                      .catchError((onError) => onStopRecoveryError(onError));
                },
              ),
            ],
          );
        });
      },
    );
  }

  onStopRecoveryError(onError) {
    print("onStopRecoveryError Error " + onError.toString());
    errorToast('Oops, Something went wrong');

    setState(() {
      savingLoader.currentState.done();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: ListView(
          children: <Widget>[
            buildNotification(),
            buildHeader(),
            SizedBox(height: 20),
            buildSendReceiveButton(),
            SizedBox(height: 20),
            //fixing this
            buildTransactions(),
          ],
        ),
      ),
      onRefresh: refreshData,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    refreshData();
    if (SettingsNotifier.of(context).selectedFiatCurrency == null) {
      Locale locale = Localizations.localeOf(context);
      var format = NumberFormat.simpleCurrency(locale: locale.toString());
      SettingsNotifier.of(context).saveSelectedFiatCurrency(format.currencyName);
    }
  }

  Future<void> refreshData() async {
    await Future.wait(<Future<dynamic>>[
      TransactionsNotifier.of(context).fetchTransactionsCache(),
      TransactionsNotifier.of(context).refreshTransactions(),
      BalanceNotifier.of(context).fetchBalance(),
      RateNotifier.of(context).fetchRate(),
    ]);
  }

  void onTransfer() {
    NavigationService.of(context).navigateTo(Routes.transfer);
  }

  void onReceive() async {
    NavigationService.of(context).navigateTo(Routes.receive);
  }

  Widget buildHeader() {
    final double width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final double textScaleFactor = width >= 320 ? 1.0 : 0.8;

    return Container(
      width: width,
      height: height * 0.25,
      child: MainCard(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: AppColors.gradient,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.all(7),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'Available balance'.i18n,
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w300),
              ),
              Consumer<BalanceNotifier>(builder: (context, model, child) {
                return (model != null && model.balance != null)
                    ? Column(
                        children: <Widget>[
                          Text(
                            model.balance.error
                                ? 'Network error'.i18n
                                : '${model.balance?.quantity?.seedsFormatted} SEEDS',
                            style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w700),
                          ),
                          Consumer<SettingsNotifier>(builder: (context, settingsNotifier, child) {
                            return Consumer<RateNotifier>(builder: (context, rateNotifier, child) {
                              return Text(
                                model.balance.error
                                    ? 'Pull to update'.i18n
                                    : rateNotifier.amountToString(
                                        model.balance.numericQuantity, settingsNotifier.selectedFiatCurrency),
                                style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w300),
                              );
                            });
                          })
                        ],
                      )
                    : Shimmer.fromColors(
                        baseColor: Colors.green[300],
                        highlightColor: Colors.blue[300],
                        child: Container(
                          width: 200.0,
                          height: 26,
                          color: Colors.white,
                        ),
                      );
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  EmptyButton(
                    width: width * 0.33,
                    title: 'Send'.i18n,
                    color: Colors.white,
                    onPressed: onTransfer,
                    textScaleFactor: textScaleFactor,
                  ),
                  EmptyButton(
                    width: width * 0.33,
                    title: 'Receive'.i18n,
                    color: Colors.white,
                    onPressed: onReceive,
                    textScaleFactor: textScaleFactor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNotification() {
    final width = MediaQuery.of(context).size.width;

    final SettingsNotifier settings = SettingsNotifier.of(context);
    final backupService = Provider.of<BackupService>(context);

    if (backupService.showReminder) {
      return Consumer<BalanceNotifier>(builder: (context, model, child) {
        if (model != null &&
            model.balance != null &&
            model.balance.numericQuantity >= BackupService.BACKUP_REMINDER_MIN_AMOUNT) {
          return Container(
            width: width,
            child: MainCard(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      'Your private key has not been backed up!'.i18n,
                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w300),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          EmptyButton(
                            width: width * 0.35,
                            title: 'Backup'.i18n,
                            color: Colors.white,
                            onPressed: () {
                              backupService.backup();
                            },
                          ),
                          EmptyButton(
                            width: width * 0.35,
                            title: 'Later'.i18n,
                            color: Colors.white,
                            onPressed: () {
                              settings.updateBackupLater();
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      });
    } else {
      return Container();
    }
  }

  void onTransaction({
    TransactionModel transaction,
    MemberModel member,
    TransactionType type,
  }) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: TransactionDialog(
              transaction: transaction,
              member: member,
              transactionType: type,
            ),
          );
        });
  }

  //Fix Here
  Widget buildTransaction(TransactionModel model) {
    String userAccount = SettingsNotifier.of(context).accountName;

    TransactionType type = model.to == userAccount ? TransactionType.income : TransactionType.outcome;

    String participantAccountName = type == TransactionType.income ? model.from : model.to;

    return FutureBuilder(
      future: MembersNotifier.of(context).getAccountDetails(participantAccountName),
      builder: (ctx, member) => member.hasData
          ? InkWell(
              onTap: () => onTransaction(transaction: model, member: member.data, type: type),
              child: Column(
                children: [
                  Divider(height: 22),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Flexible(
                            child: Row(
                          children: <Widget>[
                            TransactionAvatar(
                              size: 40,
                              account: member.data.account,
                              nickname: member.data.nickname,
                              image: member.data.image,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.blue,
                              ),
                            ),
                            Flexible(
                                child: Container(
                                    margin: EdgeInsets.only(left: 10, right: 10),
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                      Container(
                                        child: Text(
                                          member.data.nickname,
                                          maxLines: 1,
                                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15,color: Colors.black),
                                        ),
                                      ),
                                      Container(
                                        child: Text(readTimestamp(model.timestamp),
                                          //model.timestamp,
                                          maxLines: 1,
                                          style: TextStyle(color: AppColors.grey, fontSize: 13),
                                        ),
                                      ),
                                    ])))
                          ],
                        )),
                        Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Container(
                                  margin: EdgeInsets.only(left: 10, right: 15),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        model.quantity.seedsFormatted,
                                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15,color: Colors.black),
                                      ),
                                      Icon(
                                        type == TransactionType.income ? Icons.arrow_upward : Icons.arrow_downward,
                                      ),
                                    ],
                                  )),
                              Container(
                                child: Text(" SEEDS", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15,color: Colors.black),
                                          )
                              ),
                            ])),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 16,
                    color: Colors.white,
                    margin: EdgeInsets.only(left: 10, right: 10),
                  ),
                ],
              ),
            ),
    );
  }

  //Fix Here
  Widget buildTransactions() {
    return MainCard(
      padding: EdgeInsets.only(top: 15, bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(bottom: 3, left: 15, right: 15),
              child: Text(
                'Latest transactions'.i18n,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
              )),
          Consumer<TransactionsNotifier>(
            builder: (context, model, child) => model != null && model.transactions != null
                ? Column(
                    children: <Widget>[
                      ...model.transactions.map((trx) {
                        return buildTransaction(trx);
                      }).toList()
                    ],
                  )
                : Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          height: 16,
                          color: Colors.black,
                          margin: EdgeInsets.only(left: 10, right: 10),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget buildSendReceiveButton() {
    return (Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Expanded(child: SendButton(onPress: onTransfer)),
      SizedBox(width: 20),
      Expanded(child: ReceiveButton(onPress: onReceive)),
    ]));
  }
}
