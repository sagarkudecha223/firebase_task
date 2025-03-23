import 'package:firebase_task/ui/common/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_architecture_plugin/imports/extension_imports.dart';
import 'package:gap/gap.dart';

import '../../core/colors.dart';
import '../../core/dimens.dart';
import '../../core/styles.dart';
import 'svg_icon.dart';

class AppAlertDialog extends StatelessWidget {
  final String? message;
  final String? title;
  final String? positiveButtonTitle;
  final String? negativeButtonTitle;
  final String? image;
  final Function()? onPositiveTap;
  final Function()? onNegativeTap;
  final bool isWarning;

  const AppAlertDialog(
      {this.message,
      this.positiveButtonTitle,
      this.negativeButtonTitle,
      this.onPositiveTap,
      this.onNegativeTap,
      this.image,
      super.key,
      this.title,
      this.isWarning = false});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusSmall)),
      child: Padding(
        padding: const EdgeInsets.all(Dimens.spaceXMedium),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (image.isNotBlank)
              AppSvgIcon(
                image!,
                height: Dimens.button2xLarge,
              ),
            const Gap(Dimens.spaceMedium),
            Text(title ?? '',
                textAlign: TextAlign.center,
                style: AppFontTextStyles.textStyleBold()
                    .copyWith(color: AppColors.regularTextColor),
                overflow: TextOverflow.visible),
            if (message.isNotBlank)
              Text(message!,
                  textAlign: TextAlign.start,
                  style: AppFontTextStyles.textStyleBold().copyWith(
                      color: AppColors.primaryBlue1,
                      fontSize: Dimens.fontSizeFourteen),
                  overflow: TextOverflow.visible),
            const Gap(Dimens.spaceMedium),
            Row(
              children: [
                if (negativeButtonTitle.isNotBlank)
                  Expanded(
                      child: _CommonButton(
                          title: negativeButtonTitle!,
                          onTap: onNegativeTap ?? () => context.pop())),
                if (negativeButtonTitle.isNotBlank)
                  const Gap(Dimens.spaceMedium),
                Expanded(
                    child: _CommonButton(
                        title: positiveButtonTitle!,
                        onTap: () {
                          context.pop();
                          onPositiveTap?.call();
                        },
                        isWarning: isWarning)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _CommonButton extends StatelessWidget {
  final String title;
  final Function() onTap;
  final bool isWarning;

  const _CommonButton(
      {required this.title, required this.onTap, this.isWarning = false});

  @override
  Widget build(BuildContext context) {
    return AppElevatedButton(
        title: title,
        onTap: onTap,
        hasBorder: true,
        borderColor: isWarning ? AppColors.red : AppColors.primaryBlue1,
        backgroundColor: isWarning ? AppColors.red : AppColors.white);
  }
}
