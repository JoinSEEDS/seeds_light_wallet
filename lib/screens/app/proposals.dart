import 'package:flutter/material.dart';
import 'package:flutter_toolbox/flutter_toolbox.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:seeds/services/http_service/http_service.dart';
import 'package:seeds/services/http_service/proposal_model.dart';

class Proposals extends StatefulWidget {
  @override
  ProposalsState createState() => ProposalsState();
}

class ProposalsState extends State<Proposals> {
  final httpService = HttpService();

  @override
  void initState() {
    super.initState();

    printProposals();
  }

  Future printProposals() async {
    List<ProposalModel> proposals = await httpService.getProposals();
    d("httpService.getProposals() = $proposals");
  }

  // TODO remove when the api returns real data.
  ProposalModel proposal = ProposalModel(
    id: 1,
    creator: 'Viktor',
    recipient: 'Green trees',
    quantity: '300',
    staked: '120',
    executed: false,
    total: 120,
    favour: 90,
    against: 30,
    title: 'Planting 20 million trees Planting 20 million trees',
    summary:
        'Team Trees, also known as TeamTrees or that managed to raise 20 million U.S. dollars before 2020 to plant 20 million trees. The initiative was started by American',
    description:
        'Team Trees, also known as TeamTrees or #teamtrees, is a 2019 collaborative fundraiser that managed to raise 20 million U.S. dollars before 2020 to plant 20 million trees. The initiative was started by American YouTubers MrBeast and Mark Rober, and was mostly supported by YouTubers.[1] All donations go to the Arbor Day Foundation, a tree-planting organization that pledges to plant one tree for every U.S. dollar donated.[2] The Arbor Day Foundation plans to begin planting in January 2020 and end "no later than December 2022".[2][3] It is estimated that 20 million trees would take up 180 km2 (69 sq mi) of land,[4] absorb around 1.6 million tons of carbon and remove 116 thousand tons of chemical air pollution from the atmosphere.[5][6]',
    image: 'https://teamtrees.org/images/t-shirt-mockup-winter-5.jpg',
    url: 'https://teamtrees.org/images/t-shirt-mockup-winter-5.jpg',
    status: 'Closed',
    stage: "Closed",
    fund: '120',
    creationDate: 1578457786,
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: proposalTypes.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).canvasColor,
          elevation: 0,
          title: TabBar(
            labelColor: Colors.black,
            tabs: proposalTypes.map((type) {
              return Tab(text: type);
            }).toList(),
          ),
        ),
        body: TabBarView(
          children: proposalTypes.map(buildProposalsList).toList(),
        ),
      ),
    );
  }

  ListView buildProposalsList(String type) {
    return ListView(
      children: <Widget>[
        buildProposal(proposal),
      ],
    );
  }

  Widget buildProposal(ProposalModel proposal) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(16),
      elevation: 4,
      child: Column(
        children: [
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
                Text(
                  DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(
                      proposal.creationDate)),
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
      ),
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
//            width: MediaQuery.of(context).size.width - 50,
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
