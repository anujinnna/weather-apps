import 'package:flutter/material.dart';
import 'package:weather_app/themes/colors.dart';
import 'package:weather_app/themes/custom_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? widget;
  final Icon? leadIcon;
  final Icon? actionIcon;
  final String? title;
  final Color? bgColor;
  final bool? center;

  CustomAppBar(
      {this.actionIcon,
      this.leadIcon,
      this.title,
      this.bgColor,
      this.widget,
      this.center});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: center,
      elevation: 0,
      backgroundColor: bgColor,
      leading: leadIcon == null
          ? null
          : IconButton(
              icon: leadIcon!,
              iconSize: 20,
              color: AppColors.dividerLine,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
      actions: actionIcon != null
          ? [
              IconButton(
                iconSize: 20,
                color: AppColors.dividerLine,
                icon: actionIcon!,
                onPressed: () {},
              )
            ]
          : null,
      title: title != null
          ? Text(
              title!,
              style: customFonts.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(7);
}
