part of universaltoastr;

/// A Class used to specify the alignment options for a Toastr in the Overlay Entry Widget
class ToastrAlignment {
  
  ToastrAlignment({ required this.entryOffset, this.endOffset, required this.alignment });

  final EntryOffset? entryOffset;
  final EndOffset? endOffset;
  final Alignment? alignment;
}

class EntryOffset {

  EntryOffset({ required this.begin, required this.end });

  final Offset begin;
  final Offset end;

}

class EndOffset {

  EndOffset({ required this.begin, required this.end });

  final Offset begin;
  final Offset end;
}