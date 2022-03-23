import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/screens/create_region_screens/interactor/viewmodels/create_region_bloc.dart';

class ReviewRegionHeader extends StatelessWidget {
  const ReviewRegionHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return BlocBuilder<CreateRegionBloc, CreateRegionState>(
      builder: (context, state) {
        return Stack(
          children: [
            Container(
                width: width, height: height * 0.4, child: ClipRRect(child: Image.file(state.file!, fit: BoxFit.fill))),
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: Container(
                width: width,
                height: 80,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black54, Colors.transparent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              right: 0,
              child: Container(
                width: width,
                height: 80,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.black54, Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter),
                ),
              ),
            ),
            Positioned(
              left: 16,
              bottom: 10,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.currentPlace!.placeText,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Text("0 Members")
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
