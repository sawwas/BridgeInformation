import 'package:flutter/material.dart';

/// 作者：SanDaoHai
/// 日期：2024/07/03
/// 描述：自訂分割滑塊拇指形狀
class CustomDivisionSliderThumbShape extends SliderComponentShape {
  final bool showValueIndicator;
  final String pre, unit;

  CustomDivisionSliderThumbShape(
      {this.showValueIndicator = false, this.pre = "", this.unit = ""});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size.fromRadius(7);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    if (showValueIndicator) {
      _drawWithBorderAndText(context.canvas, Paint(), center,
          labelPainter.plainText, pre, unit, parentBox);
    }

    final Canvas canvas = context.canvas;
    final Paint rectPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final Rect rect = Rect.fromCenter(center: center, width: 6, height: 28);
    const Radius radius = Radius.circular(3);
    final RRect roundedRect = RRect.fromRectAndRadius(rect, radius);
    // 設定陰影
    // const Color shadowColor = Color.fromRGBO(0, 0, 0, 0.56);
    Color shadowColor = Colors.black.withOpacity(0.5);

    const double elevation = 4.0;

    canvas.drawShadow(
        Path()..addRRect(roundedRect), shadowColor, elevation, true);

    canvas.drawRRect(roundedRect, rectPaint);

    // final Paint outerCirclePaint = Paint()
    //   ..strokeWidth = 2
    //   // ..color = GTColorsV3.icon9.color
    //   ..color = Colors.blue
    //   ..style = PaintingStyle.stroke;
    //
    // final Paint innerCirclePaint = Paint()
    //   // ..color = GTColorsV3.icon8.color
    //   ..color = Colors.orange
    //   ..style = PaintingStyle.fill;
    //
    // // Outer circle (white)4
    // canvas.drawCircle(center, 6.5, outerCirclePaint);
    // // Inner circle (black)
    // canvas.drawCircle(center, 5, innerCirclePaint);
  }
}

class CopyCustomSliderTracksThumbShape extends SliderTrackShape
    with BaseSliderTrackShape {
  final double max;
  final double min;

  const CopyCustomSliderTracksThumbShape(
      {required this.max, required this.min});

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool? isEnabled,
    bool? isDiscrete,
    required TextDirection textDirection,
  }) {
    if (sliderTheme.trackHeight! <= 0) {
      return;
    }

    final ColorTween activeTrackColorTween = ColorTween(
        begin: sliderTheme.disabledActiveTrackColor,
        end: sliderTheme.activeTrackColor);
    final ColorTween inactiveTrackColorTween = ColorTween(
        begin: sliderTheme.disabledInactiveTrackColor,
        end: sliderTheme.inactiveTrackColor);
    final Paint activePaint = Paint()
      ..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final Paint inactivePaint = Paint()
      ..color = inactiveTrackColorTween.evaluate(enableAnimation)!;
    final Paint leftTrackPaint;
    final Paint rightTrackPaint;
    switch (textDirection) {
      case TextDirection.ltr:
        leftTrackPaint = activePaint;
        rightTrackPaint = inactivePaint;
        break;
      case TextDirection.rtl:
        leftTrackPaint = inactivePaint;
        rightTrackPaint = activePaint;
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled ?? false,
      isDiscrete: isDiscrete ?? false,
    );

    final Rect leftTrackSegment = Rect.fromLTRB(
        trackRect.left, trackRect.top, thumbCenter.dx, trackRect.bottom);
    if (!leftTrackSegment.isEmpty) {
      context.canvas.drawRect(leftTrackSegment, leftTrackPaint);
    }
    final Rect rightTrackSegment = Rect.fromLTRB(
        thumbCenter.dx, trackRect.top, trackRect.right, trackRect.bottom);
    if (!rightTrackSegment.isEmpty) {
      context.canvas.drawRect(rightTrackSegment, rightTrackPaint);
    }
    final startPaint = Paint();
    startPaint.color = Colors.red;
    // _drawWithBorderAndText(context.canvas, Paint(), trackRect.centerLeft, '${min.round()}%', '', '');
    // _drawWithBorderAndText(context.canvas, Paint(), trackRect.centerRight, "${max.round()}%", '', '');
  }
}

double offsetY = 26;

void _drawWithBorderAndText(Canvas canvas, Paint paint, Offset offset,
    String text, String pre, String unit, RenderBox parentBox) {
  TextSpan span = new TextSpan(
      style: new TextStyle(
          fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
      text: pre);
  TextPainter tp = new TextPainter(
      text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
  tp.layout();

  /// 調整氣泡偏移以避免溢出
  double bubbleWidth = tp.width + 14;
  double bubbleHeight = tp.height + 6;
  double horizontalOffset = offset.dx - bubbleWidth / 2;
  double verticalOffset = offset.dy - bubbleHeight - offsetY;

  /// 氣泡漸變
  const bubbleGradient = LinearGradient(
    colors: [Color(0xFF16D9D9), Color(0xFF1979FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  final paint = Paint()
    ..shader = bubbleGradient.createShader(Rect.fromLTWH(
        horizontalOffset, verticalOffset, bubbleWidth, bubbleHeight));
  // ..color = Colors.blueAccent // Adjust the color of the bubble
  // ..style = PaintingStyle.fill;

  /// 防止氣泡從側面溢出
  horizontalOffset =
      horizontalOffset.clamp(0.0, parentBox.size.width - bubbleWidth);

  // Draw the bubble
  RRect bubble = RRect.fromRectAndCorners(
    Rect.fromLTWH(horizontalOffset, verticalOffset, bubbleWidth, bubbleHeight),
    topLeft: const Radius.circular(5),
    topRight: const Radius.circular(5),
    bottomLeft: const Radius.circular(5),
    bottomRight: const Radius.circular(5),
  );
  canvas.drawRRect(bubble, paint);

  // Draw the text bubble
  tp.paint(
      canvas,
      Offset(horizontalOffset + (bubbleWidth - tp.width) / 2,
          verticalOffset + (bubbleHeight - tp.height) / 2));

  // Draw arrow
  final arrowPath = Path();
  arrowPath.moveTo(offset.dx, verticalOffset + (bubbleHeight) + 7);
  arrowPath.relativeLineTo(8, -8);
  arrowPath.relativeLineTo(-16, 0);
  arrowPath.close();
  canvas.drawPath(arrowPath, paint);
}

class CustomTickMarkShape extends SliderTickMarkShape {
  final bool isEnableDivision;

  CustomTickMarkShape({this.isEnableDivision = false});

  @override
  Size getPreferredSize(
      {required SliderThemeData sliderTheme, required bool isEnabled}) {
    return const Size(2.0, 10.0);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required Animation<double> enableAnimation,
      required Offset thumbCenter,
      required bool isEnabled,
      required TextDirection textDirection}) {}
}

class GradientRectSliderTrackShape extends SliderTrackShape {
  final bool isEnableDivision;

  GradientRectSliderTrackShape({this.isEnableDivision = false});

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool? isEnabled,
    bool? isDiscrete,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 4.0;
    final double trackLeft = offset.dx + 16;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width - 32;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool? isEnabled,
    bool? isDiscrete,
    required TextDirection textDirection,
  }) {
    // 確定軌跡的繪製矩形
    final Rect trackRectStick = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled ?? false,
      isDiscrete: isDiscrete ?? false,
    );
    // // Draw the track
    // context.canvas.drawRect(trackRect, trackPaint);

    final Paint stickTrackPaint = Paint()
      ..color = Color(0xFF666666).withOpacity(0.05)
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    // ..color = sliderTheme.inactiveTrackColor ?? Colors.grey
    // ..style = PaintingStyle.fill;

    final Radius radiusStick = Radius.circular(16);

    final RRect roundedStickTrackRect =
        RRect.fromRectAndRadius(trackRectStick, radiusStick);

    context.canvas.drawRRect(roundedStickTrackRect, stickTrackPaint);

    final Rect originalTrackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled ?? false,
      isDiscrete: isDiscrete ?? false,
    );

    // 定義新的高度值
    double newHeight = originalTrackRect.height * 0.9;

// 建立一個新的軌道矩形，具有減少的高度
    final Rect trackRect = Rect.fromLTWH(
      originalTrackRect.left + 2,
      originalTrackRect.top + (originalTrackRect.height - newHeight) / 2,
      // 調整頂部位置以垂直居中
      originalTrackRect.width - 4,
      newHeight,
    );

    /// 定義漸變過渡
    var gradient = const LinearGradient(
      colors: [
        Color(0xFF30BF87),
        Color(0xFFE5D546),
        Color(0xFFFFDD29),
        Color(0xFFF8D144),
        Color(0xFFF2495E),
      ],
      stops: [0.2, 0.35, 0.5, 0.6, 1.0],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    // // Draw the track
    // context.canvas.drawRect(trackRect, trackPaint);

    final Paint inactiveTrackPaint = Paint()
      ..shader = gradient.createShader(trackRect)
      ..style = PaintingStyle.fill;
    // ..color = sliderTheme.inactiveTrackColor ?? Colors.grey
    // ..style = PaintingStyle.fill;

    final Paint activeTrackPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          sliderTheme.activeTrackColor ?? Colors.blue,
          sliderTheme.activeTrackColor ?? Colors.green
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromPoints(
        trackRect.topLeft,
        trackRect.bottomRight,
      ))
      ..style = PaintingStyle.fill;

    // 定義圓角半徑
    final Radius radius = Radius.circular(16);

    // 建立帶有圓角的矩形
    final RRect roundedTrackRect = RRect.fromRectAndRadius(trackRect, radius);

    context.canvas.drawRRect(roundedTrackRect, inactiveTrackPaint);

    // 繪製已啟動的軌跡
    // context.canvas.drawRect(
    //   Rect.fromLTWH(
    //     trackRect.left,
    //     trackRect.top,
    //     thumbCenter.dx - trackRect.left,
    //     trackRect.height,
    //   ),
    //   activeTrackPaint,
    // );

    final Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.0;

    ///跳躍division設定時生效：較小的值將刻度線拉向中心
    if (isEnableDivision) {
      const double adjustmentFactor = 0.79;
      final double adjustedWidth = roundedTrackRect.width * adjustmentFactor;
      final double nonAdjustedWidth = roundedTrackRect.width - adjustedWidth;
      final Offset adjustedCenter = Offset(
        roundedTrackRect.left + nonAdjustedWidth / 2, // 修改起始位置使第一個分割線與邊緣對齊
        roundedTrackRect.center.dy,
      );

      const int divisions = 3; // 分割數為3，即需要繪製的分割線數為3+1=4
      for (int i = 0; i <= divisions; i++) {
        // 包括兩端的分割線，所以循環到等於divisions
        final Offset result = adjustedCenter +
            Offset(adjustedWidth / divisions * i,
                0); // 每段的距離為adjustedWidth/divisions
        context.canvas.drawLine(
            result - const Offset(0, 4), result + const Offset(0, 4), paint);
      }
    }
  }

// final Rect trackRect = offset & Size(parentBox.size.width, sliderTheme.trackHeight ?? 4);
}
