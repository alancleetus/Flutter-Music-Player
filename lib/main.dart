import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'storageUtil.dart';
import 'package:musicplayer/PlayQueue.dart';

void main() {
  getPermissions();
  runApp(MyApp());
}

/*This function gets the nevessary read/write permission*/
Future<void> getPermissions() async {
  try {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  } catch (e) {
    print(e);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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

  Container musicFolderCard(String txt){
    return Container(
      child: Material(
        child: InkWell(
          child: Center(
            child: Text(
              txt.toString().toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.0,
                fontFamily: "Raleway",
              ),
            ),
          ),
          onTap: () => {
            print("tapped " + txt.toString())
            //todo: open page with list of songs in folder
          },
          borderRadius: BorderRadius.all(Radius.circular(18.0)),
        ),
        color:Colors.transparent,
      ),
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(  Radius.circular(18.0)),
        color: Colors.white,
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
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: GridView.count(
            crossAxisCount: 2,
            padding: EdgeInsets.all(8.0),
            children: musicFolderToSongsMap.keys
                .map((e) => musicFolderCard(e)).toList()
            //musicFolderToSongsMap.keys.map((item) => new Text(item)).toList(),
            ),
      ),
    );
  }
}
