import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/widgets/main_text_field.dart';
import 'package:seeds/widgets/main_button.dart';


class Profile extends StatefulWidget {

  @override
  ProfileState createState() => ProfileState();
}


class ProfileState extends State<Profile> {

  final textController = TextEditingController(text: 'name');

  void onImage() {

  }

  void onSave() {

  }
  
  void onShare() {

  }

  void onLogout() {

  }

  Widget buildHeader() {
    final width = MediaQuery.of(context).size.width;
    final imageUrl = null;
    final userName = 'username';
    return Container(
      width: width,
      padding: EdgeInsets.only(top: 5, left: 25, right: 25, bottom: 25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: AppColors.gradient
        )
      ),
      child: Column(
        children: <Widget>[
          Text('My profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600
            ),
          ),
          InkWell(
            onTap: onImage,
            child: Container(
              width: 90,//width * 0.25,
              height: 90,//width * 0.25,
              margin: EdgeInsets.only(top: 15, bottom: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(90),//width * 0.25),
                child: Container(
                  color: AppColors.blue,
                  child: Stack(
                    children: <Widget>[
                      imageUrl != null ? 
                      CachedNetworkImage(imageUrl: imageUrl) :
                      Container(),
                      Container(
                        alignment: Alignment.center,
                        color: Colors.black.withOpacity(0.4),
                        child: Icon(Icons.photo_camera,
                          size: 35,
                          color: Colors.white,
                        )
                      )
                    ],
                  )
                )
              )
            )
          ),
          Text(userName ?? 'username',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEdit() {
    return Container(
      margin: EdgeInsets.all(15),
      child: Column(
        children: <Widget>[
          MainTextField(
            labelText: 'Name',
            controller: textController,
          ),
          MainButton(
            title: 'Save',
            margin: EdgeInsets.only(top: 25),
            onPressed: onSave,
          )
        ],
      )
    );
  }

  Widget buildBottom() {
    return Column(
      children: [
        InkWell(
          onTap: onShare,
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 20,
                  height: 20,
                  margin: EdgeInsets.only(right: 12),
                  child: SvgPicture.asset('assets/images/share.svg',
                    color: AppColors.blue,
                  ),
                ),
                Text('Export private key',
                  style: TextStyle(
                    color: AppColors.blue,
                    fontSize: 16
                  ),
                )
              ],
            )
          )
        ),
        InkWell(
          onTap: onLogout,
          child: Container(
            margin: EdgeInsets.only(top: 12, bottom: 12),
            alignment: Alignment.center,
            color: Colors.white,
            padding: EdgeInsets.all(15),
            child: Text('Log out',
              style: TextStyle(
                color: AppColors.red,
                fontSize: 16
              ),
            )
          )
        )
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    //TODO: resizeToAvoitBottom: true in scaffold
    return Container(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  buildHeader(),
                  buildEdit(),
                ]
              )
            ),
            buildBottom()
          ],
        )
      )
    );
  }
}