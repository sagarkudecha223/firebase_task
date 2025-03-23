import 'package:flutter/material.dart';

import '../../../core/colors.dart';
import '../../../core/styles.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool hideLeading;
  final bool centerTitle;
  final List<Widget>? actions;
  final TextStyle? titleStyle;
  final Color? backgroundColor;
  final IconThemeData? iconThemeData;

  const CommonAppBar(
      {this.title,
      this.hideLeading = false,
      this.centerTitle = true,
      this.actions,
      this.titleStyle,
      this.backgroundColor,
      this.iconThemeData,
      super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _titleWidget,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? AppColors.white,
      bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            color: AppColors.dividerColor,
            height: 1,
          )),
      iconTheme: iconThemeData ?? const IconThemeData(color: AppColors.regularTextColor),
      leading: hideLeading ? const SizedBox() : null,
      actions: actions,
    );
  }

  Text? get _titleWidget => title == null
      ? null
      : Text(
          title!,
          style: titleStyle ?? AppFontTextStyles.appbarTextStyle(),
        );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
