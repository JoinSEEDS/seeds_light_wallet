import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as pathUtils;
import 'package:provider/provider.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/constants/config.dart';
import 'package:seeds/i18n/profile.i18n.dart';
import 'package:seeds/models/firebase/firebase_user.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/profile_notifier.dart';
import 'package:seeds/providers/notifiers/rate_notiffier.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/firebase/firebase_database_service.dart';
import 'package:seeds/providers/services/firebase/firebase_remote_config.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/screens/app/profile/image_viewer.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/main_text_field.dart';
import 'package:seeds/widgets/pending_notification.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:uuid/uuid.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  File _profileImage;
  var savingLoader = GlobalKey<MainButtonState>();
  final picker = ImagePicker();

  @override
  initState() {
    var cachedProfile = ProfileNotifier.of(context).profile;
    FirebaseDatabaseService().getUserData(SettingsNotifier.of(context).accountName).listen((FirebaseUser userData) {
      if (userData.phoneNumber != null) {
        _phoneController.text = userData.phoneNumber;
      }
    });

    if (cachedProfile != null) {
      _nameController.text = cachedProfile.nickname;
    }

    Future.delayed(Duration.zero).then((_) {
      ProfileNotifier.of(context).fetchProfile().then((profile) {
        _nameController.text = profile.nickname;
      });
    });

    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileNotifier>(
      builder: (ctx, model, _) {
        return Scaffold(
          body: ListView(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 180.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: AppColors.gradient),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Stack(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            if (model?.profile?.image != null)
                              NavigationService.of(context).navigateTo(
                                Routes.imageViewer,
                                ImageViewerArguments(
                                  imageUrl: model.profile.image,
                                  heroTag: "profilePic",
                                ),
                              );
                          },
                          child: Hero(
                            tag: 'profilePic',
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: Container(
                                width: 100.0,
                                height: 100.0,
                                child: (_profileImage != null)
                                    ? Image.file(
                                        _profileImage,
                                        fit: BoxFit.cover,
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: model?.profile?.image ?? '',
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) {
                                          return Container(
                                            color: AppColors.getColorByString(model?.profile?.nickname ?? ''),
                                            child: Center(
                                              child: Text(
                                                (model?.profile?.nickname != null)
                                                    ? model?.profile?.nickname?.substring(0, 2)?.toUpperCase()
                                                    : '?',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 32.0,
                            height: 32.0,
                            child: FloatingActionButton(
                              elevation: 0,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.camera_alt,
                                size: 16.0,
                                color: Colors.black,
                              ),
                              onPressed: () => _editProfilePicBottomSheet(context),
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Column(
                        children: [
                          Text(
                            SettingsNotifier.of(context).accountName,
                            style: TextStyle(
                              fontFamily: "worksans",
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            model?.profile?.status ?? '',
                            style: TextStyle(
                              fontFamily: "worksans",
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 32.0, top: 32.0, right: 32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        MainTextField(
                            labelText: "Full Name".i18n,
                            hintText: 'Enter your name'.i18n,
                            autocorrect: false,
                            controller: _nameController,
                            validator: (String val) {
                              String error;
                              if (val.isEmpty) {
                                error = "Name cannot be empty".i18n;
                              }
                              return error;
                            }),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: MainTextField(
                              labelText: "Phone Number",
                              hintText: 'Enter your phone number',
                              autocorrect: false,
                              controller: _phoneController,
                              validator: (String val) {
                                String error;
                                if (val.isEmpty) {
                                  error = "Phone number cannot be empty";
                                }
                                return error;
                              }),
                        ),
                      ],
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 32.0, top: 16.0, right: 32.0),
                child: MainButton(
                  key: savingLoader,
                  title: 'Save'.i18n,
                  onPressed: () => {
                    if (_formKey.currentState.validate()) {_saveProfile(model.profile)}
                  },
                ),
              ),
              StreamBuilder<bool>(
                  stream: FirebaseDatabaseService()
                      .hasGuardianNotificationPending(SettingsNotifier.of(context, listen: false).accountName),
                  builder: (context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot != null && snapshot.hasData) {
                      return _guardiansView(snapshot.data);
                    } else {
                      return _guardiansView(false);
                    }
                  }),
              Consumer<SettingsNotifier>(
                builder: (context, settingsNotifier, child) => Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: FlatButton(
                    color: Colors.white,
                    child: Text(
                      'Selected Currency:'.i18n + settingsNotifier.selectedFiatCurrency,
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: _chooseCurrencyBottomSheet,
                  ),
                ),
              ),
              FlatButton(
                color: Colors.white,
                child: Text(
                  'Terms & Conditions'.i18n,
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () => UrlLauncher.launch(Config.termsAndConditionsUrl),
              ),
              FlatButton(
                color: Colors.white,
                child: Text(
                  'Privacy Policy'.i18n,
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () => UrlLauncher.launch(Config.privacyPolicyUrl),
              ),
              FlatButton(
                color: Colors.white,
                child: Text(
                  'Export private key'.i18n,
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () => Share.share(SettingsNotifier.of(context).privateKey),
              ),
              FlatButton(
                color: Colors.white,
                child: Text(
                  'Logout'.i18n,
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () => NavigationService.of(context).navigateTo(Routes.logout),
              )
            ],
          ),
        );
      },
    );
  }

  void _chooseCurrencyBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Consumer<RateNotifier>(builder: (context, rateNotifier, child) {
          final currencies = rateNotifier.fiatRate.currencies;

          return ListView.builder(
            itemCount: currencies.length,
            itemBuilder: (ctx, index) => ListTile(
              title: Text(currencies[index]),
              onTap: () {
                SettingsNotifier.of(context).saveSelectedFiatCurrency(currencies[index]);
                Navigator.of(context).pop();
              },
            ),
          );
        });
      },
    );
  }

  void _editProfilePicBottomSheet(BuildContext context) {
    Map<String, IconData> _items = {
      'Choose Picture'.i18n: Icons.image,
      'Take a picture'.i18n: Icons.camera_alt,
    };
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: _items.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(
                _items.values.elementAt(index),
                color: Colors.black,
              ),
              title: Text(_items.keys.elementAt(index)),
              onTap: () {
                switch (index) {
                  case 0:
                    {
                      _getImageFromGallery();
                      Navigator.pop(context);
                      break;
                    }
                  case 1:
                    {
                      _getImageFromCamera();
                      Navigator.pop(context);
                      break;
                    }
                }
              },
            );
          },
        );
      },
    );
  }

  Future _getImageFromGallery() async {
    var image = await picker.getImage(source: ImageSource.gallery);
    if (image == null) return;
    var croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
    );
    setState(() {
      _profileImage = croppedFile;
    });
  }

  Future _getImageFromCamera() async {
    var image = await picker.getImage(source: ImageSource.camera);
    if (image == null) return;
    var croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
    );
    setState(() {
      _profileImage = croppedFile;
    });
  }

  void _saveProfile(ProfileModel profile) async {
    savingLoader.currentState.loading();
    var attachmentUrl;
    if (_profileImage != null) {
      attachmentUrl = await _uploadFile(profile);
    }
    try {
      await Provider.of<EosService>(context, listen: false).updateProfile(
        nickname: (_nameController.text == null || _nameController.text.isEmpty)
            ? (profile.nickname ?? '')
            : _nameController.text,
        image: attachmentUrl ?? (profile.image ?? ''),
        story: '',
        roles: '',
        skills: '',
        interests: '',
      );

      FirebaseDatabaseService().saveUserPhoneNumber(profile.nickname, _phoneController.text);

      final snackBar = SnackBar(
        content: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.done,
                color: Colors.green,
              ),
            ),
            Expanded(
              child: Text(
                'Profile updated successfully.'.i18n,
                maxLines: null,
              ),
            ),
          ],
        ),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    } catch (e) {
      print('error: $e');
      final snackBar = SnackBar(
        content: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.close,
                color: Colors.red,
              ),
            ),
            Expanded(
              child: Text(
                'An error occured, please try again.'.i18n,
                maxLines: null,
              ),
            ),
          ],
        ),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }

    savingLoader.currentState.done();
    Future.delayed(Duration.zero).then((_) {
      ProfileNotifier.of(context).fetchProfile();
    });
  }

  _uploadFile(ProfileModel profile) async {
    String extensionName = pathUtils.extension(_profileImage.path);
    String path = "ProfileImage/" + profile.account + '/' + Uuid().v4() + extensionName;
    Reference reference = FirebaseStorage.instance.ref().child(path);
    String fileType = extensionName.isNotEmpty ? extensionName.substring(1) : '*';
    await reference.putFile(_profileImage, SettableMetadata(contentType: "image/$fileType"));
    var url = await reference.getDownloadURL();
    return url;
  }

  Widget _guardiansView(bool showGuardianNotification) {
    if (FirebaseRemoteConfigService().featureFlagGuardiansEnabled) {
      return Padding(
        padding: EdgeInsets.only(top: 50.0),
        child: FlatButton(
          color: Colors.white,
          child: Stack(overflow: Overflow.visible, children: <Widget>[
            Text(
              'Key Guardians'.i18n,
              style: TextStyle(color: Colors.blue),
            ),
            Positioned(bottom: -4, right: -22, top: -4, child: guardianNotification(showGuardianNotification))
          ]),
          onPressed: () {
            if (showGuardianNotification) {
              FirebaseDatabaseService().removeGuardianNotification(SettingsNotifier.of(context).accountName);
            }
            NavigationService.of(context).navigateTo(Routes.guardianTabs);
          },
        ),
      );
    } else {
      return Container();
    }
  }
}
