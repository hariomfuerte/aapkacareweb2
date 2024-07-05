import 'package:aapkacare/values/screen.dart';
import 'package:aapkacare/values/values.dart';
import 'package:flutter/material.dart';

class ImageLinks extends StatelessWidget {
  const ImageLinks({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Screen s = Screen(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
            height: 170 * s.customWidth,
            width: 100 * s.customWidth,
            child: Image.asset(ImagePath.googlePlay)),
      ],
    );
  }
}
