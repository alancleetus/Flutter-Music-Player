import 'dart:collection';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class Song extends LinkedListEntry<Song>{
  String title;
  String url;
  int duration;
  List<String> tags;

  AudioPlayer ap = new AudioPlayer();

  Song(String Url){
    this.url = Url;
    this.title = Url.substring(0,Url.length-1).split("/").last.trim();
    //this.duration = ap.getDuration();
    //todo: get duration using flute_music_player plugin
  }
  //todo: add widget code
  Widget getCard() { return Text(title);}
}