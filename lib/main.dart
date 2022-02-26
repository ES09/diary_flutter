import 'package:diary_exercise/data/database.dart';
import 'package:diary_exercise/data/diary.dart';
import 'package:diary_exercise/data/util.dart';
import 'package:diary_exercise/write.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diary',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Diary'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final dbHelper = DatabaseHelper.instance;

  List<String> statusImages = [
    "assets/img/ico-weather.png",
    "assets/img/ico-weather_2.png",
    "assets/img/ico-weather_3.png",
  ];

  int selectIndex = 0;
  Diary todayDiary;

  void getTodayDiary() async {
    List<Diary> diary = await dbHelper.getDiaryByDate(Utils.getFormatTime(DateTime.now()));
    if(diary.isNotEmpty) {
      todayDiary = diary.first;
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTodayDiary();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: getPage(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Diary _d;
          if(todayDiary != null) {
            _d = todayDiary;
          } else {
            _d = Diary(
                date: Utils.getFormatTime(DateTime.now()),
                title: "",
                memo: "",
                image: "assets/img/b1.jpg",
                status: 0
            );
          }
          await Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => DiaryWritePage(
            diary: _d,
          )));
          getTodayDiary();
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: "오늘"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_rounded),
            label: "기록"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart),
            label: "통계"
          ),
        ],
        onTap: (idx) {
          setState(() {
            selectIndex = idx;
          });
        },
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget getPage(){
    if(selectIndex == 0) {
      return getTodayPage();
    } else if(selectIndex == 1) {
      return getHistoryPage();
    } else {
      return getChartPage();
    }
  }

  Widget getTodayPage(){
    if(todayDiary == null) {
      return Container(
        child: Text("오늘의 일기를 작성하세요."),
      );
    }
    return Container(
      child: Stack(
        children: [
          Positioned.fill(
              child: Image.asset(todayDiary.image, fit: BoxFit.cover),
          ),
          Positioned.fill(
              child: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${DateTime.now().year}.${DateTime.now().month}.${DateTime.now().day}",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Image.asset(statusImages[todayDiary.status], fit: BoxFit.contain),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(todayDiary.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                        Container(height: 12,),
                        Text(todayDiary.memo, style: TextStyle(fontSize: 18),)
                      ],
                    ),
                  )
                ],
              )
          )
        ],
      ),
    );
  }

  Widget getHistoryPage(){
    return Container();
  }

  Widget getChartPage(){
    return Container();
  }
}
