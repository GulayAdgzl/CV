import 'package:flutter/material.dart';

class NavigationProvider with ChangeNotifier {
  late TabController _tabController;
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;
  TabController get tabController => _tabController;

  void initController(TickerProvider vsync, {int tabCount = 6}) {
    _tabController = TabController(length: tabCount, vsync: vsync);
    _tabController.addListener(() {
      _selectedIndex = _tabController.index;
      notifyListeners();
    });
  }

  void changeIndex(int index) {
    _tabController.animateTo(index);
    _selectedIndex = index;
    notifyListeners();
  }

  void disposeController() {
    _tabController.dispose();
  }
}
