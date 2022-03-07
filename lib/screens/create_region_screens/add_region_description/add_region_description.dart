import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/components/text_form_field_custom.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/screens/create_region_screens/viewmodels/create_region_bloc.dart';
import 'package:seeds/utils/build_context_extension.dart';

class AddRegionDescription extends StatefulWidget {
  const AddRegionDescription({Key? key}) : super(key: key);

  @override
  _AddRegionDescription createState() => _AddRegionDescription();
}

class _AddRegionDescription extends State<AddRegionDescription> {
  final _keyController = TextEditingController();
  late CreateRegionBloc _createRegionBloc;

  @override
  void initState() {
    super.initState();
    _createRegionBloc = BlocProvider.of<CreateRegionBloc>(context);
    _keyController.text = _createRegionBloc.state.regionDescription ?? '';
    _keyController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateRegionBloc, CreateRegionState>(builder: (context, state) {
      switch (state.pageState) {
        case PageState.loading:
          return const FullPageLoadingIndicator();
        case PageState.failure:
          return const FullPageErrorIndicator();
        case PageState.success:
          return WillPopScope(
              onWillPop: () async {
                BlocProvider.of<CreateRegionBloc>(context).add(const OnBackPressed());
                return false;
              },
              child: Scaffold(
                  appBar: AppBar(
                      leading: BackButton(
                          onPressed: () => BlocProvider.of<CreateRegionBloc>(context).add(const OnBackPressed())),
                      title: Text(context.loc.createRegionSelectRegionAppBarTitle)),
                  body: SafeArea(
                      minimum: const EdgeInsets.all(horizontalEdgePadding),
                      child: Stack(children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              TextFormFieldCustom(
                                controller: _keyController,
                                autofocus: true,
                                maxLines: 10,
                                labelText: context.loc.createRegionAddDescriptionInputFormTitle,
                                onChanged: (text) {
                                  BlocProvider.of<CreateRegionBloc>(context).add(OnRegionDescriptionChange(text));
                                },
                              ),
                              Text(context.loc.createRegionAddDescriptionPageInfo,
                                  style: Theme.of(context).textTheme.subtitle2OpacityEmphasis)
                            ],
                          ),
                        ),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: FlatButtonLong(
                                enabled: state.isRegionDescriptionNextAvailable,
                                title: "${context.loc.createRegionSelectRegionButtonTitle} (4/5)",
                                onPressed: () => BlocProvider.of<CreateRegionBloc>(context).add(const OnNextTapped())))
                      ]))));

        default:
          return const SizedBox.shrink();
      }
    });
  }
}
