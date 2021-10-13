library universaltoastr;

import 'package:flutter/material.dart';

part 'src/location.dart';
part 'src/toastr_alignment.dart';
part 'src/toastr_overlay_entry.dart';

class UniversalToastr {

  BuildContext? context;
  OverlayEntry? overlay;
  bool canOverlay = true;

  UniversalToastr._();
  
  static final UniversalToastr _instance = UniversalToastr._();

  factory UniversalToastr() => _instance;

  UniversalToastr init(BuildContext context) {
    _instance.context = context;
    return _instance;
  }

  Future<void> show({ required String message, required Duration duration, required bool success, Location location = Location.CENTER }) async {
    assert(duration.inMilliseconds > 1000 && duration.inSeconds <= 60, 
      throw ErrorDescription('Duration must be less than 1 minute and greater than 0 seconds'));

    if(context != null && canOverlay) {
      canOverlay = false;

      final ToastrAlignment toastrAlignment = evalAlignment(location);

      overlay = OverlayEntry(
        builder: (BuildContext context) {
          return ToastrOverlayEntry(toastrAlignment: toastrAlignment, message: message, success: success);
        }
      );
      
      Overlay.of(context!)!.insert(overlay!);

      Future.delayed(duration).then((value) {
        overlay!.remove();
        canOverlay = true;
      });
      
    }
  }

  ToastrAlignment evalAlignment(Location location) {
    switch(location) {
      case Location.BOTTOM: {
        return ToastrAlignment(Offset(0.0, 0.0), Offset(0.0, -1.0), Alignment.bottomCenter);
      }
      case Location.TOP: {
        return ToastrAlignment(Offset(0.0, 0.0), Offset(0.0, 1.0), Alignment.topCenter);
      }
      case Location.CENTER: {
        return ToastrAlignment(Offset(0.0, 0.0), Offset(0.0, 0.0), Alignment.center);
      }
    }
  }
}