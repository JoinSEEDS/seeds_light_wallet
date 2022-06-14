import 'package:flutter/material.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:share/share.dart';

/// Copy Link
///
/// Used to display a row with a Hash and a copy Icon at the end

class ShareLinkRow extends StatelessWidget {
  final String label;
  final String link;

  const ShareLinkRow({super.key, required this.label, required this.link});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: Theme.of(context).textTheme.subtitle2HighEmphasis),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            link,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.subtitle2HighEmphasis,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.share),
          color: AppColors.white,
          onPressed: () async {
            await Share.share(link);
          },
        )
      ],
    );
  }
}
