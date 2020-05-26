import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:musicplayer/Song.dart';
import 'package:permission_handler/permission_handler.dart';
/*
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
*/
import 'storageUtil.dart';
import 'package:musicplayer/PlayQueue.dart';

/*This function gets the necessary read/write permission*/
Future<void> getPermissions() async {
  try {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  } catch (e) {
    print(e);
  }
}

void main() {
  getPermissions();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player',
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      home: MyHomePage(title: 'Music Player'),
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
  LinkedHashMap musicFolderToSongsMap =
      LinkedHashMap<String, List<FileSystemEntity>>();

  @override
  void initState() {
    super.initState();
    setState(() {
      print("Initializing State");
      List<FileSystemEntity> allMusicDirs = getAllMusicDirs();
      //print("allMusicDirs: "+ allMusicDirs.toList().toString());
      musicFolderToSongsMap["Music"] =
          getAllSongsInDirectory("/storage/emulated/0/Music/");
      for (FileSystemEntity fse in allMusicDirs) {
        String folderName = fse.path.split('/').last.toString();
        //print("Getting songs in /Music/"+folderName);
        List<FileSystemEntity> songsList = getAllSongsInDirectory(fse.path);
        if (songsList.length > 0) musicFolderToSongsMap[folderName] = songsList;
      }
      ;
      print("musicFolderToSongsMap.keys: " +
          musicFolderToSongsMap.keys.toList().toString());
    });
  }

  Container musicFolderCard(String txt) {
    return Container(
      child: Material(
        child: InkWell(
          child: Center(
            child: Stack(children: <Widget>[
              Text(
                txt.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 38.0,
                  fontWeight: FontWeight.w200,
                  letterSpacing: 2.0,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 2
                    ..color = Colors.white.withAlpha(50),
                ),
              ),
              Text(
                txt.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 38.0,
                  fontWeight: FontWeight.w200,
                  letterSpacing: 2.0,
                  color: Colors.black,
                ),
              ),
            ]),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SecondRoute(
                        folderName: txt,
                        songsList: musicFolderToSongsMap[txt],
                      )),
            );
            print("Tapped folder: " + txt);
          },
          borderRadius: BorderRadius.all(Radius.circular(18.0)),
        ),
        color: Colors.transparent,
      ),
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(18.0)),
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xffB0F3F1), Color(0xffFFCFDF)]),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: -5.0,
            blurRadius: 5,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50.0),
        padding: EdgeInsets.all(24.0),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
                delegate: SliverChildListDelegate([
              Text("Folders".toUpperCase(),
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 36.0,
                      fontFamily: "SFFlorencesans",
                      letterSpacing: 1.0)),
              Padding(
                padding: EdgeInsets.only(top: 18.0),
              ),
            ])),
            SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                delegate: SliverChildListDelegate(musicFolderToSongsMap.keys
                    .map((e) => musicFolderCard(e))
                    .toList())),
            SliverList(
                delegate: SliverChildListDelegate([
              Padding(
                padding: EdgeInsets.only(top: 24.0),
              ),
              Text("Playlists".toUpperCase(),
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 36.0,
                      fontFamily: "SFFlorencesans",
                      letterSpacing: 1.0)),
              Padding(
                padding: EdgeInsets.only(top: 24.0),
              ),
            ])),
          ],
        ),
      ),
    );
  }
}
/*
Future<Song> generateSong(URI) async {
  AudioPlayer audioPlayer = AudioPlayer();

  String title = "";
  await audioPlayer.;
  String tags = "";

  return Song(title, URI, duration, tags)
}*/

class SecondRoute extends StatelessWidget {
  SecondRoute({Key key, this.folderName, this.songsList}) : super(key: key);
  final String folderName;
  final List<FileSystemEntity> songsList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: <Widget>[
        SliverList(
            delegate: SliverChildListDelegate([
          Padding(
            padding: EdgeInsets.only(top: 50.0),
          ),
          Row(
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  tooltip: 'Back',
                ),
              ),
              Text(folderName),
            ],
          ),
        ])),
        SliverList(
          delegate: SliverChildListDelegate(
              songsList.map((e) => Text(e.path)).toList()),
        )
      ]),
    );
  }
}
