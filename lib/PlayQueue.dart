import 'dart:collection';

import 'package:audioplayers/audioplayers.dart';
import 'package:musicplayer/Song.dart';

/*This is the current list of songs being played*/
class PlayQueue{
  bool isPlaying = false;
  LinkedList<Song> currentPlayQueue = LinkedList<Song>();
  Song currentSong;
  AudioPlayer audioPlayer = new AudioPlayer();

  static final PlayQueue _singleton = PlayQueue._internal();
  PlayQueue._internal();

  factory PlayQueue() => _singleton;

  clear() => currentPlayQueue.clear();

  add(Song s) => currentPlayQueue.add(s);
  addFirst(Song s) => currentPlayQueue.addFirst(s);
  addList(List<Song> s) => currentPlayQueue.addAll(s);
  addNext(Song s) {
    if(currentPlayQueue.length>1)
      currentPlayQueue.first.insertAfter(s);
    else
      currentPlayQueue.addFirst(s);
  }

  Song getNextSong() => currentPlayQueue.first;

  play(){
    if(currentPlayQueue.length>0) {
      currentSong = getNextSong();
      audioPlayer.play(getNextSong().url);
      isPlaying = true;
    }
  }
  pause(){
    if(isPlaying)
      audioPlayer.pause();
      isPlaying = false;
  }
  stop(){currentPlayQueue = null;}

  togglePlayPause(){
    if(currentSong == currentPlayQueue.first)
      (isPlaying) ? pause(): play();
    else
      play();
  }

  bool isPlayingSong(s) => (s==currentSong);

}