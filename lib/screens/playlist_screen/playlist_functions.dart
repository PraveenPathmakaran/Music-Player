// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:musicplayer/functions/audio_functions.dart';

import '../../db/db_functions.dart';
import '../../main.dart';
import '../splash_screen/screen_splash.dart';
import 'screen_playlist_songs.dart';

Future<void> keyUpdate() async {
  allkey.value.clear();
  final allkey1 = playlistDB.keys.toList();
  allkey.value = allkey1;
  allkey.notifyListeners();
}

Future<void> playlistCreation(String key) async {
  bool keys = playlistDB.containsKey(key);
  if (keys) {
    return;
  }
  List<String> emptyList = [];
  await playlistDB.put(key, emptyList);
  allkey.notifyListeners();
}

Future<void> playlistDelete(String playlistname) async {
  playlistDB.delete(playlistname);
  keyUpdate();
}

Future<void> addtoPlaylistSongs(String id, String playlistname) async {
  if (tempPlaylistId.contains(id)) {
    return;
  }
  tempPlaylistId.add(id);
  await playlistDB.put(playlistname, tempPlaylistId);
  getPlaylistSongs(playlistname);
}

Future<void> getPlaylistSongs(String playlistname) async {
  tempPlaylistId = playlistDB.get(playlistname)!;

  playlistSongsFromDB.value = allAudioListFromDB.where((element) {
    return tempPlaylistId.contains(element.id);
  }).toList();
  playlistSongsFromDB.value.sort(
    (a, b) => a.title!.compareTo(b.title!),
  );
}

Future<void> playlistSongDelete(String id, String playlistname) async {
  tempPlaylistId.remove(id);
  playlistDB.put(playlistname, tempPlaylistId);
  await getPlaylistSongs(playlistname);
  playlistSongsFromDB.notifyListeners();
  await keyUpdate();
}

Future<void> playlistNameUpdate(
    String playlistname, String newplaylistname) async {
  List<String>? tempList = playlistDB.get(playlistname);
  tempList ??= [];
  await playlistDB.put(newplaylistname, tempList);
  await playlistDelete(playlistname);
  await keyUpdate();
}
