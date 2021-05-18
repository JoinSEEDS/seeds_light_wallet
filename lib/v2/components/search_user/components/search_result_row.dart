import 'package:flutter/material.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/components/profile_avatar.dart';

class SearchResultRow extends StatelessWidget {
  final String? imageUrl;
  final String account;
  final String? name;

  const SearchResultRow({Key? key, this.imageUrl, required this.account, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 16, right: 16),
      child: Row(
        children: [
          ProfileAvatar(
            size: 60,
            image: imageUrl,
            account: account,
            nickname: name,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (name != null && name?.isNotEmpty == true) ? name! : account,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.button,
                  ),
                  const SizedBox(height: 8),
                  Text(account, style: Theme.of(context).textTheme.subtitle2OpacityEmphasis)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
