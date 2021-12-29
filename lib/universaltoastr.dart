library universaltoastr;

import 'package:flutter/material.dart';

part 'src/location.dart';
part 'src/toastr_alignment.dart';
part 'src/toastr_overlay_entry.dart';

typedef DismissCallback = void Function(OverlayEntry overlay);
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
    assert(duration.inMilliseconds >= 1000 && duration.inSeconds <= 60, 
      throw ErrorDescription('Duration must be less than 1 minute and greater than 0 seconds'));

    if(context != null && canOverlay) {
      canOverlay = false;

      final ToastrAlignment toastrAlignment = evalAlignment(location);

      overlay = OverlayEntry(
        builder: (BuildContext context) {
          return ToastrOverlayEntry(duration: duration, toastrAlignment: toastrAlignment, message: message, success: success, overlayEntryCallback: () {
            overlay?.remove();
            canOverlay = true;
            //overlay!.remove();
          });
        }
      );
      
      Overlay.of(context!)!.insert(overlay!);

    }
  }

  void closeOverlay() {
    if(this.overlay!.mounted) {
      this.overlay!.remove();
      canOverlay = true;
    }
  }

  Future<void> custom({ required Widget customToastr, required Duration duration}) async {
    assert(duration.inMilliseconds > 1000 && duration.inSeconds < 60,
      throw ErrorDescription('Duration must be less that 1 minute but greater that 1 second'));

    if(context != null && canOverlay) {

      canOverlay = false;

      overlay = OverlayEntry(
        builder: (BuildContext context) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              height: double.infinity,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  customToastr
                ],
              ),
            )
          );
        }
      );

      Overlay.of(context!)!.insert(overlay!);

    }
  }

  ToastrAlignment evalAlignment(Location location) {
    switch(location) {
      case Location.BOTTOM: {

        final EntryOffset entryOffset = EntryOffset(begin: Offset(0.0, 0.0), end: Offset(0.0, -1.0));
        final EndOffset endOffset = EndOffset(begin: Offset(0.0, -1.0), end: Offset(0.0, 1.0));

        return ToastrAlignment(entryOffset: entryOffset, endOffset: endOffset, alignment: Alignment.bottomCenter);
      }
      case Location.TOP: {

        final EntryOffset entryOffset = EntryOffset(begin: Offset(0.0, 0.0), end: Offset(0.0, 1.0));
        final EndOffset endOffset = EndOffset(begin: Offset(0.0, 1.0), end: Offset(0.0, -1.0));
        
        return ToastrAlignment(entryOffset: entryOffset, endOffset: endOffset, alignment: Alignment.topCenter);
      }
      case Location.CENTER: {

        final EntryOffset entryOffset = EntryOffset(begin: Offset(0.0, 0.0), end: Offset(0.0, 0.0));

        return ToastrAlignment(entryOffset: entryOffset, alignment: Alignment.center);
      }
    }
  }
}