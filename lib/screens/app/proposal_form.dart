import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:seeds/services/http_service/http_service.dart';
import 'package:seeds/services/http_service/proposal_model.dart';
import 'package:seeds/widgets/progress_bar.dart';
import 'package:seeds/widgets/seeds_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:expandable/expandable.dart';

class ProposalForm extends StatelessWidget {

  Widget buildLink(String urlString) {
    return new Center(
          child: new Row(
              children: [
                new SeedsButton("View Full Proposal", () {
                      print("launch");
                      if (canLaunch(urlString) != null) {
                         launch(urlString);
                      } else {
                        throw 'Could not launch $urlString';
                      }
                })
              ],
            ),
    );
  }

  Widget buildProposalCard(BuildContext context) {
//     String title = "Pay Hypha for Reaching First Milestone and Ratifying Initial Token Distribution";
//     String subtitle = "Hypha is excited to have released the alpha version to you! We'd love to be granted some tokens to reflect this momentous event.";
//     String body = '''Hypha has proposed an initial token distribution of 3,141,592,653 tokens and is proposing certain buckets for these tokens to be allocated to:

// 1,099,557,429 for Community Led Campaigns
// 157,079,633 for Hypha Milestone Completions
// 628,318,531 for Hypha Members
// 376,991,118 for Allies and Partnerships
// 251,327,412 for Referrals and Ambassadors
// 628,318,531 for the SEEDS bank. 

// Hypha is requesting 1/4 of the 5% for milestones be distributed to Hypha with this proposal for achieving the first milestone of Launching the Alpha on November 5th 2019. 

// To ratify this token distribution and release Seeds for Hypha - vote for this proposal. If you don't agree with this distribution or with Hypha releasing these tokens vote against this proposal. 

// See link for document on IPFS [link] or click here for google drive document that you can make comments on - editing has been disabled for this document. 

// https://docs.google.com/document/d/1Ube1Qq4YxyxDFCtDS3Zk5PpItBxrohc_pD68Yl_UkRc/edit#''';
    
//     String urlString = "https://ipfs.globalupload.io/Qmdp2ak7pP5xR3KeNdih7GgqGgPABRaqSGDnvigLbWfRak";



//     String imageURLString = "https://ipfs.globalupload.io/QmVGQyjnRM77hAK4SfaVTVu45Lb7QoFpJRLeoYwA1XijyS";


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

                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 80),
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
                          collapsed: Text(body, softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis,),
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
        home: Stack(children: [
      Scaffold(
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
      )
    ]
    ));
  }
}
