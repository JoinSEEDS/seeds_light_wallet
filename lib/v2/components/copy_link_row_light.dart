import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/design/app_theme.dart';

/// Copy Link
///
/// Used to display a row with a Hash and a copy Icon at the end

class ShareLinkRowLight extends StatelessWidget {
  final String label;
  final String link;

  const ShareLinkRowLight({
    required this.label,
    required this.link,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(label, style: Theme.of(context).textTheme.subtitle2HighEmphasis),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: Text(
            link,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.subtitle2HighEmphasis,
          ),
        ),
        IconButton(
            icon: const Icon(Icons.copy),
            color: AppColors.white,
            onPressed: () {
              Clipboard.setData(const ClipboardData(text: 'TODO')).then(
                (value) {
                  ScaffoldMessenger.maybeOf(context)!
                      .showSnackBar(const SnackBar(content: Text("Copied"), duration: Duration(seconds: 1)));
                },
              );
            })
      ],
    );
  }
}
