import 'package:flutter/material.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

import '../../exports.dart';


class ChoseTimeCarousel extends StatefulWidget {
  const ChoseTimeCarousel({
    super.key,
    required this.values,
    required this.type,
    required this.header,
    required this.startValue,
    this.onChanged,
  });

  final List<int> values;
  final String type;
  final String header;
  final int startValue;
  final void Function(dynamic)? onChanged;

  @override
  State<ChoseTimeCarousel> createState() => _ChoseTimeCarouselState();
}

class _ChoseTimeCarouselState extends State<ChoseTimeCarousel> {

  int initPosition = 0;

  @override
  void initState() {
    setState(() {
      initPosition = widget.values.indexOf(widget.startValue);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    var height = MediaQuery.of(context).size.width - 110;
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
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
            ),
          ),
          Row(
            children: [
              CustomIconButton(
                iconName: "assets/images/icons/left_big_arrow_icon.svg",
                color: scheme.onTertiary,
                iconSize: 30,
                onTap: () {
                  if (initPosition > 0) {
                    setState(() {
                      initPosition -= 1;
                    });
                  }
                },
              ),
              SizedBox(
                height: 50,
                child: WheelChooser(
                  horizontal: true,
                  listHeight: height,
                  itemSize: 65,
                  perspective: 0.001,
                  onValueChanged: widget.onChanged,
                  datas: widget.values,
                  startPosition: initPosition,
                  selectTextStyle: const TextStyle(
                    color: ColorsConst.primaryColor100,
                    fontSize: 20,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                  ),
                  unSelectTextStyle: TextStyle(
                    color: scheme.onTertiary,
                    fontSize: 20,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              CustomIconButton(
                iconName: "assets/images/icons/right_big_arrow_icon.svg",
                color: scheme.onTertiary,
                iconSize: 30,
                onTap: () {
                  if(initPosition < widget.values.length - 1) {
                    setState(() {
                      initPosition += 1;
                    });
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}