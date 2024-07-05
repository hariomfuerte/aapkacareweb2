import 'package:aapkacare/values/values.dart';
import 'package:flutter/material.dart';


class Screen {
  final BuildContext context;
  Screen(this.context);

  Size get size => MediaQuery.of(context).size;
  double get width => size.width;
  double get height => size.height;
  double get customWidth => width / macbookWidth;
  double get customHeight => height / macbookHeight;
  bool get isMobile => customWidth <= 0.64;
  bool get isTablet => !isMobile && width < 900;
  bool get isDesktop => !isMobile && !isTablet;
  double get tableWidthFactor {
    if (width > 400 && !isTablet) {
      return 2.25;
    } else if (isTablet) {
      return 1.75;
    }
    return 2.5;
  }
}
