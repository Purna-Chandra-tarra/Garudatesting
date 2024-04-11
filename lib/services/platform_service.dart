import 'dart:io';

import 'package:flutter/foundation.dart';

class PlatformService {
  // whether or not the current device is mobile
  static bool isMobile() {
    if (kIsWeb) {
      return false;
    }

    return Platform.isAndroid || Platform.isIOS;
  }
}
