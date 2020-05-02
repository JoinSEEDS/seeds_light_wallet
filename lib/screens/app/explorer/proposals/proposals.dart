import 'package:flutter/material.dart';
import 'package:flutter_toolbox/flutter_toolbox.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/screens/app/explorer/proposals/proposal_header_details.dart';

class Proposals extends StatefulWidget {
  @override
  ProposalsState createState() => ProposalsState();
}

class ProposalsState extends State<Proposals> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: proposalTypes.length,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Theme.of(context).canvasColor,
          elevation: 0,
          title: Text(
            "Proposals",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Column(
          children: [
            Container(
              height: 33,
              child: TabBar(
                labelColor: Colors.black,
                tabs:
                    proposalTypes.keys.map((type) => Tab(text: type)).toList(),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: proposalTypes.values
                    .map((data) => ProposalsList(type: data['stage'], status: data['status']))
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProposalsList extends StatefulWidget {
  final String type;
  final String status;

  const ProposalsList({Key key, @required this.type, @required this.status}) : super(key: key);

  @override
  _ProposalsListState createState() => _ProposalsListState();
}

class _ProposalsListState extends State<ProposalsList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return PaginatedListView<ProposalModel>(
      pageFuture: (int pageIndex) =>
          HttpService.of(context).getProposals(widget.type, widget.status),
      pageSize: 1000,
      showRefreshIndicator: true,
      itemBuilder: (BuildContext context, ProposalModel proposal, int index) {
        return buildProposal(proposal);
      },
    );
  }

  Widget buildProposal(ProposalModel proposal) {
    return Hero(
      tag: proposal.hashCode,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.all(16),
        elevation: 8,
        child: InkWell(
          onTap: () => NavigationService.of(context)
              .navigateTo(Routes.proposalDetailsPage, proposal),
          child: ProposalHeaderDetails(proposal),
        ),
      ),
    );
  }
}
