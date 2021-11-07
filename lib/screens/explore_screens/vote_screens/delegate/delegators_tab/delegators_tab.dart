import 'package:flutter/material.dart';
import 'package:seeds/domain-shared/ui_constants.dart';

class DelegatorsTab extends StatelessWidget {
  const DelegatorsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: horizontalEdgePadding),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
                'Delegators are Citizens that have chosen you to vote on their behalf. All votes already cast this cycle will not change. Deactivating Delegators makes it so other citizens cannot delegate their voting power to you.',
                style: Theme.of(context).textTheme.subtitle2),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
