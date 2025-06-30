import 'package:cv/controller/firebase_controller.dart';
import 'package:cv/providers/navigation_provider.dart';
import 'package:cv/widgets/main_content_tabs.dart';
import 'package:cv/widgets/navigation_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    Provider.of<NavigationProvider>(context, listen: false)
        .initController(this);
  }

  @override
  void dispose() {
    Provider.of<NavigationProvider>(context, listen: false).disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    final firebase = Provider.of<FirebaseController>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          margin: const EdgeInsets.only(top: 10, left: 10),
          child: Row(
            children: <Widget>[
              NavigationSidebar(
                selectedIndex: navigationProvider.selectedIndex,
                onMenuTap: (index) => navigationProvider.changeIndex(index),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: MainContentTabs(
                  controller: navigationProvider.tabController!,
                  databaseRef: firebase.portfolio,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
