import 'package:flutter/material.dart';
import 'package:flutter_toolbox/flutter_toolbox.dart';
import 'package:seeds/i18n/proposals.i18n.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/screens/app/ecosystem/referendums/referendum_header_details.dart';

import '../../../../models/models.dart';

class Referendums extends StatefulWidget {
  @override
  ReferenumsState createState() => ReferenumsState();
}

class ReferenumsState extends State<Referendums> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: referendumTypes.length,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Theme.of(context).canvasColor,
          elevation: 0,
          title: Text(
            "Referendums".i18n,
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
                referendumTypes.keys.map((type) => Tab(text: type.i18n)).toList(),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: referendumTypes.values
                    .map((data) => ReferendumsList(stage: data['referendumStage'], reverse: data['reverse'] == 'true'))
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ReferendumsList extends StatefulWidget {
  final String stage;
  final bool reverse;

  const ReferendumsList({Key key, @required this.stage, @required this.reverse}) : super(key: key);

  @override
  _ReferendumsListState createState() => _ReferendumsListState();
}

class _ReferendumsListState extends State<ReferendumsList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return PaginatedListView<ReferendumModel>(
      pageFuture: (int pageIndex) =>
          HttpService.of(context).getReferendums(widget.stage, widget.reverse),
      pageSize: 1000,
      showRefreshIndicator: true,
      itemBuilder: (BuildContext context, ReferendumModel referendum, int index) {
        return buildReferendum(referendum);
      },
    );
  }

  Widget buildReferendum(ReferendumModel referendum) {
    return Hero(
      tag: referendum.hashCode,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.all(16),
        elevation: 8,
        child: InkWell(
          onTap: () => NavigationService.of(context)
              .navigateTo(Routes.referendumDetailsPage, referendum),
          child: ReferendumHeaderDetails(referendum),
        ),
      ),
    );
  }
}
