import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:musicplayer/Song.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:musicplayer/FileIO.dart';
import 'package:musicplayer/PlayQueue.dart';
import 'package:musicplayer/StylesSheet.dart';
import 'package:musicplayer/SongsPageView.dart';
import 'package:musicplayer/States.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

IsPlaying isPlayingService = IsPlaying();
CurrentSong currentSongService = CurrentSong();
PlayQueue playQueue = PlayQueue();

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
      debugShowCheckedModeBanner: false,
      /*theme: ThemeData(
        primaryColor: Colors.black,
      ),*/
      home: MyHomePage(),
    );
  }
}


class MyHomePage extends StatelessWidget {

  LinkedHashMap folders = LinkedHashMap<String, List<Song>>();
  LinkedHashMap playlists = LinkedHashMap<String, List<Song>>();
  LinkedHashMap albums = LinkedHashMap<String, List<Song>>();

  void getFolders(){

    List<FileSystemEntity> allMusicDirs = getAllMusicDirs();
    //print("allMusicDirs: "+ allMusicDirs.toList().toString());
    folders["All Songs"] =
        getAllSongsInDirectory("/storage/emulated/0/Music/");
    for (FileSystemEntity fse in allMusicDirs) {
      String folderName = fse.path.split('/').last.toString();
      //print("Getting songs in /Music/"+folderName);
      List<Song> songsList = getAllSongsInDirectory(fse.path);
      if (songsList.length > 0) folders[folderName] = songsList;
    }

    print("Log: main.dart() - playlists.keys: " + folders.keys.toList().toString());
  }

  @override
  Widget build(BuildContext context) {

    getFolders();

    return Scaffold(
      backgroundColor: myColors["primary_dark"],
      body: Builder(
        builder: (context) => SafeArea(
          child: SlidingUpPanel(
            maxHeight: MediaQuery.of(context).size.height,
            panel: Container(
                color: myColors["primary_light"],
                child: playQueue.CurrentSongView()),
            collapsed: Container(
              color: myColors["primary_light"],
              padding: EdgeInsets.only(bottom: 12.0),
              child: Container(
                color: myColors["primary_light"],
                child: Column(
                  //todo: check is song playing
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.play_arrow,
                                  size: 45.0, color: myColors["icon"]),
                              onPressed: () {}),
                          Expanded(
                              child: Column(
                            children: <Widget>[
                              Text(
                                "Pick a Song",
                                style: TextStyle(
                                    color: myColors["text"], fontSize: 14.0),
                              ),
                              Slider(
                                inactiveColor: myColors["primary"],
                                activeColor: myColors["accent"],
                                min: 0,
                                max: 100,
                                value: 50,
                                onChanged: (d) {},
                              ),
                            ],
                          )),
                          IconButton(
                              icon: Icon(Icons.keyboard_arrow_up,
                                  size: 45.0, color: myColors["icon"]),
                              onPressed: () {
                                print("Log: main.dart() - Clicked show current play list");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SongsListPage(
                                          songsListName: "Current Playlist",
                                          songsList:
                                              playQueue.getCurrSongQueue()),
                                    ));
                              }),
                        ]),
                  ],
                ),
              ),
            ),
            body: Center(
              child: Container(
                padding: EdgeInsets.only(
                    top: 24.0, right: 24.0, left: 24.0, bottom: 130.0),
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverList(
                        delegate: SliverChildListDelegate([
                      Row(children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.menu,
                            color: Colors.white,
                            size: 28.0,
                          ),
                          onPressed: () {},
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 28.0,
                          ),
                          onPressed: () {},
                        ),
                      ]),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        textBaseline: TextBaseline.alphabetic,
                        children: <Widget>[
                          Icon(Icons.folder_open,
                              size: 50.0, color: myColors["icon"]),
                          Padding(
                            padding: EdgeInsets.only(right: 12.0),
                          ),
                          Text("Folders", style: headingTextStyle),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 24.0),
                      ),
                    ])),
                    SliverList(
                        delegate: SliverChildListDelegate(folders.keys
                            .map((folderName) => playListCardWidget(
                                folderName, folders[folderName], context))
                            .toList())),
                    SliverList(
                        delegate: SliverChildListDelegate([
                      Padding(
                        padding: EdgeInsets.only(top: 48.0),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        textBaseline: TextBaseline.alphabetic,
                        children: <Widget>[
                          Icon(Icons.featured_play_list,
                              size: 50.0, color: myColors["icon"]),
                          Padding(
                            padding: EdgeInsets.only(right: 12.0),
                          ),
                          Text("Playlists", style: headingTextStyle),
                          Spacer(),
                          Icon(Icons.playlist_add,
                              size: 25.0, color: myColors["accent"]),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 24.0),
                      ),
                    ])),
                    SliverList(
                        delegate: SliverChildListDelegate(playlists.keys
                            .map((playlistName) => playListCardWidget(
                                playlistName, playlists[playlistName], context))
                            .toList())),
                    SliverList(
                        delegate: SliverChildListDelegate([
                      Padding(
                        padding: EdgeInsets.only(top: 48.0),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        textBaseline: TextBaseline.alphabetic,
                        children: <Widget>[
                          Icon(Icons.album,
                              size: 50.0, color: myColors["icon"]),
                          Padding(
                            padding: EdgeInsets.only(right: 12.0),
                          ),
                          Text("Albums", style: headingTextStyle),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 24.0),
                      ),
                      ])),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

GestureDetector playListCardWidget(
    String playlistName, List<Song> playlist, var context) {
  return GestureDetector(
    onTap: () {
      print("Log: main.dart() - Pressed " + playlistName.toString());
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                SongsListPage(songsListName: playlistName, songsList: playlist),
          ));
    },
    child: Container(
      padding: EdgeInsets.all(12.0),
      margin: EdgeInsets.only(bottom: 18.0),
      decoration: BoxDecoration(
        color: myColors["primary"],
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                playlistName,
                style: subHeadingTextStyle,
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.music_note,
                    size: 15.0,
                    color: myColors["accent"],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5.0),
                  ),
                  Text(
                    playlist.length.toString(),
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: myColors["text"],
                    ),
                  ),
                  Text(
                    (playlist.length > 1) ? " songs" : " song",
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w300,
                      color: myColors["text"],
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
              color: myColors["icon"],
              icon: Icon(Icons.shuffle, size: 30.0),
              onPressed: () {
                print("Log: main.dart() - Shuffling " +
                    playlistName.toString().toUpperCase() +
                    " folder");
                final scaff = Scaffold.of(context);
                scaff.showSnackBar(SnackBar(
                  content: Text("Shuffling " +
                      playlistName.toString().toUpperCase() +
                      " folder"),
                  duration: Duration(seconds: 1),
                  action: SnackBarAction(
                    label: 'CLOSE',
                    onPressed: scaff.hideCurrentSnackBar,
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
              color: myColors["icon"],
              icon: Icon(Icons.playlist_play, size: 40.0),
              onPressed: () {
                print("Log: main.dart() - Playing " +
                    playlistName.toString().toUpperCase() +
                    " folder");

                final scaff = Scaffold.of(context);
                scaff.showSnackBar(SnackBar(
                  content: Text("Playing " +
                      playlistName.toString().toUpperCase() +
                      " folder"),
                  duration: Duration(seconds: 1),
                  action: SnackBarAction(
                    label: 'CLOSE',
                    onPressed: scaff.hideCurrentSnackBar,
                  ),
                ));
              },
            ),
          ),
        ],
      ),
    ),
  );
}
