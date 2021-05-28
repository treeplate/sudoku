import 'package:flutter/painting.dart';

List<List<bool>> displays = [
  // 0
  [
    true,
    true,
    true,
    false,
    true,
    true,
    true,
  ],
  //1
  [
    false,
    false,
    true,
    false,
    false,
    true,
    false,
  ],
  //2
  [
    true,
    false,
    true,
    true,
    true,
    false,
    true,
  ],
  //3
  [
    true,
    false,
    true,
    true,
    false,
    true,
    true,
  ],
  //4
  [
    false,
    true,
    true,
    true,
    false,
    true,
    false,
  ],
  // 5
  [
    true,
    true,
    false,
    true,
    false,
    true,
    true,
  ],
  // 6
  [
    true,
    true,
    false,
    true,
    true,
    true,
    true,
  ],
  //7
  [
    true,
    false,
    true,
    false,
    false,
    true,
    false,
  ],
  // 8
  [
    true,
    true,
    true,
    true,
    true,
    true,
    true,
  ],
  //9
  [
    true,
    true,
    true,
    true,
    false,
    true,
    true,
  ],
  //nothing(10)
  [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ],
];
void drawHorizontalSegment(
    Canvas canvas, double startX, double startY, double width) {
  canvas.drawLine(
    Offset(startX, startY),
    Offset(startX + width, startY),
    Paint()..strokeWidth = 5,
  );
}

void drawVerticalSegment(
    Canvas canvas, double startX, double startY, double height) {
  canvas.drawLine(
    Offset(startX, startY),
    Offset(startX, startY + height),
    Paint()..strokeWidth = 5,
  );
}

void drawNumber(Canvas canvas, double segmentX, double originY, double width,
    double height, int? number) {
  drawDisplay(canvas, segmentX, originY, width, height, displays[number ?? 10].toList());
}

void drawDisplay(Canvas canvas, double segmentX, double originY, double width,
    double height, List<bool> display) {
  if (display.first) drawHorizontalSegment(canvas, segmentX, originY, width);
  display.removeAt(0);
  if (display.first) drawVerticalSegment(canvas, segmentX, originY, height / 2);
  display.removeAt(0);
  if (display.first)
    drawVerticalSegment(canvas, segmentX + width, originY, height / 2);
  display.removeAt(0);
  if (display.first)
    drawHorizontalSegment(canvas, segmentX, height / 2 + originY, width);
  display.removeAt(0);
  if (display.first)
    drawVerticalSegment(canvas, segmentX, height / 2 + originY, height / 2);
  display.removeAt(0);
  if (display.first)
    drawVerticalSegment(
        canvas, segmentX + width, height / 2 + originY, height / 2);
  display.removeAt(0);
  if (display.first)
    drawHorizontalSegment(canvas, segmentX, height + originY, width);
  display.removeAt(0);
}
