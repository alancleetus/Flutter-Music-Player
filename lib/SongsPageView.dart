import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/StylesSheet.dart';
import 'package:musicplayer/States.dart';
import 'package:musicplayer/Song.dart';
import 'package:musicplayer/PlayQueue.dart';

IsPlaying isPlayingService = IsPlaying();
CurrentSong currentSongService = CurrentSong();
PlayQueue playQueue = PlayQueue();

class SongsListPage extends StatelessWidget {
  SongsListPage({Key key, this.songsListName, this.songsList})
      : super(key: key);

  final String songsListName;
  final List<Song> songsList;

  int songCounter = 1;

  Container SongCard(Song song, String songCount, var context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      margin: EdgeInsets.only(left: 24.0, right: 24.0, bottom: 18.0),
      decoration: BoxDecoration(
        color: myColors["primary"],
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
     Container(
       padding: EdgeInsets.only(left:8.0, right: 10.0, top: 5.0),
       child: StreamBuilder(
              stream: isPlayingService.stream$,
              builder: (BuildContext context, AsyncSnapshot isPlayingSnap) =>
                  StreamBuilder(
                stream: currentSongService.stream$,
                builder: (BuildContext context, AsyncSnapshot currentSongSnap) =>
                    Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                          child: Container(
                        child:
                            (currentSongSnap.data == song && isPlayingSnap.data)
                                ? Icon(
                                    Icons.pause,
                                    size: 40.0,
                                    color: myColors["grey_light"],
                                  )
                                : Text(
                                    songCount,
                                    style: TextStyle(
                                      color: myColors["grey_light"],
                                    ),
                                  ),
                        height: 50.0,
                        width: 50.0,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: myColors["primary_dark"],
                        ),
                      )),
                      onTap: () {
                        Song s = song;
                        if (isPlayingSnap.data && currentSongSnap.data == s) {
                          playQueue.pause();
                          isPlayingService.set(false);
                          print("Pausing song: " + s.toString());
                        } else {
                          playQueue.addFirst(s);
                          playQueue.play();
                          isPlayingService.set(true);
                          currentSongService.set(playQueue.getCurrSong());
                          print("Playing song: " + s.toString());
                        }
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 24.0),
                    ),
                    Expanded(
                      child: Text(
                        song.title,
                        style: TextStyle(
                          color: myColors["text"],
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 24.0),
                    ),
                    Text(
                      '00 : 00',
                      style: TextStyle(color: myColors["grey_light"]),
                    ),
                  ],
                ),
              ),
            ),
     ),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.playlist_add,
                  size: 24.0, color: myColors["grey_light"]),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.favorite_border,
                size: 24.0,
                color: myColors["accent_red_light"],
              ),
              onPressed: () {
                print("Adding " + song.title + " to Favorites");
                final scaff = Scaffold.of(context);
                scaff.showSnackBar(SnackBar(
                  content: Text("Adding " + song.title + " to Favorites"),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => SafeArea(
          child: CustomScrollView(slivers: <Widget>[
            SliverAppBar(
              title:
                  Text(songsListName.toUpperCase(), style: subHeadingTextStyle),
              iconTheme: IconThemeData(color: myColors['icon']),
              backgroundColor: myColors["primary"],
              pinned: true,
            ),
            SliverPadding(padding: EdgeInsets.only(bottom: 24.0),),
            SliverList(
              delegate: SliverChildListDelegate( songsList
                  .map((e) => SongCard(e, (songCounter++).toString().padLeft(2, '0'), context))
                  .toList()),
            ),
            SliverPadding(padding: EdgeInsets.only(bottom: 24.0),)
          ]),
        ),
      ),
      backgroundColor: myColors["primary_dark"],
    );
  }
}
