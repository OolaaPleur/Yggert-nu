import 'package:flutter/material.dart';

/// Defines Custom Paint child, on image is black cloud from Google material icons.
class CloudCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path_1 = Path()
      ..moveTo(size.width * 0.8062500, size.height * 0.4183333)
      ..cubicTo(
        size.width * 0.7779167,
        size.height * 0.2745833,
        size.width * 0.6933333,
        size.height * 0.1666667,
        size.width * 0.5000000,
        size.height * 0.1666667,
      )
      ..cubicTo(
        size.width * 0.3066667,
        size.height * 0.1666667,
        size.width * 0.2750000,
        size.height * 0.2350000,
        size.width * 0.2229167,
        size.height * 0.3350000,
      )
      ..cubicTo(
        size.width * 0.09750000,
        size.height * 0.3483333,
        size.width * 7.401487e-17,
        size.height * 0.4545833,
        size.width * 7.401487e-17,
        size.height * 0.5833333,
      )
      ..cubicTo(
        size.width * 7.401487e-17,
        size.height * 0.7212500,
        size.width * 0.1120833,
        size.height * 0.8333333,
        size.width * 0.2500000,
        size.height * 0.8333333,
      )
      ..lineTo(
        size.width * 0.7916667,
        size.height * 0.8333333,
      )
      ..cubicTo(
        size.width * 0.9066667,
        size.height * 0.8333333,
        size.width,
        size.height * 0.7400000,
        size.width,
        size.height * 0.6250000,
      )
      ..cubicTo(
        size.width,
        size.height * 0.5150000,
        size.width * 0.9145833,
        size.height * 0.4258333,
        size.width * 0.8062500,
        size.height * 0.4183333,
      )
      ..close();

    final paint1Fill = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xff000000).withOpacity(1);
    canvas.drawPath(path_1, paint1Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

/// Defines Custom Paint child, on image is white arrow from Google material icons.
class ArrowCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path0CenterX = (size.width * 12.10000 + size.width * 4.400000) / 2;
    final path0CenterY = (size.height * 16.75000 + size.height * 8.583333) / 2;

    final translateX = size.width / 2 - path0CenterX;
    final translateY = size.height / 2 - path0CenterY;

    const offsetY = 2.9;

    canvas
      ..save()
      ..translate(translateX, translateY + offsetY);

    /// Creation of rectangle.
    final path_0 = Path()
      ..moveTo(size.width * 4.400000, size.height * 8.583333)
      ..lineTo(size.width * 12.10000, size.height * 8.583333)
      ..lineTo(size.width * 12.10000, size.height * 16.75000)
      ..lineTo(size.width * 4.400000, size.height * 16.75000)
      ..close();

    final paint0Fill = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xffFFFFFF).withOpacity(1);
    canvas
      ..drawPath(path_0, paint0Fill)
      ..restore()

      /// Creation of triangle.
      ..save()
      ..translate(translateX, translateY + offsetY);

    final path_1 = Path()
      ..moveTo(size.width * 8.250000, 0)
      ..lineTo(size.width * 15.39470, size.height * 8.687500)
      ..lineTo(size.width * 1.105290, size.height * 8.687500)
      ..lineTo(size.width * 8.250000, 0)
      ..close();

    final paint1Fill = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xffFFFFFF).withOpacity(1);
    canvas
      ..drawPath(path_1, paint1Fill)
      ..restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
