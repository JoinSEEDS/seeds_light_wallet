import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
import 'package:seeds/screens/app/wallet/dashboard/wallet_header.dart';
import 'package:seeds/utils/old_toolbox/toast.dart';
import 'package:seeds/utils/string_extension.dart';
import 'package:seeds/v2/components/profile_avatar.dart';
import 'package:seeds/widgets/empty_button.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/main_card.dart';
import 'package:seeds/widgets/transaction_dialog.dart';
import 'package:seeds/widgets/v2_widgets/dashboard_widgets/receive_button.dart';
import 'package:seeds/widgets/v2_widgets/dashboard_widgets/send_button.dart';
import 'package:seeds/widgets/v2_widgets/dashboard_widgets/transaction_info_card.dart';
import 'package:shimmer/shimmer.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/features/scanner/telos_signing_manager.dart';

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
        appBar: buildAppBar(context),
        body: ListView(
          children: <Widget>[
            buildNotification(),
            WalletHeader(),
            const SizedBox(height: 20),
            buildSendReceiveButton(),
            const SizedBox(height: 20),
            walletBottom(),
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

  Widget buildTransaction(TransactionModel model) {
    String userAccount = SettingsNotifier.of(context).accountName;

    TransactionType type = model.to == userAccount ? TransactionType.income : TransactionType.outcome;

    String participantAccountName = type == TransactionType.income ? model.from : model.to;

    return FutureBuilder(
      future: MembersNotifier.of(context).getAccountDetails(participantAccountName),
      builder: (ctx, member) => member.hasData
          ? TransactionInfoCard(
              callback: () {
                onTransaction(transaction: model, member: member.data, type: type);
              },
              profileAccount: member.data.account,
              profileNickname: member.data.nickname,
              profileImage: member.data.image,
              timestamp: model.timestamp,
              amount: model.quantity,
              typeIcon: type == TransactionType.income
                  ? 'assets/images/wallet/arrow_up.svg'
                  : 'assets/images/wallet/arrow_down.svg',
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
                    margin: const EdgeInsets.only(left: 10, right: 10),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildTransactions() {
    return Column(
      children: <Widget>[
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
                        margin: const EdgeInsets.only(left: 10, right: 10),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  Widget buildSendReceiveButton() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Expanded(child: SendButton(onPress: onTransfer)),
        const SizedBox(width: 20),
        Expanded(child: ReceiveButton(onPress: onReceive)),
      ]),
    );
  }

  Widget walletBottom() {
    return Column(
      children: <Widget>[transactionHeader(), buildTransactions()],
    );
  }

  Widget transactionHeader() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
        Expanded(child: Text('Transactions History'.i18n, style: Theme.of(context).textTheme.headline7LowEmphasis)),
        Text(
          'View All'.i18n,
          style: const TextStyle(color: AppColors.canopy),
        )
      ]),
    );
  }

  Widget buildAppBar(BuildContext _context) {
    return AppBar(
      titleSpacing: 0,
      leading: Container(
        margin: const EdgeInsets.all(16),
        child: SvgPicture.asset(
          'assets/images/wallet/app_bar/appbar_icon.svg',
        ),
      ),
      title: SvgPicture.asset('assets/images/wallet/app_bar/appbar_seeds_text.svg'),
      actions: [
        Container(
          child: IconButton(
            icon: SvgPicture.asset(
              'assets/images/wallet/app_bar/scan_qr_code_icon.svg',
              height: 30,
              width: 2000,
            ),
             onPressed: () => NavigationService.of(context).navigateTo(Routes.scanQRCode),
          ),
        ),
        Container(
            padding: const EdgeInsets.only(right: 20, left: 14),
            child: const ProfileAvatar(
              size: 40,
              account: 'ff',
              nickname: 'gg',
              image: '',
            )),
      ],
    );
  }
}
