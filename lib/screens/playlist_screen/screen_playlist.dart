// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:musicplayer/db/db_functions.dart';
import 'package:musicplayer/functions/design_widgets.dart';
import 'package:musicplayer/main.dart';
import 'package:musicplayer/screens/playlist_screen/playlist_functions.dart';
import 'package:musicplayer/screens/playlist_screen/playlist_widgets.dart';
import 'package:musicplayer/screens/playlist_screen/screen_playlist_songs.dart';

import '../play_screen/screen_play.dart';

ScrollController controller1 = ScrollController();

class ScreenPlaylist extends StatelessWidget {
  const ScreenPlaylist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    keyUpdate();
    loopButton.value = true;
    return ValueListenableBuilder(
      valueListenable: allkey,
      builder: (context, value, child) {
        return Container(
          padding: EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: allkey.value.length,
            itemBuilder: ((context, index) {
              return Container(
                height: 80,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: colorListTile,
                  child: Center(
                    child: ListTile(
                      onTap: (() {
                        getPlaylistSongs(allkey.value[index].toString());
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: ((context) {
                              return ScreenPlaylistAudios(
                                playlistname: allkey.value[index].toString(),
                              );
                            }),
                          ),
                        );
                      }),
                      leading: Icon(
                        Icons.playlist_play,
                        color: Colors.white,
                        size: 35,
                      ),
                      title: functionText(allkey.value[index].toString(),
                          Colors.white, FontWeight.normal, 20),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          findPlaylistCount(allkey.value[index].toString()),
                          IconButton(
                            icon:
                                functionIcon(Icons.more_vert, 20, Colors.white),
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
                                  return Container(
                                    height: 300,
                                    child: Column(
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              playlistDelete(allkey.value[index]
                                                  .toString());
                                              snackBar("Removed Successfully",
                                                  backgroundColor2, context);
                                              Navigator.pop(context);
                                            },
                                            child: functionText(
                                                "Delete Playlist",
                                                Colors.white,
                                                FontWeight.bold,
                                                20)),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

class ScreenAddToPlaylistFromHome extends StatelessWidget {
  final String id;

  const ScreenAddToPlaylistFromHome({Key? key, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    keyUpdate();
    return ValueListenableBuilder(
      valueListenable: allkey,
      builder: (context, value, child) {
        return ListView(
          children: [
            Column(
              children: [
                TextButton.icon(
                    onPressed: () {
                      openDialog(context);
                    },
                    icon: Icon(
                      Icons.playlist_add_circle_sharp,
                      color: Colors.white,
                    ),
                    label: functionText(
                        "Playlist Create", Colors.white, FontWeight.bold, 20))
              ],
            ),
            ListView.builder(
              controller: controller1,
              shrinkWrap: true,
              itemCount: allkey.value.length,
              itemBuilder: ((context, index) {
                return ListTile(
                  onTap: (() {
                    if (tempPlaylistId.contains(id)) {
                      Navigator.pop(context);
                      return snackBar("Song already added to playlists",
                          Colors.red, context);
                    }
                    getPlaylistSongs(allkey.value[index].toString());
                    addtoPlaylistSongs(id, allkey.value[index].toString());
                    Navigator.pop(context);
                    snackBar(
                        "Song added to playlists", backgroundColor2, context);
                  }),
                  leading: Icon(
                    Icons.playlist_play,
                    color: Colors.white,
                    size: 35,
                  ),
                  title: functionText(allkey.value[index].toString(),
                      Colors.white, FontWeight.normal, 20),
                );
              }),
            ),
          ],
        );
      },
    );
  }
}

Widget findPlaylistCount(String playlistname) {
  final value = playlistDB.get(playlistname);

  return Center(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        color: Colors.black,
      ),
      padding: EdgeInsets.all(7),
      width: 30,
      height: 30,
      child: Text(
        value!.length.toString(),
        style: TextStyle(
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );
}
