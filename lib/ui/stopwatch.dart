import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stopwatch_flutter/ui/reset_button.dart';
import 'package:stopwatch_flutter/ui/start_stop_button.dart';
import 'package:stopwatch_flutter/ui/stopwatch_renderer.dart';

class Stopwatch extends StatefulWidget {
  @override
  _StopwatchState createState() => _StopwatchState();
}

class _StopwatchState extends State<Stopwatch>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  Duration _previousElapsed = Duration.zero;
  Duration _currentlyElapsed = Duration.zero;
  Duration get _elapsed => _previousElapsed + _currentlyElapsed;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();

    _ticker = this.createTicker((elapsed) {
      setState(() {
        _currentlyElapsed = elapsed;
      });
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _toggleRunning() {
    setState(() {
      _isRunning = !_isRunning;

      if (_isRunning) {
        _ticker.start();
      } else {
        _ticker.stop();
        _previousElapsed += _currentlyElapsed;
        _currentlyElapsed = Duration.zero;
      }
    });
  }

  void _reset() {
    _ticker.stop();

    setState(() {
      _isRunning = false;
      _previousElapsed = Duration.zero;
      _currentlyElapsed = Duration.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final radius = constraints.maxWidth / 2;

        return Stack(
          children: [
            SopwatchRenderer(
              elapsed: _elapsed,
              radius: radius,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: SizedBox(
                height: 80,
                width: 80,
                child: ResetButton(onPressed: _reset),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                height: 80,
                width: 80,
                child: StartStopButton(
                  onPressed: _toggleRunning,
                  isRunning: _isRunning,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
