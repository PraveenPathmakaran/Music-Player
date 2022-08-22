// ignore_for_file: prefer_const_constructors
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/screens/playlist_screen/screen_add_to_playlist.dart';
import '../../functions/audio_functions.dart';
import '../../functions/design_widgets.dart';
import '../../model/music_model.dart';
import '../favourite_screen/favourites_functions.dart';
import '../play_screen/screen_play.dart';
import '../splash_screen/screen_splash.dart';
import 'playlist_functions.dart';

ValueNotifier<List<MusicModel>> playlistSongsFromDB = ValueNotifier([]);
List<String> tempPlaylistId = [];

class ScreenPlaylistAudios extends StatelessWidget {
  final String playlistname;
  const ScreenPlaylistAudios({Key? key, required this.playlistname})
      : super(key: key);

  @override
  Widget build(BuildContext context, {bool mounted = true}) {
    loopButton.value = true;
    return ValueListenableBuilder(
        valueListenable: miniPlayerVisibility,
        builder: (context, value, child) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: appbarColor,
              elevation: 0,
              title: Text(playlistname),
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton(
                backgroundColor: appbarColor,
                onPressed: (() {
                  showModalBottomSheet(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      context: context,
                      builder: (context) {
                        return SreenAddToPlaylist(
                          playlistname: playlistname,
                        );
                      });
                }),
                child: functionIcon(Icons.add, 15, Colors.white)),
            body: ValueListenableBuilder(
                valueListenable: playlistSongsFromDB,
                builder: (context, value, child) {
                  return Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: ListView.builder(
                      controller: ScrollController(),
                      itemBuilder: ((context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: colorListTile,
                          child: ListTile(
                            onTap: () async {
                              await createAudiosFileList(
                                  playlistSongsFromDB.value);
                              await audioPlayer.playlistPlayAtIndex(index);
                              if (!mounted) return;
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return ScreenPlay();
                                }),
                              );
                              miniPlayerVisibility.value = true;
                            },
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.transparent,
                              backgroundImage:
                                  AssetImage('assets/images/songicon.png'),
                            ),
                            title: Text(
                              playlistSongsFromDB.value[index].title.toString(),
                              maxLines: 1,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            subtitle: Text(
                              playlistSongsFromDB.value[index].artist
                                  .toString(),
                              maxLines: 1,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
                            ),
                            trailing: IconButton(
                              icon: functionIcon(
                                  Icons.more_vert, 25, Colors.white),
                              onPressed: () {
                                showModalBottomSheet(
                                  backgroundColor: appbarColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(30),
                                    ),
                                  ),
                                  context: context,
                                  builder: (context) {
                                    return SizedBox(
                                      height: 300,
                                      child: Column(
                                        children: [
                                          TextButton(
                                              onPressed: () {
                                                playlistSongDelete(
                                                    playlistSongsFromDB
                                                        .value[index].id
                                                        .toString(),
                                                    playlistname);

                                                snackBar(
                                                    "Removed From Favourites",
                                                    backgroundColor2,
                                                    context);
                                                Navigator.pop(context);
                                              },
                                              child: functionText(
                                                  "Remove",
                                                  Colors.white,
                                                  FontWeight.bold,
                                                  20)),
                                          TextButton(
                                              onPressed: () {
                                                tempFavouriteList.contains(
                                                        playlistSongsFromDB
                                                            .value[index].id
                                                            .toString())
                                                    ? favouritesRemove(
                                                        playlistSongsFromDB
                                                            .value[index].id
                                                            .toString())
                                                    : addFavouritesToDB(
                                                        playlistSongsFromDB
                                                            .value[index].id
                                                            .toString());
                                                Navigator.pop(context);
                                                tempFavouriteList.contains(
                                                        playlistSongsFromDB
                                                            .value[index].id
                                                            .toString())
                                                    ? snackBar(
                                                        "Added to favourites",
                                                        backgroundColor2,
                                                        context)
                                                    : snackBar(
                                                        "Removed Succesfully",
                                                        backgroundColor2,
                                                        context);
                                              },
                                              child: ValueListenableBuilder(
                                                valueListenable:
                                                    favouritesListFromDb,
                                                builder:
                                                    (context, value, child) {
                                                  return tempFavouriteList
                                                          .contains(
                                                              playlistSongsFromDB
                                                                  .value[index]
                                                                  .id
                                                                  .toString())
                                                      ? functionText(
                                                          "Favourites Remove",
                                                          Colors.white,
                                                          FontWeight.bold,
                                                          20)
                                                      : functionText(
                                                          "Add to Favourites",
                                                          Colors.white,
                                                          FontWeight.bold,
                                                          20);
                                                },
                                              ))
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        );
                      }),
                      itemCount: playlistSongsFromDB.value.length,
                      shrinkWrap: true,
                    ),
                  );
                }),
            bottomNavigationBar: miniPlayer(context),
          );
        });
  }
}
