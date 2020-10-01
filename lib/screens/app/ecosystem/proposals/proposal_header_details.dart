import 'package:flutter/material.dart';
import 'package:flutter_toolbox/flutter_toolbox.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/voted_notifier.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:seeds/i18n/proposals.i18n.dart';

class ProposalHeaderDetails extends StatefulWidget {
  final ProposalModel proposal;
  final bool fromDetails;

  const ProposalHeaderDetails(this.proposal, {this.fromDetails = false});

  @override
  _ProposalHeaderDetailsState createState() => _ProposalHeaderDetailsState();
}

class _ProposalHeaderDetailsState extends State<ProposalHeaderDetails> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final proposal = widget.proposal;

    final creationDateFormatted = timeago.format(
        DateTime.fromMillisecondsSinceEpoch(proposal.creationDate * 1000));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (proposal.image.isNotEmpty == true && !widget.fromDetails)
          NetImage(proposal.image),
        SizedBox(height: 8),
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
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Text(
                proposal.summary,
                style: textTheme.subtitle1,
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: RichText(
                text: TextSpan(
                  children: <InlineSpan>[
                    TextSpan(
                      text: 'Created by:'.i18n + ' ',
                      style: textTheme.subtitle2
                          .copyWith(fontWeight: FontWeight.normal),
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
                      style: textTheme.subtitle2
                          .copyWith(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'total\n%s'.i18n.fill(["${proposal.total}"]),
                    textAlign: TextAlign.left,
                    style: textTheme.caption.copyWith(fontSize: 14,),
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
                    future: VotedNotifier.of(context).fetchVote(proposalId: proposal.id),
                    builder: (ctx, snapShot) {
                      if (snapShot.hasData) {
                        // var voteString = snapShot.data.amount==0 ? 'Neutral' :
                        //   snapShot.data.amount < 0 ? 'no with ${-snapShot.data.amount} votes' : 'yes with ${snapShot.data.amount} votes';
                        var voted = true;//snapShot.data.voted;
                        var amount = snapShot.data.amount;
                        var voteString = amount==0 ? 'neutral' :
                          amount < 0 ? '-${-amount}' : '+$amount';
                        return voted ? 
                          Container(
                            padding: EdgeInsets.all(4),
                            height: 24,
                            child: Text(
                              "Voted $voteString", 
                              textAlign: TextAlign.center, 
                              style: TextStyle(color: amount < 0 ? Colors.white : Colors.grey[600], fontWeight: FontWeight.bold),),
                            color: amount == 0 ? Colors.black12 : amount > 0 ? Colors.greenAccent : Colors.red.withOpacity(.8)
                          ) :
                          Container(height: 16,); // Text("You have not voted yet", style: textTheme.caption.copyWith(fontSize: 14),textAlign: TextAlign.center);
                      } else { 
                        return Container(height: 16,);
                      }
                    }),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }

  Widget buildProposalDetails(ProposalModel proposal) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (proposal.image.isNotEmpty == true && !widget.fromDetails)
          NetImage(proposal.image),
        SizedBox(height: 8),
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
              SizedBox(height: 8),
              Text(
                proposal.summary,
                style: textTheme.subtitle1,
              ),
              SizedBox(height: 8),
              Text(
                DateFormat.yMMMd().format(
                    DateTime.fromMillisecondsSinceEpoch(proposal.creationDate)),
                style: textTheme.subtitle2,
              ),
              SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '%s votes'.i18n.fill(["${proposal.total}"]),
                    style: textTheme.caption.copyWith(fontSize: 14),
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

  Widget buildVotesIndicator(
      {String title, Color color, int votes, int total}) {
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
                style: TextStyle(fontSize: 14),
              ),
            ),
            LinearPercentIndicator(
              animation: true,
              lineHeight: 8,
              animationDuration: 800,
              percent: (total == 0 ? 0 : votes.toDouble() / total.toDouble()),
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: color,
            ),
          ],
        ),
      ),
    );
  }
}
