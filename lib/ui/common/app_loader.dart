import 'package:firebase_task/core/colors.dart';
import 'package:flutter/material.dart';

import '../../../core/dimens.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({
    super.key,
    this.strokeWidth = Dimens.borderWidthXMedium,
    this.backgroundColor = AppColors.primaryBlue1,
  });

  final double strokeWidth;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(
            backgroundColor ?? AppColors.primaryBlue1),
        backgroundColor: backgroundColor?.withOpacity(0.2),
      ),
    );
  }
}
