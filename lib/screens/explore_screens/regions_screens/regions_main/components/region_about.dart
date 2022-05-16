import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/interactor/viewmodel/region_bloc.dart';

class RegionAbout extends StatelessWidget {
  const RegionAbout({super.key});

  @override
  Widget build(BuildContext context) {
    final text = BlocProvider.of<RegionBloc>(context).state.region?.description ?? '';
    return SingleChildScrollView(
        child: Container(alignment: Alignment.topLeft, padding: const EdgeInsets.all(26.0), child: Text(text)));
  }
}
