import 'dart:collection';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:mp3_info/mp3_info.dart';
import 'package:audiotagger/audiotagger.dart';

import 'package:flutter_plugin_playlist/flutter_plugin_playlist.dart';

class Song extends LinkedListEntry<Song> {
  String title, artist, album, year, comment, genre, lyrics;
  var art;
  String url;
  Duration duration;
  List<String> tags;

  AudioTrack audioTrack;

  AudioPlayer ap = new AudioPlayer();
  Audiotagger tagger = new Audiotagger();

  Song(String url) {
    this.url = url;

    try {
      getMetadata(url);
    } catch (e) {
      print("Unable to get mp3 title " + e);
      this.title = url.split("/").last.split(".").first.trim();
    }

    this.audioTrack = new AudioTrack(
        album: (this.album != null)?this.album:"",
        artist: (this.artist != null)?this.artist:"",
        assetUrl: (this.url != null)?this.url:"",
        title: (this.title != null)?this.title:"",);
  }

  void getMetadata(url) async {
    final output = await tagger.readTagsAsMap(
      path: url,
    );

    this.title = ""+output['title'];
    if (this.title.length < 1)
      this.title = ""+url.split("/").last.split(".").first.trim();
    this.artist = ""+output['artist'];
    this.album = ""+output['album'];
    this.genre = ""+output['genre'];
    this.comment = ""+output['comment'];
    this.lyrics = ""+output['lyrics'];
    this.year = ""+output['year'];
    //print("Log: audio tagger = $output");

    try {
      MP3Info mp3 = MP3Processor.fromFile(File(url));
      this.duration = mp3.duration;
    }catch(e){
      print("Log: Song.dart() - error getting MP3Info for url = $url");
      print(e);
      this.duration = Duration(seconds: 0);
    }
    //print("Log: audio duration = " + mp3.duration.toString());
  }

  //todo: add widget code
  Widget getCard() {
    return Text(title);
  }

  @override
  String toString() {
    return 'Song{title: $title, artist: $artist, album: $album, year: $year, comment: $comment, genre: $genre, lyrics: $lyrics, url: $url, duration: $duration}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Song && url == other.url;
}
