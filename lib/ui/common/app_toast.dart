import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/colors.dart';
import '../../core/dimens.dart';
import '../../core/styles.dart';

class AppToast extends StatelessWidget {
  final String message;

  const AppToast({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: Dimens.spaceLarge),
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
            child: Container(
                decoration: const ShapeDecoration(
                    shape: StadiumBorder(), color: AppColors.primaryBlue1),
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.spaceLarge,
                    vertical: Dimens.spaceXMedium),
                child: Text(message,
                    style: AppFontTextStyles.textStyleBold()
                        .copyWith(color: AppColors.white),
                    overflow: TextOverflow.visible))));
  }
}
