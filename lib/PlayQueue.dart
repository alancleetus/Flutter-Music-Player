import 'dart:collection';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:musicplayer/Song.dart';

import 'package:rxdart/rxdart.dart';

class IsPlaying {

  BehaviorSubject _isPlaying = BehaviorSubject.seeded(false);

  Stream get stream$ => _isPlaying.stream;
  bool get current => _isPlaying.value;

  set(bool b) {
    _isPlaying.add(b);
  }

  toggle() {
    _isPlaying.add(!current);
  }

}

class CurrentSong {
  BehaviorSubject _currentSong = BehaviorSubject.seeded(null);

  Stream get stream$ => _currentSong.stream;
  Song get current => _currentSong.value;

  void set(Song s) {
    _currentSong.add(s);
  }

  void clear() {
    _currentSong.add(null);
  }
}

/*This is the current list of songs being played*/
class PlayQueue {
  LinkedList<Song> currentPlayQueue = LinkedList<Song>();
  AudioPlayer audioPlayer = new AudioPlayer();

  static final PlayQueue _singleton = PlayQueue._internal();
  PlayQueue._internal();

  factory PlayQueue() => _singleton;

  clear() => currentPlayQueue.clear();

  add(Song s) => currentPlayQueue.add(s);
  addFirst(Song s) => currentPlayQueue.addFirst(s);
  addList(List<Song> s) => currentPlayQueue.addAll(s);
  addNext(Song s) {
    if (currentPlayQueue.length > 1)
      currentPlayQueue.first.insertAfter(s);
    else
      currentPlayQueue.addFirst(s);
  }

  Song getCurrSong() => currentPlayQueue.first;

  play() {
    audioPlayer.play(getCurrSong().url);
  }

  pause() {
    audioPlayer.pause();
  }

  stop() {
    currentPlayQueue = null;
  }
}
