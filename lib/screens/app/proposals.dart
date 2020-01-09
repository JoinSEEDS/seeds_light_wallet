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
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: proposalTypes.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).canvasColor,
          elevation: 0,
          title: TabBar(
            labelColor: Colors.black,
            tabs: proposalTypes.keys.map((type) => Tab(text: type)).toList(),
          ),
        ),
        body: TabBarView(
          children: proposalTypes.values.map(buildProposalsList).toList(),
        ),
      ),
    );
  }

  Widget buildProposalsList(String type) {
    return PaginatedListView<ProposalModel>(
      pageFuture: (int pageIndex) => httpService.getProposals(type),
      pageSize: 1000,
      showRefreshIndicator: true,
      itemBuilder: (BuildContext context, ProposalModel proposal, int index) {
        return buildProposal(proposal);
      },
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
          if (proposal.image.isNotEmpty == true) NetImage(proposal.image),
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
