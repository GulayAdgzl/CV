import 'package:cv/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget svgLoader(String image, {width = 20.0, height = 20.0}) {
  return SvgPicture.asset(
    image,
    height: height,
    width: width,
    color: AppColors.tiffanyBlue,
  );
}
