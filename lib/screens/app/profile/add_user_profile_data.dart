
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:seeds/providers/notifiers/profile_notifier.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/main_text_field.dart';
import 'package:seeds/i18n/profile.i18n.dart';

class AddUserProfileDataPage extends StatefulWidget {
  @override
  _AddUserProfileDataPageState createState() => _AddUserProfileDataPageState();
}

class _AddUserProfileDataPageState extends State<AddUserProfileDataPage> {
  final _nameController = TextEditingController();
  var savingLoader = GlobalKey<MainButtonState>();

  @override
  initState() {
    var cachedProfile = ProfileNotifier.of(context).profile;
    if (cachedProfile != null) _nameController.text = cachedProfile.nickname;

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
        //  var model = ProfileNotifier.of(context).profile;

        return Scaffold(
          body: ListView(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(left: 32.0, top: 32.0, right: 32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                      ],
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 32.0, top: 16.0, right: 32.0),
                child: MainButton(
                  key: savingLoader,
                  title: 'Save'.i18n,
                  onPressed: () => {
                    if (_formKey.currentState.validate()) {}
                  },
                ),
              ),
            ],
          ),
        );
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
                      Navigator.pop(context);
                      break;
                    }
                  case 1:
                    {
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






  _userDataListLabel(int maxAllowed) {
    return Chip(
      backgroundColor: Colors.white,
      label: Text("Add 1 to " + maxAllowed.toString() + " words"),
      deleteIcon: Icon(Icons.add),
      onDeleted: () {},
    );
  }

}
