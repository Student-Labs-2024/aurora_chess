import "package:flutter/material.dart";
import "package:frontend/constants/colors.dart";

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.background,
      body: const Center(
        child: CircularProgressIndicator(
          color: ColorsConst.primaryColor200,
        ),
      ),
    );
  }

}