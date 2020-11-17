import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fluid_slider/flutter_fluid_slider.dart';
import 'package:flutter_toolbox/flutter_toolbox.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/voted_notifier.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/screens/app/ecosystem/proposals/proposal_header_details.dart';
import 'package:seeds/widgets/seeds_button.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:seeds/i18n/proposals.i18n.dart';

class ProposalDetailsPage extends StatefulWidget {
  final ProposalModel proposal;

  const ProposalDetailsPage({Key key, @required this.proposal})
      : super(key: key);

  @override
  ProposalDetailsPageState createState() => ProposalDetailsPageState();
}

class ProposalDetailsPageState extends State<ProposalDetailsPage> {
  VoiceModel voice;

  double _vote = 0;

  bool _voting = false;

  @override
  void didChangeDependencies() {
    // TODO this is either campaignVoice or allianceVoice
    Provider.of<HttpService>(context).getCampaignVoice().then((val) { 
      setState(() {
        voice = val;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final proposal = widget.proposal;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 250,
            flexibleSpace: FittedBox(
              fit: BoxFit.cover,
              child: NetImage(
                proposal.image,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate.fixed(<Widget>[
              buildProposalHeader(proposal),
              buildProposalDetails(proposal),
              buildVote(proposal),
            ]),
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
        child: ProposalHeaderDetails(
          proposal,
          fromDetails: true,
        ),
      ),
    );
  }

  Widget buildProposalDetails(ProposalModel proposal) {
    final textTheme = Theme.of(context).textTheme;

    double quantity =
        double.tryParse(proposal.quantity.replaceAll(RegExp(r' SEEDS'), '')) ??
            0.0;

    NumberFormat format =
        NumberFormat.currency(decimalDigits: 0, symbol: "", name: "");

    String numSeeds = format.format(quantity);

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
              'Recipient: %s '.i18n.fill(["${proposal.recipient}"]),
              style: textTheme.subtitle1,
            ),
            SizedBox(height: 8),
            Text(
              'Requested: %s SEEDS'.i18n.fill(["$numSeeds"]),
              style: textTheme.subtitle1,
            ),
            SizedBox(height: 8),
            Text(
              'Funded by: %s '.i18n.fill(["${proposal.fund}"]),
              style: textTheme.subtitle1,
            ),
            SizedBox(height: 8),
            Text(
              'Status: %s '.i18n.fill(["${proposal.status}"]),
              style: textTheme.subtitle1,
            ),
            SizedBox(height: 8),
            Text(
              'Stage: %s '.i18n.fill(["${proposal.stage}"]),
              style: textTheme.subtitle1,
            ),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'URL: '.i18n,
                    style: textTheme.subtitle1,
                  ),
                  TextSpan(
                    text: proposal.url,
                    style: textTheme.subtitle1.copyWith(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        if (await UrlLauncher.canLaunch(proposal.url)) {
                          await UrlLauncher.launch(proposal.url);
                        } else {
                          errorToast("Couldn't open this url".i18n);
                        }
                      },
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Description'.i18n,
              style: textTheme.headline6,
            ),
            SizedBox(height: 8),
            SelectableText('${proposal.description} '),
          ],
        ),
      ),
    );
  }

  Card buildVote(ProposalModel proposal) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder(
            future:
                VotedNotifier.of(context).fetchVote(proposalId: proposal.id),
            builder: (ctx, snapshot) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      snapshot.hasData && snapshot.data.voted
                          ? 'Voted'.i18n
                          : 'Voting'.i18n,
                      style: textTheme.headline6,
                    ),
                    snapshot.hasData && snapshot.data.voted
                        ? Container()
                        : SeedsButton(
                            'Vote'.i18n,
                            onPressed: () async {
                              if (_vote.toInt() != 0) {
                                setState(() => _voting = true);
                                try {
                                  await Provider.of<EosService>(context,
                                          listen: false)
                                      .voteProposal(
                                          id: proposal.id,
                                          amount: _vote.toInt());
                                } catch (e) {
                                  d("e = $e");
                                  errorToast(
                                      "Unexpected error, please try again"
                                          .i18n);
                                  setState(() => _voting = false);
                                }
                                setState(() => _voting = false);
                              }
                            },
                            showProgress: _voting,
                            enabled: _vote.toInt() != 0,
                          ),
                  ],
                ),
                SizedBox(height: 12),
                voice == null
                    ? Text("You have no trust tokens".i18n)
                    : snapshot.hasData && snapshot.data.voted
                        ? FluidSlider(
                            value: snapshot.data.amount.toDouble(),
                            onChanged: (double newValue) {},
                            min: -100,
                            max: 100,
                            sliderColor: AppColors.grey,
                            labelsTextStyle: TextStyle(color: AppColors.grey),
                            valueTextStyle: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.grey),
                            thumbColor: Colors.white,
                          )
                        : FluidSlider(
                            value: _vote,
                            onChanged: (double newValue) {
                              setState(() => _vote = newValue);
                            },
                            min: 0 - voice.amount.toDouble(),
                            max: 0 + voice.amount.toDouble(),
                          ),
              ],
            ),
          ),
        ));
  }
}
