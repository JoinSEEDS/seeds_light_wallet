import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/interactor/viewmodel/region_bloc.dart';

class RegionAbout extends StatelessWidget {
  const RegionAbout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.fromLTRB(26.0, 0, 26.0, 26.0),
      child: Text(BlocProvider.of<RegionBloc>(context).state.region?.description ?? ''),
    );
  }
}
