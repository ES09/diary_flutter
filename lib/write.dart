import 'package:diary_exercise/data/database.dart';
import 'package:diary_exercise/data/diary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DiaryWritePage extends StatefulWidget{
  final Diary diary;

  DiaryWritePage({Key key, this.diary}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DiaryWritePageState();
  }
}

class _DiaryWritePageState extends State<DiaryWritePage> {

  final dbhelper = DatabaseHelper.instance;

  List<String> images = [
    "assets/img/b1.jpg",
    "assets/img/b2.jpg",
    "assets/img/b3.jpg",
    "assets/img/b4.jpg",
  ];

  List<String> statusImages = [
    "assets/img/ico-weather.png",
    "assets/img/ico-weather_2.png",
    "assets/img/ico-weather_3.png",
  ];

  int imageIndex = 0;
  TextEditingController titleController = TextEditingController();
  TextEditingController memoController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController.text = widget.diary.title;
    memoController.text = widget.diary.memo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () async {
              widget.diary.title = titleController.text;
              widget.diary.memo = memoController.text;

              await dbhelper.modifydiary(widget.diary);
              Navigator.of(context).pop();
            },
            child: Text("저장", style: TextStyle(color: Colors.white),)
          )
        ],
      ),
      body: ListView.builder(
        itemBuilder: (ctx, idx) {
          if(idx == 0) {
            return InkWell(child: Container(
              margin: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16
              ),
              width: 100,
              height: 100,
              child: Image.asset(widget.diary.image, fit: BoxFit.cover),
            ),
            onTap: (){
              widget.diary.image = images[imageIndex];
              imageIndex++;
              setState(() {
                imageIndex = imageIndex % images.length;
              });
            },);
          }
          else if(idx == 1) {
            return Container(
              margin: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(statusImages.length, (_idx) {
                  return InkWell(child : Container(
                    width: 70,
                    height: 70,
                    child: Image.asset(statusImages[_idx], fit: BoxFit.contain),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: _idx == widget.diary.status ? Colors.blue : Colors.transparent,),
                      borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                  onTap: (){
                    setState(() {
                      widget.diary.status = _idx;
                    });
                  },
                  );
                }),
              ),
            );
          }
          else if(idx == 2) {
            return Container(
              margin: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16
              ),
              child: Text("제목", style: TextStyle(fontSize: 20),),
            );
          }
          else if(idx == 3) {
            return Container(
              margin: EdgeInsets.symmetric(
                  horizontal: 16
              ),
              child: TextField(
                controller: titleController,
              ),
            );
          }
          else if(idx == 4) {
            return Container(
              margin: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16
              ),
              child: Text("내용", style: TextStyle(fontSize: 20),),
            );
          }
          else if(idx == 5){
            return Container(
              margin: EdgeInsets.symmetric(
                  horizontal: 16
              ),
              child: TextField(
                controller: memoController,
                minLines: 10,
                maxLines: 10,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)
                  )
                ),
              ),
            );
          }
          return Container();
        },
        itemCount: 6,
      ),

    );
  }
}