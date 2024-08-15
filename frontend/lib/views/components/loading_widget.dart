import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Scaffold(
        backgroundColor: scheme.surfaceDim,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/images/icons/loading.svg",
                colorFilter: ColorFilter.mode(scheme.primary, BlendMode.srcIn),
              ),
              const SizedBox(
                height: 24,
              ),
              Text(
                "ChessKnock",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: scheme.primary,
                  fontSize: 50,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w600,
                  height: 1.0
                ),
              )
            ],
          )
        ),
      ),
    );
  }

}