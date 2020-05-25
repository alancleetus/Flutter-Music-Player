import 'dart:collection';

import 'package:musicplayer/Song.dart';

/*This is the current list of songs being played*/
class PlayQueue{
  LinkedList<Song> currentPlayQueue = LinkedList<Song>();

  static final PlayQueue _singleton = PlayQueue._internal();
  PlayQueue._internal();

  factory PlayQueue() => _singleton;

  clear() => currentPlayQueue.clear();

  add(Song s) => currentPlayQueue.add(s);
  addList(List<Song> s) => currentPlayQueue.addAll(s);

  playNext(Song s) {
    if(currentPlayQueue.length>1)
      currentPlayQueue.first.insertAfter(s);
    else
      currentPlayQueue.addFirst(s);
  }

  Song getNextSong() => currentPlayQueue.first;

}