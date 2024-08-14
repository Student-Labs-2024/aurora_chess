import "package:flutter/material.dart";
import "../../../../exports.dart";

class TimerWidget extends StatelessWidget {
  final Duration timeLeft;
  final bool isFilled;

  const TimerWidget({super.key, required this.timeLeft, required this.isFilled});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: timeLeft.inHours > 0 ? 100 : 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: isFilled ? Theme.of(context).colorScheme.secondary : Colors.transparent,
      ),
      child: Center(
        child: TextRegular(_durationToString(timeLeft)),
      ),
    );
  }

  String _durationToString(Duration duration) {
    if (duration.inHours > 0) {
      String hours = duration.inHours.toString();
      String minutes =
          duration.inMinutes.remainder(60).toString().padLeft(2, "0");
      String seconds =
          duration.inSeconds.remainder(60).toString().padLeft(2, "0");
      return "$hours:$minutes:$seconds";
    } else if (duration.inMinutes > 0) {
      String minutes = duration.inMinutes.toString();
      String seconds =
          duration.inSeconds.remainder(60).toString().padLeft(2, "0");
      return "$minutes:$seconds";
    } else {
      String seconds = duration.inSeconds.toString();
      return seconds;
    }
  }
}
