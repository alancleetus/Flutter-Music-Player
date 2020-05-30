import 'package:audioplayers/audioplayers.dart';
import 'package:rxdart/rxdart.dart';
import 'package:musicplayer/Song.dart';

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