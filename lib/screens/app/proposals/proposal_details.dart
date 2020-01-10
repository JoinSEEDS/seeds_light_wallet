import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toolbox/flutter_toolbox.dart';
import 'package:seeds/screens/app/proposals/proposal_header_details.dart';
import 'package:seeds/services/http_service/proposal_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ProposalDetailsPage extends StatefulWidget {
  final ProposalModel proposal;

  const ProposalDetailsPage({Key key, @required this.proposal})
      : super(key: key);

  @override
  ProposalDetailsPageState createState() => ProposalDetailsPageState();
}

class ProposalDetailsPageState extends State<ProposalDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final proposal = widget.proposal;

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Proposal details'),
      ),
      body: ListView(
        children: <Widget>[
          buildProposalHeader(proposal),
          buildProposalDetails(proposal),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            clipBehavior: Clip.antiAlias,
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: textTheme.title,
                  ),
                  SizedBox(height: 8),
                  SelectableText('${proposal.description} '),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProposalHeader(ProposalModel proposal) {
    return Hero(
      tag: proposal.hashCode,
      flightShuttleBuilder: (BuildContext flightContext,
          Animation<double> animation,
          HeroFlightDirection flightDirection,
          BuildContext fromHeroContext,
          BuildContext toHeroContext) {
        return SingleChildScrollView(
          child: toHeroContext.widget,
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        elevation: 8,
        child: ProposalHeaderDetails(proposal),
      ),
    );
  }

  Widget buildProposalDetails(ProposalModel proposal) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recipient: ${proposal.recipient} ',
              style: textTheme.subhead,
            ),
            SizedBox(height: 8),
            Text(
              'Requested amount: ${proposal.quantity} ',
              style: textTheme.subhead,
            ),
            SizedBox(height: 8),
            Text(
              'Fund: ${proposal.fund} ',
              style: textTheme.subhead,
            ),
            SizedBox(height: 8),
            Text(
              'Status: ${proposal.status} ',
              style: textTheme.subhead,
            ),
            SizedBox(height: 8),
            Text(
              'Stage: ${proposal.stage} ',
              style: textTheme.subhead,
            ),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'URL: ',
                    style: textTheme.subhead,
                  ),
                  TextSpan(
                    text: proposal.url,
                    style: textTheme.subhead.copyWith(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        if (await canLaunch(proposal.url)) {
                          await launch(proposal.url);
                        } else {
                          errorToast("Couldn't open this url");
                        }
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
