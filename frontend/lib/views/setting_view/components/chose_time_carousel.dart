import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:wheel_chooser/wheel_chooser.dart";

import "../../../exports.dart";

class ChoseTimeCarousel extends StatefulWidget {
  const ChoseTimeCarousel({
    super.key,
    required this.values,
    required this.type,
    required this.header,
    required this.startValue,
    this.onChanged,
  });

  final List<dynamic> values;
  final String type;
  final String header;
  final dynamic startValue;
  final void Function(dynamic)? onChanged;

  @override
  State<ChoseTimeCarousel> createState() => _ChoseTimeCarouselState();
}

class _ChoseTimeCarouselState extends State<ChoseTimeCarousel> {
  late FixedExtentScrollController scrollController;

  @override
  void initState() {
    scrollController = FixedExtentScrollController(
        initialItem: widget.values.indexOf(widget.startValue));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final height = MediaQuery.of(context).size.width - 110;
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          Text(
            widget.header,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: scheme.primary,
              fontSize: 20,
              fontFamily: "Roboto",
              fontWeight: FontWeight.w700,
            ),
          ),

          Center(
            child: Consumer<GameModel>(builder: (context, gameModel, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconButton(
                    iconName: "assets/images/icons/left_big_arrow_icon.svg",
                    color: scheme.onTertiary,
                    iconSize: 30,
                    onTap: () {
                      var currentIndex = scrollController.selectedItem > 0
                          ? scrollController.selectedItem - 1
                          : widget.values.length - 1;
                      gameModel.setTimeLimit(widget.values[currentIndex]
                          == GameSettingConsts.longDashSymbol ? 0
                          : widget.values[currentIndex]);
                      scrollController.jumpToItem(currentIndex);
                    },
                  ),
                  SizedBox(
                    height: 50,
                    child: WheelChooser(
                      controller: scrollController,
                      horizontal: true,
                      listHeight: height,
                      isInfinite: true,
                      itemSize: 65,
                      perspective: 0.003,
                      onValueChanged: widget.onChanged,
                      datas: widget.values,
                      startPosition: null,
                      selectTextStyle: const TextStyle(
                        color: ColorsConst.primaryColor100,
                        fontSize: 22,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w700,
                      ),
                      unSelectTextStyle: TextStyle(
                        color: scheme.onTertiary,
                        fontSize: 20,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  CustomIconButton(
                    iconName: "assets/images/icons/right_big_arrow_icon.svg",
                    color: scheme.onTertiary,
                    iconSize: 30,
                    onTap: () {
                      var currentIndex = (scrollController.selectedItem + 1) % widget.values.length;
                      gameModel.setTimeLimit(widget.values[currentIndex]
                          == GameSettingConsts.longDashSymbol ? 0
                          : widget.values[currentIndex]);
                      scrollController.jumpToItem(currentIndex);
                    },
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
