import 'package:cv/utils/AppColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget svgLoader(String image, {width = 20.0, height = 20.0}) {
  return SvgPicture.asset(
    image,
    height: height,
    width: width,
    color: AppColors.iconTint,
  );
}
