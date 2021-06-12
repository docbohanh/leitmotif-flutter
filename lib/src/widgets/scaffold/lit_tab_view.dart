import 'package:flutter/material.dart';
import 'package:lit_ui_kit/bottom_navigation.dart';

/// A wrapper widget allowing to navigate the provided tab widgets inside an
/// surrounding tab view. It implements the required logic for tracking the
/// state and the for navigating between the tabs.
///
/// The [LitBottomNavigation] is used as view layer.
class LitTabView extends StatefulWidget {
  /// The tabs the tab view should display.
  final List<LitNavigableTab> tabs;

  /// Creates a [LitTabView].
  ///
  /// * [tabs] are the widget and data objects the view should display.
  const LitTabView({Key? key, required this.tabs}) : super(key: key);

  @override
  _LitTabViewState createState() => _LitTabViewState();
}

class _LitTabViewState extends State<LitTabView> {
  /// The currently user selected tab stated as its index value.
  int tabIndex = 0;

  /// All available tab screen [Widget] objects that can be navigated.
  List<Widget> _tabs = [];

  /// All tab data objects providing the meta data for the tabs.
  List<LitBottomNavigationTabData> _tabData = [];

  /// Sets the state to change the currently displayed tab.
  void _setTabIndex(int value) {
    setState(() {
      tabIndex = value;
    });
  }

  /// Separetes the provided [LitNavigableTab] into individual [Widget] and
  /// [LitBottomNavigationTabData] lists.
  void bindWidgetsAndData() {
    for (LitNavigableTab item in widget.tabs) {
      _tabs.add(item.screen);
      _tabData.add(item.tabData);
    }
  }

  @override
  void initState() {
    bindWidgetsAndData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          return Stack(
            children: [
              _tabs[tabIndex],
              LitBottomNavigation(
                selectedTabIndex: tabIndex,
                onTabSelect: _setTabIndex,
                tabs: _tabData,
              )
            ],
          );
        },
      ),
    );
  }
}

/// A model class combining the [Widget] view layer and it's meta data object.
class LitNavigableTab {
  /// The meta data objects for the tab.
  final LitBottomNavigationTabData tabData;

  /// The screen tab.
  final Widget screen;

  /// Creates a [LitNavigableTab]
  const LitNavigableTab({required this.tabData, required this.screen});
}