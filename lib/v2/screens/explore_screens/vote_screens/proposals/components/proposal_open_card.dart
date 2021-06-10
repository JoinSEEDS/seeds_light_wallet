import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
// import 'package:seeds/providers/notifiers/voted_notifier.dart';
import 'package:seeds/utils/old_toolbox/net_image.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/datasource/remote/model/proposals_model.dart';
import 'package:seeds/v2/navigation/navigation_service.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:seeds/i18n/proposals.i18n.dart';

class ProposalOpenCard extends StatefulWidget {
  final ProposalModel proposal;
  final bool fromDetails;

  const ProposalOpenCard(this.proposal, {this.fromDetails = false});

  @override
  _ProposalOpenCardState createState() => _ProposalOpenCardState();
}

class _ProposalOpenCardState extends State<ProposalOpenCard> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final proposal = widget.proposal;
    var createdAt = DateTime.fromMillisecondsSinceEpoch(proposal.creationDate * 1000);
    String creationDateFormatted = createdAt.formatRelative();

    return Hero(
      tag: proposal.hashCode,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.all(16),
        elevation: 8,
        child: InkWell(
          onTap: () {
            NavigationService.of(context).navigateTo(Routes.proposalDetailsPage, proposal);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (proposal.image.isNotEmpty == true && !widget.fromDetails)
                Stack(
                  children: [
                    NetImage(proposal.image),
                    Positioned(
                      left: 0,
                      top: 12,
                      child: CustomPaint(
                        size: const Size(82, 22),
                        painter: Category(),
                        child: Text(proposal.campaignType),
                      ),
                    )
                  ],
                ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Text(
                      proposal.title,
                      style: textTheme.headline6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Text(
                      proposal.summary,
                      style: textTheme.subtitle1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: RichText(
                      text: TextSpan(
                        children: <InlineSpan>[
                          TextSpan(
                            text: 'Created by:'.i18n + ' ',
                            style: textTheme.subtitle2!.copyWith(fontWeight: FontWeight.normal),
                          ),
                          TextSpan(
                            text: proposal.creator,
                            style: textTheme.subtitle2,
                          ),
                          TextSpan(
                            text: ' • ',
                            style: textTheme.subtitle2,
                          ),
                          TextSpan(
                            text: creationDateFormatted,
                            style: textTheme.subtitle2!.copyWith(fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'total\n%s'.i18n.fill(["${proposal.total}"]),
                          textAlign: TextAlign.left,
                          style: textTheme.caption!.copyWith(
                            fontSize: 14,
                          ),
                        ),
                        buildVotesIndicator(
                          title: 'Yes'.i18n,
                          color: Colors.greenAccent,
                          votes: proposal.favour,
                          total: proposal.total,
                        ),
                        buildVotesIndicator(
                          title: 'No'.i18n,
                          color: Colors.redAccent,
                          votes: proposal.against,
                          total: proposal.total,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: FutureBuilder(
                            future: null, //VotedNotifier.of(context).fetchVote(proposalId: proposal.id),
                            builder: (ctx, snapShot) {
                              if (snapShot.hasData) {
                                var voted = true; //snapShot.data.voted;
                                var amount = 10; //snapShot.data.amount;
                                var voteString = amount == 0
                                    ? 'neutral'
                                    : amount < 0
                                        ? '-${-amount}'
                                        : '+$amount';
                                return voted
                                    ? Container(
                                        padding: const EdgeInsets.all(4),
                                        height: 24,
                                        child: Text(
                                          "Voted $voteString",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: amount < 0 ? Colors.white : Colors.grey[600],
                                              fontWeight: FontWeight.bold),
                                        ),
                                        color: amount == 0
                                            ? Colors.black12
                                            : amount > 0
                                                ? Colors.greenAccent
                                                : Colors.red.withOpacity(.8))
                                    : Container(
                                        height: 16,
                                      );
                              } else {
                                return Container(
                                  height: 16,
                                );
                              }
                            }),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProposalDetails(ProposalModel proposal) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (proposal.image.isNotEmpty == true && !widget.fromDetails) NetImage(proposal.image),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (!widget.fromDetails)
                Text(
                  proposal.title,
                  style: textTheme.headline6,
                ),
              const SizedBox(height: 8),
              Text(
                proposal.summary,
                style: textTheme.subtitle1,
              ),
              const SizedBox(height: 8),
              Text(
                DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(proposal.creationDate)),
                style: textTheme.subtitle2,
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '%s votes'.i18n.fill(["${proposal.total}"]),
                    style: textTheme.caption!.copyWith(fontSize: 14),
                  ),
                  buildVotesIndicator(
                    title: 'Yes'.i18n,
                    color: Colors.greenAccent,
                    votes: proposal.favour,
                    total: proposal.total,
                  ),
                  buildVotesIndicator(
                    title: 'No'.i18n,
                    color: Colors.redAccent,
                    votes: proposal.against,
                    total: proposal.total,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildVotesIndicator({required String title, Color? color, int? votes, int? total}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 6, bottom: 4),
              child: Text(
                title,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            LinearPercentIndicator(
              animation: true,
              lineHeight: 8,
              animationDuration: 800,
              percent: total == 0 ? 0 : votes!.toDouble() / total!.toDouble(),
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: color,
            ),
          ],
        ),
      ),
    );
  }
}

extension RelativeTimeFormat on DateTime {
  String formatRelative() {
    if (DateTime.now().difference(this) > const Duration(days: 7)) {
      return DateFormat.yMd().format(this);
    } else {
      return timeago.format(this);
    }
  }
}

class Category extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0 = Paint()
      ..color = AppColors.orangeYellow
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path path_0 = Path();
    path_0.moveTo(0, 0);
    path_0.lineTo(0, size.height);
    path_0.lineTo(size.width - 1, size.height);
    path_0.lineTo(size.width, size.height - 1);
    path_0.lineTo(size.width - 10, size.height - 11);
    path_0.lineTo(size.width, 1);
    path_0.lineTo(size.width - 1, 0);
    path_0.lineTo(0, 0);
    path_0.close();

    canvas.drawPath(path_0, paint_0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
