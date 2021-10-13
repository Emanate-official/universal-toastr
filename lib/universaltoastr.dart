library universaltoastr;

import 'package:flutter/material.dart';

enum Location {
  TOP,
  BOTTOM,
  CENTER,
}

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

class ToastrAlignment {
  
  ToastrAlignment(this.beginOffset, this.endOffset, this.alignment);

  final Offset beginOffset;
  final Offset endOffset;
  final Alignment alignment;
}

class ToastrOverlayEntry extends StatefulWidget {

  final ToastrAlignment toastrAlignment;
  final bool success;
  final String message;
  const ToastrOverlayEntry({ required this.toastrAlignment, required this.message, required this.success, Key? key }) : super(key: key);

  @override
  _ToastrOverlayEntryState createState() => _ToastrOverlayEntryState();
}

class _ToastrOverlayEntryState extends State<ToastrOverlayEntry> with TickerProviderStateMixin{

  AnimationController? controller;
  Animation<Offset>? offset;
  static const Color green = Color(0xFF22FEB9);
  static const Color backgroundColor = Color(0xFF4C5067);
  static const Color textColor = Color(0xFFF5F6FF);
  
  @override
  void initState() {
    super.initState();

    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    offset = Tween<Offset>(begin: widget.toastrAlignment.beginOffset, end: widget.toastrAlignment.endOffset).animate(CurvedAnimation(parent: controller!, curve: Curves.bounceOut));
    controller!.forward();

  }


  @override
  Widget build(BuildContext context) {

    final Size size  = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: size.width,
        height: size.height,
        child: Stack(
          children: <Widget>[
            Align(
              alignment: widget.toastrAlignment.alignment,
              child: SlideTransition(
                position: offset!,
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: backgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    width: size.width * .9,
                    height: size.width * .15,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 20),
                            widget.success ? Icon(
                              Icons.check_circle_outline_rounded,
                              color: green,
                              size: 20,
                            ) :
                            Icon(
                              Icons.highlight_off_rounded,
                              color: Colors.red[400],
                              size: 20,
                            ),
                            SizedBox(width: 20),
                            Text(
                              widget.message,
                              style: TextStyle(
                                fontSize: 15,
                                color: textColor
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  ),
              )
            )
          ],
        )
      ),
    );
  }
}