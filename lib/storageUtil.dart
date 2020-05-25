import 'dart:io';

/*This function gets the name of all files and directories in the /Music folder*/
List<FileSystemEntity> getAllMusicDirs() {
  Directory musicDir = Directory("/storage/emulated/0/Music/");
  List<FileSystemEntity> fsList =
  musicDir.listSync(recursive: false, followLinks: false);

  //print("fsList: "+fsList.where((entity)=> entity is Directory ).toList().toString());

  return fsList.where((entity) => entity is Directory).toList();
}

List<FileSystemEntity> getAllSongsInDirectory(String dirPath) {
  List<FileSystemEntity> mp3List =
  Directory(dirPath).listSync(recursive: true, followLinks: false);
  //print("Songs in "+dirPath+": "+mp3List.where((mp3)=> mp3.path.toString().endsWith(".mp3")).toList().toString());
  return mp3List.where((mp3) => mp3.path.toString().endsWith(".mp3")).toList();
}