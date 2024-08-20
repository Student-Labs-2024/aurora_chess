import "package:flutter/material.dart";

class RoundedButton extends StatelessWidget {
  final String label;
  final Function() onPressed;

  const RoundedButton(this.label, {super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: FloatingActionButton(
        backgroundColor: const Color(0x20000000),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: "Roboto",
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
