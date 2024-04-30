import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:seeds/components/profile_avatar.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/transaction_model.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/wallet/interactor/viewmodels/member_bloc.dart';
import 'package:seeds/utils/string_extension.dart';
import 'package:share/share.dart';

class TransactionDetailsBottomSheet extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionDetailsBottomSheet(this.transaction, {super.key});

  void show(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0)),
      ),
      context: context,
      builder: (_) => this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final account = settingsStorage.accountName;
    return BlocProvider(
      create: (_) =>
          MemberBloc(transaction.to == account ? transaction.from : transaction.to)..add(const OnLoadMemberData()),
      child: BlocBuilder<MemberBloc, MemberState>(
        builder: (context, state) {
          switch (state.pageState) {
            case PageState.loading:
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Center(child: CircularProgressIndicator()),
              );
            case PageState.success:
              return Stack(
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 12.0),
                        Text(
                          DateFormat("EEE dd MMM y kk:mm:ss").format(transaction.timestamp),
                          style: Theme.of(context).textTheme.subtitle2HighEmphasis,
                        ),
                        const SizedBox(height: 16.0),
                        ProfileAvatar(
                          size: 60,
                          account: state.currentAccount,
                          nickname: state.localizedDisplayName(context),
                          image: state.profileImageURL,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.lightGreen2),
                        ),
                        const SizedBox(height: 16.0),
                        Column(
                          children: [
                            Text(
                              state.localizedDisplayName(context),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headline7,
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              state.currentAccount,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.subtitle2OpacityEmphasis,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (account == transaction.to)
                              Text('+', style: Theme.of(context).textTheme.subtitle1Green1)
                            else
                              Text('-', style: Theme.of(context).textTheme.subtitle1Red2),
                            const SizedBox(width: 4),
                            Text(transaction.quantity.seedsFormatted, style: Theme.of(context).textTheme.headline5)
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
                          child: Text(
                            "Memo: ${transaction.memo.isEmpty ? '---' : transaction.memo}",
                            maxLines: 6, // <-- memo has a max of 256 characteres
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () => Share.share('https://explorer.telos.net/transaction/${transaction.transactionId}'),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(color: AppColors.green1, shape: BoxShape.circle),
                            child: SvgPicture.asset('assets/images/wallet/share_transaction_id.svg'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/images/wallet/leaves_bttm_left.png',
                          width: MediaQuery.of(context).size.width * 0.45,
                        ),
                        Image.asset(
                          'assets/images/wallet/leaves_bttm_right.png',
                          width: MediaQuery.of(context).size.width * 0.45,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
