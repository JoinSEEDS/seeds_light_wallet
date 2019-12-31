import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:seeds/constants/custom_colors.dart';
import 'package:seeds/services/http_service/http_service.dart';
import 'package:seeds/services/http_service/proposal_model.dart';
import 'package:seeds/widgets/progress_bar.dart';
import 'package:seeds/widgets/seeds_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:expandable/expandable.dart';

class ProposalForm extends StatelessWidget {

  Widget buildLink(String urlString) {
    return new Center(
          child: new SeedsButton("View Full Proposal", () {
                      print("launch");
                      if (canLaunch(urlString) != null) {
                         launch(urlString);
                      } else {
                        throw 'Could not launch $urlString';
                      }
                }, false, 300)
            );
    
  }

  Widget yesLink(int proposal_id) {
    return new SeedsButton("YES", () {
                      print("YES");
                      
                }, false, 100);
    
  }

    Widget noLink(int proposal_id) {
    return new SeedsButton("NO", () {
                      print("NO");
                      
                }, false, 100, Colors.red
                );    
  }

    Widget yesNoButtons(int proposal_id) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            yesLink(proposal_id),
            noLink(proposal_id)
          ],
        ),
      );
    }



  Widget buildProposalCard(BuildContext context) {
    return SingleChildScrollView(
        child: FutureBuilder(
                      future: HttpService().getProposals(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return ProgressBar();
                        }
                        if (snapshot.data.length == 0) {
                          return Text("No proposals.");
                        }
                        print(snapshot);

                        var prop = snapshot.data[0] as ProposalModel;
                        var title = prop.title;
                        var subtitle = prop.summary;
                        var urlString = prop.url;
                        var imageURLString = prop.image;
                        var body = prop.description;
                        body = body.replaceAll(new RegExp(r'  '), "\n\n"); // 'résumé'


                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 150,
                              child: Image(
                                image: NetworkImage(imageURLString),
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          title,
                          style: TextStyle(
                              fontFamily: "worksans",
                              fontSize: 22,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 15),
                        Container(child: buildLink(urlString) ,),
                        SizedBox(height: 15),
                        Text(
                          subtitle,
                          style: TextStyle(
                              fontFamily: "worksans",
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: 15),
                        ExpandablePanel(
                          header: Text("Description"),
                          collapsed: Text(body, softWrap: true, maxLines: 4, overflow: TextOverflow.ellipsis,),
                          expanded: Text(body, softWrap: true, ),
                          tapHeaderToExpand: true,
                        ),
                      ],
                  ),
                );

                }
                    ),
              );
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Stack(
          children: [
      Container(
        color: Colors.white,
              child: SafeArea(
                child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              automaticallyImplyLeading: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                "Vote",
                style: TextStyle(fontFamily: "worksans", color: Colors.black),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Container(
              child: buildProposalCard(context),
              color: Colors.white,
            ),
            bottomSheet: yesNoButtons(2),
          ),
        ),
      )
    ]
    ));
  }
}
