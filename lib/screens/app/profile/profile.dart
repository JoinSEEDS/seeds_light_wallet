import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/profile_notifier.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/main_text_field.dart';
import 'package:path/path.dart' as pathUtils;
import 'package:uuid/uuid.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _nameController = TextEditingController();
  File _profileImage;
  var savingLoader = GlobalKey<MainButtonState>();

  @override
  initState() {
    Future.delayed(Duration.zero).then((_) {
      ProfileNotifier.of(context).fetchProfile();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileNotifier>(
      builder: (ctx, model, _) {
        if (model?.profile != null && model.profile.nickname != null) {
          _nameController.text = model?.profile?.nickname ?? '';
        }
        return Scaffold(
          body: ListView(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 180.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: AppColors.gradient),
                ),
                child: Center(
                  child: Stack(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          if (model?.profile?.image != null)
                            NavigationService.of(context)
                                .navigateTo(Routes.imageViewer, model.profile);
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
                                      errorWidget: (context, url, error) {
                                        return Container(
                                          color: AppColors.getColorByString(
                                              model?.profile?.nickname ?? ''),
                                          child: Center(
                                            child: Text(
                                              (model?.profile?.nickname != null)
                                                  ? model?.profile?.nickname
                                                      ?.substring(0, 2)
                                                      ?.toUpperCase()
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
                            onPressed: () =>
                                _editProfilePicBottomSheet(context),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 32.0, top: 32.0, right: 32.0),
                child: MainTextField(
                  labelText: "Name",
                  hintText: 'Your Name',
                  controller: _nameController,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 32.0, top: 16.0, right: 32.0),
                child: MainButton(
                  key: savingLoader,
                  title: 'Save',
                  onPressed: () => _saveProfile(model.profile),
                ),
              ),
              MainButton(
                title: "Logout",
                onPressed: () {
                  NavigationService.of(context).navigateTo(Routes.logout);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _editProfilePicBottomSheet(BuildContext context) {
    Map<String, IconData> _items = {
      'Choose from Gallery': Icons.image,
      'Click a picture': Icons.camera_alt,
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
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
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
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
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
    await Provider.of<EosService>(context, listen: false).updateProfile(
      nickname: _nameController.text ?? (profile.nickname ?? ''),
      image: attachmentUrl ?? (profile.image ?? ''),
      story: '',
      roles: '',
      skills: '',
      interests: '',
    );
    savingLoader.currentState.done();
  }

  _uploadFile(ProfileModel profile) async {
    String extensionName = pathUtils.extension(_profileImage.path);
    String path =
        "ProfileImage/" + profile.account + '/' + Uuid().v4() + extensionName;
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(path);
    String fileType =
        extensionName.isNotEmpty ? extensionName.substring(1) : '*';
    var uploadTask = storageReference.putFile(
        _profileImage, StorageMetadata(contentType: "image/$fileType"));
    await uploadTask.onComplete;
    return await storageReference.getDownloadURL();
  }
}
