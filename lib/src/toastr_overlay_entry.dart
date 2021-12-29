part of universaltoastr;

/// The Overlay Entry that is inserted into the App at the Top Layer
/// 
/// Animates a toastr from a given [Location]
class ToastrOverlayEntry extends StatefulWidget {

  final ToastrAlignment toastrAlignment;
  final bool success;
  final String message;
  final Duration duration;
  final Function overlayEntryCallback;
  const ToastrOverlayEntry({ required this.duration, required this.toastrAlignment, required this.message, required this.success, required this.overlayEntryCallback, Key? key }) : super(key: key);

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

    offset = Tween<Offset>(begin: widget.toastrAlignment.entryOffset!.begin, end: widget.toastrAlignment.entryOffset!.end)
              .animate(CurvedAnimation(parent: controller!, curve: Curves.bounceOut));
    
    // only launch callback if the widget hasn't been dismissed
    controller!.forward().then((_) {

      Future.delayed(this.widget.duration).then((value) {

        if(this.mounted) {
          this.widget.overlayEntryCallback();
        }
        
      });

    });
    
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
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
              alignment: widget.toastrAlignment.alignment!,
              child: SlideTransition(
                position: offset!,
                child: GestureDetector(

                  // Dismiss through Tap
                  onTap: () {
                    this.widget.overlayEntryCallback();
                  },

                  // Dismiss through Swipe
                  onVerticalDragUpdate: (DragUpdateDetails dragUpdateDetails) {

                    // Drag Down to Dismiss (From Bottom)
                    if(dragUpdateDetails.delta.dy > 1 && this.widget.toastrAlignment.alignment == Alignment.bottomCenter && this.widget.toastrAlignment.endOffset != null) {
                      setState(() {
                        offset = Tween<Offset>(begin:this.widget.toastrAlignment.endOffset!.begin, end: this.widget.toastrAlignment.endOffset!.end).animate(CurvedAnimation(parent: controller!, curve: Curves.fastOutSlowIn));
                      });
                      controller!.duration = Duration(milliseconds: 400);
                      controller!.reset();
                      controller!.forward().then((_) {
                        this.widget.overlayEntryCallback();
                      });
                      
                    }

                    // Drag Up to Dismiss (From Top)
                    if(dragUpdateDetails.delta.dy < - 1 && this.widget.toastrAlignment.alignment == Alignment.topCenter && this.widget.toastrAlignment.endOffset != null) {
                      setState(() {
                        offset = Tween<Offset>(begin:this.widget.toastrAlignment.endOffset!.begin, end: this.widget.toastrAlignment.endOffset!.end).animate(CurvedAnimation(parent: controller!, curve: Curves.fastOutSlowIn));
                      });
                      controller!.duration = Duration(milliseconds: 400);
                      controller!.reset();
                      controller!.forward().then((_) {
                        this.widget.overlayEntryCallback();
                      });
                      
                    }

                  },
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

                              SizedBox(
                                width: 20
                              ),

                              if(this.widget.success)
                                Icon(
                                  Icons.check_circle_outline_rounded,
                                  color: green,
                                  size: 20,
                                ),

                              if(!this.widget.success)
                                Icon(
                                  Icons.highlight_off_rounded,
                                  color: Colors.red[400],
                                  size: 20,
                                ),

                              SizedBox(
                                width: 20
                              ),

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
                ),
              )
            )
          ],
        )
      ),
    );
  }
}