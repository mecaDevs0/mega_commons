import 'package:flutter/material.dart';
import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

class MegaItemDrawer extends StatelessWidget {
  const MegaItemDrawer({
    super.key,
    required this.title,
    this.onTap,
    this.onLongPress,
    this.icon,
  });
  final String title;
  final Function()? onTap;
  final Function()? onLongPress;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minLeadingWidth: 0,
      horizontalTitleGap: 8,
      dense: true,
      leading: Icon(
        icon ?? FontAwesomeIcons.addressBook,
        size: 14,
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14),
      ),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}
