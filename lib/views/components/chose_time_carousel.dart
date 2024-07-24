import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/constants/colors.dart';
import 'package:wheel_chooser/wheel_chooser.dart';


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
              Container(
                width: 30,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  onPressed: () {
                    if (initPosition > 0) {
                      setState(() {
                        initPosition -= 1;
                      });
                    }
                  },
                  icon: SvgPicture.asset(
                    "assets/images/icons/left_small_arrow_icon.svg",
                    color: scheme.onTertiary,
                  )
                ),
              ),
              SizedBox(
                height: 50,
                child: WheelChooser(
                  horizontal: true,
                  listHeight: height,
                  itemSize: 65,
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
              Container(
                width: 30,
                child: IconButton(
                  onPressed: () {
                    if(initPosition < widget.values.length - 1) {
                      setState(() {
                        initPosition += 1;
                      });
                    }
                  },
                  icon: SvgPicture.asset(
                    "assets/images/icons/right_small_arrow_icon.svg",
                    color: scheme.onTertiary,
                  )
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}