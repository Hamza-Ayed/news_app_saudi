import 'package:flutter/material.dart';
import 'package:news/constant/colors.dart';
import 'package:news/constant/web_name.dart';
import 'package:page_transition/page_transition.dart';

import 'news_page_admin.dart';
import 'twitter_page.dart';
import 'wordpressfeed.dart';

class HomePageAdmin extends StatelessWidget {
  const HomePageAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page Admin'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios))
        ],
      ),
      backgroundColor: dirctive2.withOpacity(.6),
      body: const Center(child: Text('data')),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // drawerItem(news3, 'Barcelona', hihi2, belgol, mercato, sport195,
              //     'Barcelona', 12, 10679, 135, 0, 6, context),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rotate,
                          alignment: Alignment.centerLeft,
                          duration: const Duration(seconds: 1),
                          child: const TwitterPageFeedAdmin()));
                },
                child: const Text('Twitter'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rotate,
                          alignment: Alignment.centerLeft,
                          duration: const Duration(seconds: 1),
                          child: const WordPressFeedAdmin()));
                },
                child: const Text('ALL FEED'),
              ),
              drawerItem(
                  news3,
                  'ريال مدريد',
                  hihi2,
                  belgol,
                  mercato,
                  cornersport,
                  'RealMadrid',
                  13,
                  10680,
                  138,
                  2043,
                  138,
                  2043,
                  1379,
                  7,
                  context),
              drawerItem(news3, 'ليفربول', hihi2, belgol, mercato, cornersport,
                  'Liverpool', 35, 10696, 0, 2045, 1, 6, 7, 13, context),
              drawerItem(
                  dirctive,
                  '‏الدوري السعودي',
                  hihisaudi,
                  spotksa,
                  mercato,
                  cornersport,
                  'Saudiliga',
                  1,
                  3,
                  1000,
                  3,
                  47,
                  6,
                  27,
                  26,
                  context),
              drawerItem(
                  dirctive,
                  'Barcelona',
                  hihi2,
                  belgol,
                  mercato,
                  cornersport,
                  'Barcelona',
                  12,
                  10679,
                  44410,
                  2042,
                  1,
                  6,
                  7,
                  6,
                  context),
              drawerItem(
                  news3,
                  'الدوري الإيطالي ',
                  hihi2,
                  belgol,
                  mercato,
                  cornersport,
                  'ItalyLiga',
                  26,
                  10701,
                  44410,
                  2052,
                  35,
                  126,
                  7,
                  17,
                  context),
              drawerItem(
                  dirctive,
                  '‏الهلال السعودي',
                  hihisaudi,
                  belgol,
                  belgol,
                  cornersport,
                  'Hella',
                  8,
                  10642,
                  10642,
                  2035,
                  6131,
                  97,
                  6086,
                  30,
                  context)
            ],
          ),
        ),
      ),
    );
  }

  Padding drawerItem(
      Color kolor,
      String title,
      site1,
      site2,
      site3,
      site4,
      teamName,
      int id1,
      id2,
      id3,
      id4,
      id5,
      id6,
      id7,
      categoryID,
      BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: kolor,
          border: Border.all(
            color: dirctive2,
            width: 1,
          ),
          shape: BoxShape.rectangle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            child: Text(title),
            onPressed: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rotate,
                      alignment: Alignment.centerLeft,
                      duration: const Duration(seconds: 1),
                      child: NewsPageAdmin(
                        site1: site1,
                        categoryID: categoryID,
                        teamName: teamName,
                        list: [],
                        site2: site2,
                        site3: site3,
                        site4: site4,
                        id1: id1,
                        id2: id2,
                        id3: id3,
                        id4: id4,
                        id5: id5,
                        id6: id6,
                        id7: id7,
                        color: kolor,
                      )));
            },
          ),
        ),
      ),
    );
  }
}
