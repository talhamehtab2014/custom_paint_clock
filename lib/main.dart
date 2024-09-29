import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clock',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Clock'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int seconds = DateTime.now().second;
  int hours = DateTime.now().hour;
  int mins = DateTime.now().minute;
  late AnimationController _controller, _controller2;
  late Animation<double> _animation, _animation2;
  bool isRecangularShape = false;

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _incrementCounter();
    });

    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _controller2 = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    // Define the animation range and curve
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuart),
    )..addListener(() {
        // Rebuild the widget when the animation updates
        setState(() {});
      });

    _animation2 = Tween<double>(begin: 0.0, end: 1.0).animate(_controller2)
      ..addListener(() {
        // Rebuild the widget when the animation updates
        setState(() {});
      });

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuart),
    )
      ..addListener(() {
        // Rebuild the widget when the animation updates
        setState(() {});
      })
      ..addStatusListener((status) {
        switch (status) {
          case AnimationStatus.completed:
            _controller2.forward();
            break;
          default:
        }
      });

    _controller.forward();

    super.initState();
  }

  void _incrementCounter() {
    setState(() {
      seconds = DateTime.now().second;
      hours = DateTime.now().hour;
      mins = DateTime.now().minute;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomPaint(
            size: const Size(160, 160),
            painter: BackgroundPainter(seconds, hours, mins, _animation.value,
                isRecangularShape, context),
            child: const SizedBox(
              width: 160,
              height: 360,
            ),
          ),
          OutlinedButton(
              onPressed: () {
                _controller.reset();
                _controller2.reset();

                setState(() {
                  isRecangularShape = true;
                  _controller.forward();
                });
              },
              child: Text("Rectangular Shape")),
          OutlinedButton(
              onPressed: () {
                _controller.reset();
                _controller2.reset();

                setState(() {
                  isRecangularShape = false;
                  _controller.forward();
                });
              },
              child: Text("Circular Shape"))
        ],
      )),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  int seconds;
  int min;
  int hour;
  double progress;
  bool isRectangularShape;
  BuildContext context;

  BackgroundPainter(this.seconds, this.hour, this.min, this.progress,
      this.isRectangularShape, this.context);

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    var paint = Paint()
      ..color = Colors.deepPurple
      ..style = ui.PaintingStyle.stroke
      ..strokeWidth = 10;

    if (isRectangularShape) {
      Rect rect = Rect.fromLTWH(center.dx - (160 * progress),
          center.dy - (160 * progress), 320 * progress, 320 * progress);

      canvas.drawRect(rect, paint..style = ui.PaintingStyle.stroke);
      canvas.drawRect(rect, paint..style = ui.PaintingStyle.fill);
    }

    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), progress * 150.0, paint);

    double hourAngle = ((hour % 12 + min / 60) * 30 * pi / 180) - 190;
    double minuteAngle = ((min + seconds / 60) * 6 * pi / 180) - 190;
    double secondAngle = ((seconds) * 6 * pi / 180) - 190;

    final Paint paint1 = Paint()
      ..color = Theme.of(context).colorScheme.inversePrimary
      ..strokeWidth = 5
      ..style = PaintingStyle.fill;

    final Offset center1 = Offset(size.width / 2, size.height / 2);
    final double radius1 = progress * 150;

    // Draw an expanding circle
    canvas.drawCircle(center1, radius1, paint1);

    if (progress > 0.2) {
      drawHourMarks(canvas, center, progress * 150);
    }

    // Draw hour hand
    drawHand(
        canvas, center, (progress * (150 * 0.5)), hourAngle, Colors.black, 8);

    // Draw minute hand
    drawHand(
        canvas, center, (progress * (150 * 0.7)), minuteAngle, Colors.black, 6);

    // Draw second hand
    drawHand(
        canvas, center, (progress * (150 * 0.9)), secondAngle, Colors.red, 3);

    final Paint paint2 = Paint()
      ..color = Colors.black
      ..strokeWidth = 5
      ..style = PaintingStyle.fill;

    final double radius2 = progress * 10;

    canvas.drawCircle(center, radius2, paint2);
  }

  void drawHand(Canvas canvas, Offset center, double length, double angle,
      Color color, double strokeWidth) {
    final Paint handPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final Offset handEnd = Offset(
      center.dx + length * cos(angle),
      center.dy + length * sin(angle),
    );

    canvas.drawLine(center, handEnd, handPaint);
  }

  void drawText(Canvas canvas, Offset position, String text, double progress) {
    final TextSpan span = TextSpan(
      style: TextStyle(
        color: Colors.black.withOpacity(progress),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      text: text,
    );

    final TextPainter textPainter = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: ui.TextDirection.ltr,
    );

    textPainter.layout();

    // Adjust position so that the text is centered on the calculated point
    Offset textOffset = Offset(
      position.dx - textPainter.width / 2,
      position.dy - textPainter.height / 2,
    );

    textPainter.paint(canvas, textOffset);
  }

  void drawHourMarks(Canvas canvas, Offset center, double radius) {
    final double numberRadius =
        radius - 30; // Distance from the center for the numbers
    for (int i = 1; i <= 12; i++) {
      // Angle for each number (360° / 12 = 30° for each hour)
      double angle = (((i * 30) * pi / 180) - 190);

      // Calculate the position for each number
      double x = center.dx + numberRadius * cos(angle);
      double y = center.dy + numberRadius * sin(angle);

      // Draw the hour number
      drawText(canvas, Offset(x, y), i.toString(), progress);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
