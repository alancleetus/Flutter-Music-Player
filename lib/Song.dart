import 'dart:collection';

import 'package:flutter/material.dart';

class Song extends LinkedListEntry<Song>{
  String title;
  String URI;
  String duration;
  List<String> tags;

  Song(this.title, this.URI, this.duration, this.tags);

  //todo: add widget code
  Widget getCard() { return Text(title);}
}