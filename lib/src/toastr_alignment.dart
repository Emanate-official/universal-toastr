part of universaltoastr;

/// A Class used to specify the alignment options for a Toastr in the Overlay Entry Widget
class ToastrAlignment {
  
  ToastrAlignment(this.beginOffset, this.endOffset, this.alignment);

  final Offset beginOffset;
  final Offset endOffset;
  final Alignment alignment;
}