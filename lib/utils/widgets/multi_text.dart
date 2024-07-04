import 'package:flutter/cupertino.dart';

///Tip:多行文字組件
class MultiTextWidget extends StatefulWidget {
  double? width;
  String? title;
  TextStyle? style;
  int? maxLines;
  TextAlign? textAlign;
  int maxLength;

  MultiTextWidget(
      {Key? key,
      required this.width,
      required this.title,
      this.maxLength = 200,
      required this.style,
      required this.maxLines,
      this.textAlign})
      : super(key: key);

  @override
  State<MultiTextWidget> createState() => _MultiTextWidgetState();
}

class _MultiTextWidgetState extends State<MultiTextWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.width == -1
        ? Wrap(
            children: [
              Text(
                widget.title != null
                    ? truncateText(
                        text: widget.title ?? "", maxLength: widget.maxLength)
                    : '- -',
                style: widget.style ??
                    const TextStyle(
                      fontSize: 14,
                      color: Color(0xff2b2b2b),
                      letterSpacing: -0.168,
                      fontWeight: FontWeight.w500,
                    ),
                softWrap: false,
                maxLines: widget.maxLines ?? 2,
                overflow: TextOverflow.ellipsis,
                textAlign: widget.textAlign ?? TextAlign.start,
              )
            ],
          )
        : Container(
            width: widget.width ?? 134,
            child: Text(
              widget.title != null
                  ? truncateText(
                      text: widget.title ?? "", maxLength: widget.maxLength)
                  : '- -',
              style: widget.style ??
                  const TextStyle(
                    fontSize: 14,
                    color: Color(0xff2b2b2b),
                    letterSpacing: -0.168,
                    fontWeight: FontWeight.w500,
                  ),
              softWrap: false,
              maxLines: widget.maxLines ?? 2,
              overflow: TextOverflow.ellipsis,
              textAlign: widget.textAlign ?? TextAlign.start,
            ),
          );
  }
}

String truncateText({String text = "", int maxLength = 200}) {
  if (text.length <= maxLength) {
    return text;
  } else {
    return '${text.substring(0, maxLength)}...';
  }
}
