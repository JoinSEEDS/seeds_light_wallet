import 'package:flutter/material.dart';
import 'package:flutter_toolbox/flutter_toolbox.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/screens/app/proposals/proposal_details.dart';
import 'package:seeds/screens/app/proposals/proposal_header_details.dart';

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
          backgroundColor: Theme.of(context).canvasColor,
          elevation: 0,
          title: TabBar(
            labelColor: Colors.black,
            tabs: proposalTypes.keys.map((type) => Tab(text: type)).toList(),
          ),
        ),
        body: TabBarView(
          children: proposalTypes.values
              .map((type) => ProposalsList(type: type))
              .toList(),
        ),
      ),
    );
  }
}

class ProposalsList extends StatefulWidget {
  final String type;

  const ProposalsList({Key key, @required this.type}) : super(key: key);

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
          HttpService.of(context).getProposals(widget.type),
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
          onTap: () => push(context, ProposalDetailsPage(proposal: proposal)),
          child: ProposalHeaderDetails(proposal),
        ),
      ),
    );
  }
}
