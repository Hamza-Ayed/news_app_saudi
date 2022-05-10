import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:news/constant/colors.dart';
import 'package:news/constant/url.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;

import 'admin/home_page_admin.dart';
import 'news_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List listTrendNews = [];
  String? selectedName;
  bool isloading = true;
  Future getTrendNews() async {
    const Duration(seconds: 3);
    try {
      var url = Uri.parse(spornewsUrl);
      var res = await http.post(
        url,
        body: {
          'action': 'TrendNews',
        },
      );
      final map = await json.decode(res.body);
      setState(() {
        listTrendNews = map;
        isloading = false;
      });
      // print(res.body);
      // await sqlInsert(teamName);
    } catch (e) {
      // print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getTrendNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.topToBottom,
                        alignment: Alignment.centerLeft,
                        duration: const Duration(milliseconds: 500),
                        child: const HomePageAdmin()));
              },
              icon: const Icon(Icons.admin_panel_settings))
        ],
      ),
      backgroundColor: news3,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: isloading
                  ? const CircularProgressIndicator()
                  : CarouselSlider.builder(
                      itemCount: listTrendNews.length,
                      itemBuilder: (context, index, realIndex) {
                        var res = listTrendNews[index];
                        return Hero(
                          tag: res['post_id'],
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xff444774),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  bottomRight: Radius.circular(40)),
                            ),
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.network(
                                  res['imageurl'].toString(),
                                  fit: BoxFit.cover,
                                  height:
                                      MediaQuery.of(context).size.height * .2,
                                ),
                                GlassContainer.clearGlass(
                                  height: 130,
                                  borderWidth: 0,
                                  child: Center(
                                    child: Text(
                                      res['title'].toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  width: MediaQuery.of(context).size.width * .4,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      options: CarouselOptions(
                        height: MediaQuery.of(context).size.height * .25,
                        reverse: true,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 0.9,
                        aspectRatio: 2.0,
                        initialPage: 2,
                      ),
                    ),
            ),
            DropdownButton(
              value: selectedName,
              hint: const Text('select item'),
              items: listTrendNews.map((list) {
                return DropdownMenuItem(
                  child: Text(list['post_id'].toString()),
                  value: list['post_id'],
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedName = value.toString();
                });
              },
            )
            // Text(listTrendNews[0]['id']),
            // StreamBuilder(
            //   stream: getTrendNews().asStream(),
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.done) {
            //       return CarouselSlider.builder(
            //         itemCount: listTrendNews.length,
            //         itemBuilder: (context, index, realIndex) {
            //           var res = listTrendNews[index];
            //           return Hero(
            //             tag: res['id'],
            //             child: Container(
            //               decoration: BoxDecoration(
            //                 color: nb4.withOpacity(.6),
            //                 borderRadius: const BorderRadius.only(
            //                     topLeft: Radius.circular(32),
            //                     bottomRight: Radius.circular(22)),
            //               ),
            //               width: MediaQuery.of(context).size.width,
            //               child: Row(
            //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
            //                 children: [
            //                   Image.network(
            //                     res['imageurl'],
            //                     fit: BoxFit.cover,
            //                     height: MediaQuery.of(context).size.height * .2,
            //                   ),
            //                   Container(
            //                     child: Text(
            //                       res['title'],
            //                       textAlign: TextAlign.right,
            //                       style: const TextStyle(
            //                           fontSize: 14,
            //                           fontWeight: FontWeight.bold),
            //                     ),
            //                     width: MediaQuery.of(context).size.width * .4,
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           );
            //         },
            //         options: CarouselOptions(
            //           height: MediaQuery.of(context).size.height * .25,
            //           reverse: true,
            //           autoPlay: true,
            //           enlargeCenterPage: true,
            //           viewportFraction: 0.9,
            //           aspectRatio: 2.0,
            //           initialPage: 2,
            //         ),
            //       );
            //     } else {
            //       return const CircularProgressIndicator();
            //     }
            //   },
            // ),
          ],
        ),
      ),
      drawer: Drawer(
        elevation: 4,
        semanticLabel: 'drawer',
        child: SingleChildScrollView(
          child: Column(
            children: [
              drawerItem(news4, 'Saudiliga', 'الدوري السعودي', context),
              drawerItem(news2, 'Hella', 'الهلال', context),
              drawerItem(news2, 'Ahli', 'الأهلي', context),
              drawerItem(news2, 'Shabab', 'الشباب', context),
              drawerItem(news2, 'Nasr', 'النصر', context),
              drawerItem(news2, 'IthadSaudi', 'اتحاد', context),
              drawerItem(news2, 'Taavn', 'التعاون', context),
              drawerItem(news2, 'Raad', 'الرائد', context),
              drawerItem(news2, 'FaisalySaudi', 'الفيصلي', context),
              drawerItem(news2, 'LaLiga', 'اسباني', context),
              drawerItem(news2, 'Psg', 'باريس', context),
              drawerItem(news2, 'Barcelona', 'برشلونة', context),
              drawerItem(news2, 'RealMadrid', 'مدريد', context),
              drawerItem(news2, 'AtlitcoMadrid', 'اتليتكو', context),
              drawerItem(news2, 'Primire', 'الانجليزي', context),
              drawerItem(news2, 'ManCity', 'سيتي', context),
              drawerItem(news2, 'ManUnited', 'يونايتد', context),
              drawerItem(news2, 'Chelsea', ' ', context),
              drawerItem(news2, 'Liverpool', ' ', context),
              drawerItem(news2, 'Totenham', ' ', context),
              drawerItem(news2, 'ItalyLiga', ' ', context),
              drawerItem(news2, 'InterMilan', ' ', context),
              drawerItem(news2, 'juventos', ' ', context),
              drawerItem(news2, 'milan', ' ', context),
              drawerItem(news2, 'bunsliga', ' ', context),
              drawerItem(news2, 'UEFA', ' ', context),
              drawerItem(news2, 'Goals', ' ', context),
              drawerItem(news2, 'favorate', ' ', context),
              drawerItem(news2, 'bunsliga', ' ', context),
            ],
          ),
        ),
      ),
    );
  }

  Padding drawerItem(
      Color kolor, String teamName, title, BuildContext context) {
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
                      type: PageTransitionType.scale,
                      alignment: Alignment.centerLeft,
                      duration: const Duration(seconds: 1),
                      child: NewsPage(
                        title: title,
                        categoryID: 1,
                        teamName: teamName,
                        list: [],
                        color: kolor,
                      )));
            },
          ),
        ),
      ),
    );
  }
}
