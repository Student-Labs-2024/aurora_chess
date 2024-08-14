import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";

class PointsIndicator extends StatelessWidget {
  const PointsIndicator({
    super.key, 
    required this.count, 
    required this.currentIndex
  });
  
  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    return Row(
      children: List.generate(count, (index) {
        return Row(
          children: [
            SvgPicture.asset(
              "assets/images/icons/point_light.svg",
              width: 10,
              height: 10,
              colorFilter: ColorFilter.mode(
                  index == currentIndex
                      ? scheme.surfaceContainer
                      : scheme.inverseSurface,
                  BlendMode.srcIn),
            ),
            SizedBox(width: index < count - 1 ? 5 : 0,)
          ],
        );
      }
      )
    );
  }

}