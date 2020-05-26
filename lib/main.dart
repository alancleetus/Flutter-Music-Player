import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
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

PlayQueue playQueue = PlayQueue();
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
                  builder: (context) => SongsListPage(
                        songsListName: txt,
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
      body: Builder(
        builder: (context) => SafeArea(
          child: Container(
            padding: EdgeInsets.all(24.0),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                    delegate: SliverChildListDelegate([
                  Text("Folders".toUpperCase(),
                      style: TextStyle(
                        fontSize: 36.0,
                        fontFamily: "SFFlorencesans",
                        letterSpacing: 1.0,
                        foreground: Paint()
                          ..shader = LinearGradient(
                            colors: <Color>[
                              Color(0xffA88BEB),
                              Color(0xff7F53AC)
                            ],
                          ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: 18.0),
                  ),
                ])),
                SliverList(
                    delegate: SliverChildListDelegate(musicFolderToSongsMap.keys
                        .map((e) => Container(
                              margin: EdgeInsets.all(8.0),
                              child: RaisedButton(
                                child: Row(
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          e,
                                          style: TextStyle(
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 5.0),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.music_note,
                                              size: 15.0,
                                              color: Colors.grey,
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 5.0),
                                            ),
                                            Text(
                                              musicFolderToSongsMap[e]
                                                  .length
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              (musicFolderToSongsMap[e].length >
                                                      1)
                                                  ? " songs"
                                                  : " song",
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Spacer(
                                      flex: 2,
                                    ),
                                    SizedBox(
                                      width: 50.0,
                                      height: 50.0,
                                      child: IconButton(
                                        padding: EdgeInsets.all(0.0),
                                        color: Colors.black,
                                        icon: Icon(Icons.shuffle, size: 30.0),
                                        onPressed: () {
                                          print("Shuffling " +
                                              e.toString().toUpperCase() +
                                              " folder");
                                          final scaff = Scaffold.of(context);
                                          scaff.showSnackBar(SnackBar(
                                            content: Text("Shuffling " +
                                                e.toString().toUpperCase() +
                                                " folder"),
                                            duration: Duration(seconds: 1),
                                            action: SnackBarAction(
                                              label: 'CLOSE',
                                              onPressed:
                                                  scaff.hideCurrentSnackBar,
                                            ),
                                          ));
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 50.0,
                                      height: 50.0,
                                      child: IconButton(
                                        padding: EdgeInsets.all(0.0),
                                        color: Colors.black,
                                        icon: Icon(Icons.playlist_play,
                                            size: 40.0),
                                        onPressed: () {
                                          print("Playing " +
                                              e.toString().toUpperCase() +
                                              " folder");
                                          final scaff = Scaffold.of(context);
                                          scaff.showSnackBar(SnackBar(
                                            content: Text("Playing " +
                                                e.toString().toUpperCase() +
                                                " folder"),
                                            duration: Duration(seconds: 1),
                                            action: SnackBarAction(
                                              label: 'CLOSE',
                                              onPressed:
                                                  scaff.hideCurrentSnackBar,
                                            ),
                                          ));
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  print("Pressed " + e.toString());
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SongsListPage(
                                              songsListName: e,
                                              songsList:
                                                  musicFolderToSongsMap[e],
                                            )),
                                  );
                                },
                                padding: EdgeInsets.all(18.0),
                                color: Colors.white,
                              ),
                            ))
                        .toList())),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SongsListPage extends StatelessWidget {
  SongsListPage({Key key, this.songsListName, this.songsList})
      : super(key: key);
  final String songsListName;
  final List<FileSystemEntity> songsList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => SafeArea(
          child: CustomScrollView(slivers: <Widget>[
            SliverList(
                delegate: SliverChildListDelegate([
              Padding(padding: EdgeInsets.only(top: 24.0)),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        size: 30.0,
                      ),
                      tooltip: 'Back',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 24.0,
                    ),
                  ),
                  Text(songsListName,
                      style: TextStyle(
                        fontSize: 36.0,
                        fontFamily: "SFFlorencesans",
                        letterSpacing: 1.0,
                        foreground: Paint()
                          ..shader = LinearGradient(
                            colors: <Color>[
                              Color(0xffABE9CD),
                              Color(0xaa3EADCF)
                            ],
                          ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                      )),
                  Spacer(flex: 2),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 24.0)),
            ])),
            SliverList(
              delegate: SliverChildListDelegate(songsList
                  .map((e) => Card(
                        margin: EdgeInsets.all(8.0),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                contentPadding: EdgeInsets.all(8.0),
                                leading: IconButton(
                                  icon: Icon(
                                    (playQueue.isPlaying &&
                                            playQueue
                                                .isPlayingSong(Song(e.path)))
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    size: 40.0,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    Song s = Song(e.path);
                                    playQueue.addFirst(s);
                                    playQueue.togglePlayPause();
                                  },
                                ),
                                title: Text(e
                                    .toString()
                                    .substring(0, e.toString().length - 1)
                                    .split("/")
                                    .last
                                    .trim()),
                                subtitle: Text('00 : 00'),
                              ),
                              ButtonBar(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.playlist_add),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.favorite_border),
                                    onPressed: () {
                                      print("Adding " +
                                          e
                                              .toString()
                                              .substring(
                                                  0, e.toString().length - 1)
                                              .split("/")
                                              .last
                                              .trim() +
                                          " to Favorites");
                                      final scaff = Scaffold.of(context);
                                      scaff.showSnackBar(SnackBar(
                                        content: Text("Adding " +
                                            e
                                                .toString()
                                                .substring(
                                                    0, e.toString().length - 1)
                                                .split("/")
                                                .last
                                                .trim() +
                                            " to Favorites"),
                                        duration: Duration(seconds: 1),
                                        action: SnackBarAction(
                                          label: 'CLOSE',
                                          onPressed: scaff.hideCurrentSnackBar,
                                        ),
                                      ));
                                    },
                                  ),
                                ],
                              )
                            ]),
                      ))
                  .toList()),
            )
          ]),
        ),
      ),
    );
  }
}
