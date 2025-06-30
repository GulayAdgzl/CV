import 'package:cv/pages/contact_page.dart';
import 'package:cv/pages/experience_page.dart';
import 'package:cv/pages/profile_page.dart';
import 'package:cv/pages/project_page.dart';
import 'package:cv/pages/resume_generator_page.dart';
import 'package:cv/pages/skills_page.dart';
import 'package:cv/providers/navigation_provider.dart';
import 'package:cv/utils/AppIcons.dart';
import 'package:cv/widgets/navigation_menu_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final DatabaseReference databaseRef =
      FirebaseDatabase.instance.ref("Portfolio");

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
    final tabController = navigationProvider.tabController;
    final selectedIndex = navigationProvider.selectedIndex;

    double iconSize = 20.0;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          margin: const EdgeInsets.only(top: 10, left: 10),
          child: Row(
            children: <Widget>[
              Container(
                width: 50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 45,
                      height: 45,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: Image.asset("assets/pp.png"),
                    ),
                    NavigationMenu(
                      navProfile,
                      height: iconSize,
                      width: iconSize,
                      isSelected: selectedIndex == 0,
                      onClick: () => navigationProvider.changeIndex(0),
                    ),
                    NavigationMenu(
                      navExperince,
                      height: iconSize,
                      width: iconSize,
                      isSelected: selectedIndex == 1,
                      onClick: () => navigationProvider.changeIndex(1),
                    ),
                    NavigationMenu(
                      navProject,
                      height: iconSize,
                      width: iconSize,
                      isSelected: selectedIndex == 2,
                      onClick: () => navigationProvider.changeIndex(2),
                    ),
                    NavigationMenu(
                      navContact,
                      height: iconSize,
                      width: iconSize,
                      isSelected: selectedIndex == 3,
                      onClick: () => navigationProvider.changeIndex(3),
                    ),
                    NavigationMenu(
                      navEducation,
                      height: iconSize,
                      width: iconSize,
                      isSelected: selectedIndex == 4,
                      onClick: () => navigationProvider.changeIndex(4),
                    ),
                  ],
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: TabBarView(
                  controller: tabController,
                  children: [
                    ProfilePage(databaseRef),
                    ExperiencePage(),
                    ProjectPage(),
                    SkillsPage(),
                    ContactPage(),
                    ResumeGeneratorPage()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
