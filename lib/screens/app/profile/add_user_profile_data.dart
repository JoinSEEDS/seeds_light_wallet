import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_toolbox/flutter_toolbox.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/providers/notifiers/profile_notifier.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/main_text_field.dart';
import 'package:seeds/i18n/profile.i18n.dart';

class AddUserProfileDataArgs {
  final InputType inputType;
  List<String> items;

  AddUserProfileDataArgs({
    this.inputType,
    this.items,
  });
}

class AddUserProfileDataPage extends StatefulWidget {
  final AddUserProfileDataArgs args;

  AddUserProfileDataPage({Key key, @required this.args}) : super(key: key);

  @override
  _AddUserProfileDataPageState createState() => _AddUserProfileDataPageState();
}

class _AddUserProfileDataPageState extends State<AddUserProfileDataPage> {
  final _itemController = TextEditingController();
  var savingLoader = GlobalKey<MainButtonState>();

  @override
  initState() {
//    Future.delayed(Duration.zero).then((_) {
//      ProfileNotifier.of(context).fetchProfile().then((profile) {
//        _nameController.text = profile.nickname;
//      });
//    });
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileNotifier>(
      builder: (ctx, model, _) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.black,
            ),
            title: Text(_inputTypeTitle(widget.args.inputType)),
          ),
          body: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _inputTypeLabel(widget.args.inputType),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: MainTextField(
                            labelText: null,
                            hintText: "Add 1 to " + getMaxedAllowed(widget.args.inputType).toString() + " words",
                            autocorrect: false,
                            controller: _itemController,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.add_circle_outline,
                          ),
                          iconSize: 30,
                          onPressed: () {
                            if (_itemController.text.isEmpty) {
                              errorToast('Enter a ' + _inputTypeTitle(widget.args.inputType));
                            } else {
                              if (widget.args.items.length < getMaxedAllowed(widget.args.inputType)) {
                                _itemAdded(_itemController.value.text);
                              } else {
                                errorToast('Max Reached');
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      alignment: WrapAlignment.start,
                      direction: Axis.horizontal,
                      children: widget.args.items
                          .map((friend) => Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Chip(
                                  label: Text(friend),
                                  deleteIcon: Icon(Icons.close, size: 16),
                                  onDeleted: () {
                                    _itemRemoved(friend);
                                  },
                                ),
                              ))
                          .toList(),
                    ),
                    SizedBox(height: 20),
                    MainButton(
                      key: savingLoader,
                      title: 'Save'.i18n,
                      onPressed: () async {
                        Object data = {
                          _dataKey(widget.args.inputType): json.encode(widget.args.items),
                          "nickname" : "Gery"
                        };

                        await Provider.of<EosService>(context, listen: false).updateProfileData(data: data);

                        Navigator.pop(context, widget.args.items);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _itemRemoved(String item) async {
    setState(() {
      widget.args.items.remove(item);
    });
  }

  void _itemAdded(String item) async {
    setState(() {
      widget.args.items.add(item);
      _itemController.text = "";
    });
  }

  String _inputTypeLabel(InputType inputType) {
    switch (inputType) {
      case InputType.SKILLS:
        return "What are your skills or area of expertise?".i18n;
      case InputType.ROLES:
        return "What Role are you willing to play in the community?".i18n;
      case InputType.INTERESTS:
        return "What are your main interests?".i18n;
    }
  }

  String _inputTypeTitle(InputType inputType) {
    switch (inputType) {
      case InputType.SKILLS:
        return "Skill".i18n;
      case InputType.ROLES:
        return "Role".i18n;
      case InputType.INTERESTS:
        return "Interest".i18n;
    }
  }

  String _dataKey(InputType inputType) {
    switch (inputType) {
      case InputType.SKILLS:
        return "skills";
      case InputType.ROLES:
        return "roles";
      case InputType.INTERESTS:
        return "interests";
    }
  }
}

enum InputType {
  SKILLS,
  ROLES,
  INTERESTS,
}

int getMaxedAllowed(InputType inputType) {
  switch (inputType) {
    case InputType.SKILLS:
      return 9;
    case InputType.ROLES:
      return 3;
    case InputType.INTERESTS:
      return 9;
  }
}
