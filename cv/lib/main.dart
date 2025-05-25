import 'package:cv/pages/contact_page.dart';
import 'package:cv/pages/education_page.dart';
import 'package:cv/pages/experience_page.dart';
import 'package:cv/pages/profile_page.dart';
import 'package:cv/pages/project_page.dart';
import 'package:cv/pages/skills_page.dart';
import 'package:cv/utils/AppColors.dart';
import 'package:cv/utils/AppIcons.dart';
import 'package:cv/widgets/navigation_menu_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CV App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  int selectedMenuIndex = 0;

  final DatabaseReference databaseRef =
      FirebaseDatabase.instance.ref("Portfolio");

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 6, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedMenuIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double iconSize = 20.0;
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white, // veya backgroundLight
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
                      isSelected: selectedMenuIndex == 0,
                      onClick: () => _tabController.animateTo(0),
                    ),
                    NavigationMenu(
                      navExperince,
                      height: iconSize,
                      width: iconSize,
                      isSelected: selectedMenuIndex == 1,
                      onClick: () => _tabController.animateTo(1),
                    ),
                    NavigationMenu(
                      navProject,
                      height: iconSize,
                      width: iconSize,
                      isSelected: selectedMenuIndex == 2,
                      onClick: () => _tabController.animateTo(2),
                    ),
                    NavigationMenu(
                      navContact,
                      height: iconSize,
                      width: iconSize,
                      isSelected: selectedMenuIndex == 3,
                      onClick: () => _tabController.animateTo(3),
                    ),
                    NavigationMenu(
                      navEducation,
                      height: iconSize,
                      width: iconSize,
                      isSelected: selectedMenuIndex == 4,
                      onClick: () => _tabController.animateTo(4),
                    ),
                  ],
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    ProfilePage(
                      databaseRef,
                    ),
                    ExperiencePage(),
                    ProjectPage(),
                    SkillsPage(),
                    ContactPage(),
                    EducationPage()
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
