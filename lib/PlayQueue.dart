import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/Song.dart';
import 'package:musicplayer/StylesSheet.dart';

import 'package:mp3_info/mp3_info.dart';
import 'package:audiotagger/audiotagger.dart';

/*This is the current list of songs being played*/
class PlayQueue {
  LinkedList<Song> currentPlayQueue = LinkedList<Song>();
  AudioPlayer audioPlayer = new AudioPlayer();

  int currentPosition = -1;

  static final PlayQueue _singleton = PlayQueue._internal();
  PlayQueue._internal();

  factory PlayQueue() => _singleton;

  add(Song s) => {if (currentPlayQueue.contains(s)) currentPlayQueue.add(s)};
  void addFirst(Song s) {
    if (currentPlayQueue.contains(s)) {
      currentPlayQueue.remove(s);
      currentPlayQueue.addFirst(s);
    } else
      currentPlayQueue.addFirst(s);
  }

  void addList(List<Song> s) {
    currentPlayQueue.clear();
    currentPlayQueue.addAll(s);
  }

  addNext(Song s) {
    if (currentPlayQueue.contains(s)) currentPlayQueue.remove(s);

    if (currentPlayQueue.length > 1)
      currentPlayQueue.first.insertAfter(s);
    else
      currentPlayQueue.addFirst(s);
  }

  Song getCurrSong() => currentPlayQueue.first;

  List<Song> getCurrSongQueue() => currentPlayQueue.toList();

  play() async {
    await audioPlayer.play(getCurrSong().url);
    print("Log: playing song = "+getCurrSong().toString());
  }

  pause() async {
    await audioPlayer.pause();
    print("Log: pausing song = "+getCurrSong().toString());
  }

  stop() async {
    await audioPlayer.stop();
  }

  resume() async {
    if(getCurrSongQueue()!= null)
      await audioPlayer.resume();
  }

  clear() => currentPlayQueue.clear();

  Widget CurrentSongView() {
    print(
        "Slideup length of curr queue: " + currentPlayQueue.length.toString());
    if (currentPlayQueue.length < 1)
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Select a song to play",
              style: headingTextStyle,
              textAlign: TextAlign.center,
            ),
          ]);
    return Container(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    currentPlayQueue.first.title,
                    style: headingTextStyle,
                    textAlign: TextAlign.start,
                  ),
                ),
                Spacer(),
                IconButton(
                    icon: Icon(Icons.timer,
                        size: 24.0, color: myColors["grey_light"]),
                    onPressed: () {}),
              ],
            ),
            Slider(
              inactiveColor: myColors["primary"],
              activeColor: myColors["accent"],
              min: 0,
              max: 100,
              value: 50,
              onChanged: (d) {},
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.loop, size: 48.0, color: myColors["icon"]),
                    onPressed: () {}),
                IconButton(
                    icon: Icon(Icons.skip_previous,
                        size: 48.0, color: myColors["icon"]),
                    onPressed: () {}),
                IconButton(
                    icon: (audioPlayer.state == AudioPlayerState.PLAYING)
                        ? Icon(Icons.pause,
                            size: 100.0, color: myColors["icon"])
                        : Icon(Icons.play_arrow,
                            size: 100.0, color: myColors["icon"]),
                    onPressed: () {
                      (audioPlayer.state == AudioPlayerState.PLAYING)
                          ? audioPlayer.pause()
                          : audioPlayer.resume();
                    }),
                IconButton(
                    icon: Icon(Icons.skip_next,
                        size: 48.0, color: myColors["icon"]),
                    onPressed: () {}),
                IconButton(
                    icon: Icon(Icons.shuffle,
                        size: 48.0, color: myColors["icon"]),
                    onPressed: () {}),
              ],
            ),
          ],
        ));
  }
}
