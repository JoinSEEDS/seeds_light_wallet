import 'package:flutter/material.dart';
import 'package:flutter_toolbox/flutter_toolbox.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:seeds/models/models.dart';
import 'package:timeago/timeago.dart' as timeago;

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
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                proposal.title,
                style: textTheme.title,
              ),
              SizedBox(height: 8),
              Text(
                proposal.summary,
                style: textTheme.subhead,
              ),
              SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  children: <InlineSpan>[
                    TextSpan(
                      text: 'Created by: ',
                      style: textTheme.subtitle
                          .copyWith(fontWeight: FontWeight.normal),
                    ),
                    TextSpan(
                      text: proposal.creator,
                      style: textTheme.subtitle,
                    ),
                    TextSpan(
                      text: ' • ',
                      style: textTheme.subtitle,
                    ),
                    TextSpan(
                      text: creationDateFormatted,
                      style: textTheme.subtitle
                          .copyWith(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '${proposal.total} votes',
                    style: textTheme.caption.copyWith(fontSize: 14),
                  ),
                  buildVotesIndicator(
                    title: 'Yes',
                    color: Colors.greenAccent,
                    votes: proposal.favour,
                    total: proposal.total,
                  ),
                  buildVotesIndicator(
                    title: 'No',
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
                  style: textTheme.title,
                ),
              SizedBox(height: 8),
              Text(
                proposal.summary,
                style: textTheme.subhead,
              ),
              SizedBox(height: 8),
              Text(
                DateFormat.yMMMd().format(
                    DateTime.fromMillisecondsSinceEpoch(proposal.creationDate)),
                style: textTheme.subtitle,
              ),
              SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '${proposal.total} votes',
                    style: textTheme.caption.copyWith(fontSize: 14),
                  ),
                  buildVotesIndicator(
                    title: 'Yes',
                    color: Colors.greenAccent,
                    votes: proposal.favour,
                    total: proposal.total,
                  ),
                  buildVotesIndicator(
                    title: 'No',
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
              percent: votes / total,
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: color,
            ),
          ],
        ),
      ),
    );
  }
}
