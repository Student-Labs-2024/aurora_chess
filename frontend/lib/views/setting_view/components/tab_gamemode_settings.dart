import "package:flutter/material.dart";
import "../../../constants/constants.dart";
import "../setting_view.dart";

class TabGameModeSettings extends StatefulWidget{
  const TabGameModeSettings({
    super.key,
    required this.initialIndex,
    required this.header,
    required this.firstSubTitle,
    required this.secondSubTitle,
    this.onTap,
  });

  final int initialIndex;
  final String header;
  final String firstSubTitle;
  final String secondSubTitle;
  final void Function(int)? onTap;

  @override
  State<TabGameModeSettings> createState() => _TabGameModeSettingsState();
}

class _TabGameModeSettingsState extends State<TabGameModeSettings>
    with TickerProviderStateMixin  {

  late TabController _tabColorController;
  late List<String> subTitles;

  @override
  void initState() {
    _tabColorController =
        TabController(length: 2, vsync: this, initialIndex: widget.initialIndex);
    subTitles = [
      widget.firstSubTitle,
      widget.secondSubTitle
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        TextHeading(
          text: widget.header,
          topMargin: 32,
          bottomMargin: 16,
        ),
        PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
                Radius.circular(10)),
            child: Container(
              height: 44,
              padding: const EdgeInsets.all(4),
              decoration: ShapeDecoration(
                color: scheme.outline,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(16),
                ),
              ),
              child: TabBar(
                indicatorSize:
                TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicator: const BoxDecoration(
                  color: ColorsConst.primaryColor100,
                  borderRadius: BorderRadius.all(
                      Radius.circular(10)),
                ),
                controller: _tabColorController,
                onTap: widget.onTap,
                labelPadding: EdgeInsets.zero,
                unselectedLabelColor:
                ColorsConst.neutralColor300,
                tabs: List.generate(
                  _tabColorController.length, (index) {
                    return TabItem(
                      title: subTitles[index],
                      index: index,
                      currentIndex:
                      _tabColorController.index,
                    );
                  }
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}