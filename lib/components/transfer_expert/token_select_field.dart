import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/search_user/interactor/viewmodels/search_user_bloc.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';
import 'package:seeds/utils/build_context_extension.dart';

class TokenSelectField extends StatefulWidget {
  const TokenSelectField({super.key});

  @override
  _TokenSelectFieldState createState() => _TokenSelectFieldState();
}

class _TokenSelectFieldState extends State<TokenSelectField> {
  List<String> tokenIds = TokenModel.allTokens.map((t)=>t.id).toList();
  String selectedId = settingsStorage.selectedToken.id;
  final _searchBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: AppColors.darkGreen2, width: 2.0),
  );

  @override
  void dispose() {
    //_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  PopupMenuButton(
    offset: const Offset(0, 40),
    elevation: 2,
    onSelected: (String s) {
      setState(() {
        selectedId = s;
      }); },
    itemBuilder: (context) => tokenIds
                    .map<PopupMenuEntry<String>>(
                      (c) => PopupMenuItem<String>(
                        value: c,
                        child: SizedBox(
                          height: 40,
                          // width: 180,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text('${c.split("#")[1]} (${c.split("#")[0]})',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                            ]
                                  ),
                                ),
                              ),
                          ).toList(),
    child: Row (
      children: [
        const SizedBox(width: 8),
        Text('${selectedId.split("#")[1]} (${selectedId.split("#")[0]})'),
        const SizedBox(width: 8),
        Icon(Icons.arrow_drop_down),
        const SizedBox(width: 8),
      ]
    )
    );
  }
}
