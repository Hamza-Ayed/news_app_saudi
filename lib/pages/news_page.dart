import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:html/parser.dart';
import 'package:news/constant/colors.dart';
import 'package:news/constant/web_name.dart';
import 'package:news/db/sql_user.dart';
import 'package:news/provider/provider.dart';

import 'news_details.dart';

// ignore: must_be_immutable
class NewsPage extends StatefulWidget {
  final String teamName, title;
  int categoryID;
  final List? list;
  final Color color;

  NewsPage(
      {Key? key,
      required this.categoryID,
      required this.title,
      required this.teamName,
      required this.list,
      required this.color})
      : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List haber = [];
  bool isloading = true;

  Future getHaberfromSQLtoUser() async {
    // print(widget.title.toString());
    // if (ConnectionState.active == true) {
    await NewsUserDB(widget.teamName.toString())
        .deleteAllNews(widget.teamName.toString());
    // }

    await NewsProvider()
        .getFromPHP(widget.teamName.toString(), widget.title.toString());
    await NewsUserDB(widget.teamName.toString()).gitDistnct().then((value) {
      setState(() {
        haber = value;
        isloading = false;
        // print(haber);
      });
      Fluttertoast.showToast(
          msg: "‏تم تجهيز الأخبار ‏وعددها ${haber.length}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          webShowClose: true,
          fontSize: 16.0);
    });
  }

  @override
  void initState() {
    getHaberfromSQLtoUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: dirctive.withOpacity(.5),
        title: Text(widget.title.toString()),
      ),
      backgroundColor: dirctive.withOpacity(.5),
      body: Center(
        child: isloading
            ? const CircularProgressIndicator()
            : Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.50),
                          Colors.black.withOpacity(0.80)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Image.network(
                          'https://www.moorfootball.co.uk/wp-content/uploads/2020/05/football-icon2.gif',
                          scale: 1.0),
                    ),
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  // Image.network(
                  //   'https://r1.ilikewallpaper.net/iphone-wallpapers/download/19996/FC-Barcelona-iphone-wallpaper-ilikewallpaper_com_200.jpg',
                  //   height: double.maxFinite,
                  //   width: double.maxFinite,
                  //   fit: BoxFit.cover,
                  // ),
                  ListView.builder(
                    itemBuilder: (context, index) {
                      var news = haber[index];
                      // print('post id = ' + news['post_id'].toString());
                      DateTime now = DateTime.now();
                      DateTime dateTime =
                          DateTime.parse(news['pubdate'].toString());
                      var timezone = dateTime.timeZoneOffset.toString();
                      // print('timzone ' + timezone.toString());
                      int zonetime = 0;
                      if (timezone == '2:00:00.000000') {
                        zonetime = 2;
                      } else if (timezone == '3:00:00.000000') {
                        zonetime = 3;
                      } else if (timezone == '1:00:00.000000') {
                        zonetime = 1;
                      }

                      DateTime realtime =
                          dateTime.add(Duration(hours: zonetime));
                      var diffDt = now.difference(realtime).inMinutes;
                      var diffDays = now.difference(realtime).inHours;
                      String timeName;
                      if (diffDays > 24) {
                        double diffDays1 = diffDays / 24.toInt();
                        diffDays = diffDays1.toInt();
                        timeName = 'day';
                      }
                      if (diffDt > 60) {
                        double diffDt1 = diffDt / 60.toInt();
                        diffDt = diffDt1.toInt();
                        timeName = '‏ساعة ';
                      } else {
                        timeName = '‏ دقيقة';
                      }

                      // print(news['isread'].toString() + 'isread');
                      String siteName = '', siteImage = '';
                      if (news['sitename'].toString() ==
                          '$hihi2/wp-json/wp/v2/posts') {
                        siteName = '‏هاي كورة';
                        siteImage =
                            'https://sc5.hihi2.com/wp-content/themes/hihi2/images/hihi2-logo.png';
                      } else if (news['sitename'].toString() ==
                          '$sport195/wp-json/wp/v2/posts') {
                        siteName = 'Sport195';
                        siteImage =
                            'https://www.195sports.com/wp-content/uploads/2020/09/195sportslogo.png';
                      } else if (news['sitename'].toString() ==
                          '$barsalony/wp-json/wp/v2/posts') {
                        siteName = '‏برشلوني';
                        siteImage =
                            'https://barslony.com/wp-content/uploads/2016/05/Barslony-Logo.png';
                      } else if (news['sitename'].toString() ==
                          '$hihisaudi/wp-json/wp/v2/posts') {
                        siteName = '‏هاي كورة';
                        siteImage =
                            'https://sc5.hihi2.com/wp-content/themes/hihi2/images/hihi2-logo.png';
                      } else if (news['sitename'].toString() ==
                          'https://saudileague.com/wp-json/wp/v2/posts') {
                        siteName = 'SaudiLeague';
                        siteImage =
                            'https://saudileague.wpengine.com/wp-content/uploads/2016/10/logo.png';
                      } else if (news['sitename'].toString() ==
                          '$belgol/wp-json/wp/v2/posts') {
                        siteName = '‏بالجول';
                        siteImage =
                            'https://www.belgoal.com/wp-content/uploads/2017/08/BelGoal300.png';
                      } else if (news['sitename'].toString() ==
                          '$cornersport/wp-json/wp/v2/posts') {
                        siteName = '‏كورنر';
                        siteImage =
                            'https://cornersport.org/wp-content/uploads/2020/02/86840879_650142765555703_5804754399121113088_n.png';
                      } else if (news['sitename'].toString() ==
                          '$mercato/wp-json/wp/v2/posts') {
                        siteName = '‏ميركاتو';
                        siteImage =
                            'https://mercatoday.com/wp-content/uploads/2020/04/x2-logo.png';
                      } else if (news['sitename'].toString() ==
                          'https://www.sportksa.net/main/wp-json/wp/v2/posts') {
                        siteName = '‏سبورت سعودي';
                        siteImage =
                            'https://s2.sportksa.net/main/wp-content/themes/sports/images/logo5.png';
                      } else if (news['sitename'].toString() ==
                          'https://wtskora.com/wp-json/wp/v2/posts') {
                        siteName = '‏واتس كورة';
                        siteImage =
                            'https://wtskora.com/wp-content/uploads/2021/01/wtskora-main-logo@2x.png';
                      }

                      return Column(
                        children: [
                          // SafeArea(
                          //   child: Container(
                          //     child: AdmobBanner(
                          //       adUnitId: getBannerAdUnitId(),
                          //       adSize: bannerSize,
                          //       listener: (AdmobAdEvent event,
                          //           Map<String, dynamic> args) {
                          //         // AdmobAdEvent.loaded;
                          //         // AdmobAdEvent.opened;

                          //         // handleEvent(event, args, 'Banner');
                          //       },
                          //     ),
                          //   ),
                          //   // Facebook_Banner(),
                          // ),
                          InkWell(
                            onTap: () {
                              // print(news['content'].toString());
                              // print(news['post_id']);
                              Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return NewsDetails(
                                    id: news['id'],
                                    teamName: widget.teamName,
                                    content: news['content'].toString(),
                                    desc: news['desc'].toString(),
                                    imageurl: news['imageurl'].toString(),
                                    pupdate: realtime.toString(),

                                    // pupdate: news['pubdate'].toString(),
                                    title: news['title'].toString(),
                                    site: news['link'].toString(),
                                    siteName: news['sitename'].toString(),
                                    postID: news['post_id'].toString(),
                                  );
                                },
                              ));
                            },
                            child: Container(
                              margin: const EdgeInsets.only(
                                  bottom: 6, right: 6, left: 6),
                              child: GlassContainer.clearGlass(
                                height: 290,
                                width: 350,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Stack(
                                        children: [
                                          Image.network(
                                            news['imageurl'].toString(),
                                            fit: BoxFit.cover,
                                            width: double.maxFinite,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .22,
                                            filterQuality: FilterQuality.high,
                                          ),
                                          Positioned(
                                            left: -3,
                                            top: 2,
                                            child: Transform.rotate(
                                              angle: -.3,
                                              child: GlassContainer.clearGlass(
                                                height: 50,
                                                width: 60,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  child: Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.comment,
                                                        size: 30,
                                                        color: Colors.red,
                                                      ),
                                                      news['count']
                                                                  .toString() ==
                                                              'null'
                                                          ? const Text(
                                                              '0',
                                                              style: TextStyle(
                                                                  fontSize: 25),
                                                            )
                                                          : Text(
                                                              news['count']
                                                                  .toString(),
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          25),
                                                            ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      // Text(news['content'].toString()),
                                      // Text(news['imageUrl']),
                                      //  parse((widget.title).toString()).documentElement.text,
                                      Text(
                                        parse(news['title'].toString())
                                            .documentElement!
                                            .text,
                                        textAlign: TextAlign.center,
                                        // textDirection:

                                        softWrap: true,
                                        style: TextStyle(
                                            decorationColor: sa4,
                                            color: white12Color,
                                            decorationThickness: 3,
                                            fontStyle: FontStyle.normal,
                                            fontFamily: 'NizarBBCKurdish',
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                timeName,
                                                style: TextStyle(
                                                    decorationColor: sa4,
                                                    color: sa3,
                                                    decorationThickness: 3,
                                                    fontStyle: FontStyle.normal,
                                                    fontFamily: 'Cairo',
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              Text(diffDt.toString()),
                                              Text(
                                                ' ‏منذ',
                                                style: TextStyle(
                                                    decorationColor: sa4,
                                                    color: sa3,
                                                    decorationThickness: 3,
                                                    fontStyle: FontStyle.normal,
                                                    fontFamily: 'Cairo',
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    siteName,
                                                    softWrap: true,
                                                    style: TextStyle(
                                                        decorationColor: sa4,
                                                        color: sa3,
                                                        decorationThickness: 3,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontFamily: 'Cairo',
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  Text(
                                                    '     ‏موقع',
                                                    style: TextStyle(
                                                        decorationColor: sa4,
                                                        color: sa3,
                                                        decorationThickness: 3,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontFamily: 'Cairo',
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Image.network(
                                                siteImage,
                                                width: 60,
                                                height: 50,
                                                // color: sa4,
                                                fit: BoxFit.scaleDown,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      // RaisedButton(
                                      //   onPressed: () {
                                      //     Haber(widget.teamName)
                                      //         .deleteNote(widget.teamName, index);
                                      //   },
                                      //   child: Text('Delete'),
                                      // )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                    itemCount: haber.length,
                  ),
                ],
              ),
      ),
    );
  }
}
