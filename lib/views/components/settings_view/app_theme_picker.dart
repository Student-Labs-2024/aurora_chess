import 'package:frontend/model/app_model.dart';
import 'package:frontend/views/components/shared/text_variable.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AppThemePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, appModel, child) => Column(
        children: [
          Container(
            child: TextSmall('App Theme'),
            padding: EdgeInsets.all(10),
          ),
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Color(0x20000000),
            ),
          )
        ],
      ),
    );
  }
}
