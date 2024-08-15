import "package:flutter/material.dart";
import "../../constants/constants.dart";
import "../setting_view/setting_view.dart";

class CustomTabBar extends StatefulWidget{
  const CustomTabBar({
    super.key,
    required this.initialIndex,
    required this.header,
    required this.subTitles,
    required this.isSettingsPage,
    this.onTap,
  });

  final int initialIndex;
  final String header;
  final List<String> subTitles;
  final bool isSettingsPage;
  final void Function(int)? onTap;

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with TickerProviderStateMixin  {

  late TabController _tabColorController;

  @override
  void initState() {
    _tabColorController =
        TabController(length: widget.subTitles.length,
            vsync: this, initialIndex: widget.initialIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        widget.isSettingsPage ?
        TextHeading(
          text: widget.header,
          topMargin: 32,
          bottomMargin: 16,
        ) : const SizedBox(),
        PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
                Radius.circular(10)),
            child: Container(
              height: 44,
              padding: const EdgeInsets.all(4),
              decoration: ShapeDecoration(
                color: scheme.secondary,
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
                      Radius.circular(12)),
                ),
                controller: _tabColorController,
                onTap: widget.onTap,
                labelPadding: EdgeInsets.zero,
                unselectedLabelColor:
                ColorsConst.neutralColor300,
                tabs: List.generate(
                  _tabColorController.length, (index) {
                    return TabItem(
                      title: widget.subTitles[index],
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
