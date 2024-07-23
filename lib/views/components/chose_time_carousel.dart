import 'package:flutter/material.dart';


class ChoseTimeCarousel extends StatelessWidget {
  const ChoseTimeCarousel({
    super.key,
    required this.values,
    required this.type,
    required this.header
  });

  final List<int> values;
  final String type;
  final String header;

  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          Text(
            header,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: scheme.primary,
              fontSize: 20,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
            ),
          ),
          Container(
            height: 50,
            color: Colors.green,
          ),
        ],
      ),
    );
  }

}