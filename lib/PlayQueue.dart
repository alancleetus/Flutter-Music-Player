import 'dart:collection';
import 'package:audioplayers/audioplayers.dart';
import 'package:musicplayer/Song.dart';

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
    if (currentPlayQueue.contains(s))
      currentPlayQueue.remove(s);

    if (currentPlayQueue.length > 1)
      currentPlayQueue.first.insertAfter(s);
    else
      currentPlayQueue.addFirst(s);
  }

  Song getCurrSong() => currentPlayQueue.first;

  List<Song> getCurrSongQueue() => currentPlayQueue.toList();

  play() async {
    await audioPlayer.play(getCurrSong().url);
  }

  pause() async {
    await audioPlayer.pause();
  }

  stop() async {
    await audioPlayer.stop();
  }

  clear() => currentPlayQueue.clear();
}
