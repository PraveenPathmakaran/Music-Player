import 'package:flutter/material.dart';
import 'package:musicplayer/screens/splash_screen/screen_splash.dart';
import '../../functions/audio_functions.dart';
import '../../functions/design_widgets.dart';
import '../home_screen/home_widgets.dart';
import '../play_screen/screen_play.dart';
import '../playlist_screen/screen_playlist_songs.dart';

bool favouritesAudioListUpdate = false; //favourite list remove option

class ScreenFavourite extends StatelessWidget {
  const ScreenFavourite({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, {bool mounted = true}) {
    return ValueListenableBuilder(
      valueListenable: favouritesListFromDb,
      builder: (context, value, child) {
        return favouritesListFromDb.value.isEmpty
            ? Container(
                color: Colors.black,
                child: Center(
                  child: functionText(
                      "No Songs Found", Colors.white, FontWeight.bold, 20),
                ),
              )
            : Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                color: Colors.black,
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
                              favouritesListFromDb.value);
                          await audioPlayer.playlistPlayAtIndex(index);
                          if (!mounted) return;
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const ScreenPlay();
                              },
                            ),
                          );
                          miniPlayerVisibility.value = true;
                          favouritesAudioListUpdate = true;
                          playlistAudioListUpdate = false;
                        },
                        leading: const CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.transparent,
                          backgroundImage:
                              AssetImage('assets/images/songicon.png'),
                        ),
                        title: Text(
                          favouritesListFromDb.value[index].title.toString(),
                          maxLines: 1,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                        ),
                        subtitle: Text(
                          favouritesListFromDb.value[index].artist.toString(),
                          maxLines: 1,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 10),
                        ),
                        trailing: IconButton(
                          icon: functionIcon(Icons.more_vert, 20, Colors.white),
                          onPressed: () async {
                            showModalBottomSheet(
                                backgroundColor: appbarColor,
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(30),
                                  ),
                                ),
                                builder: (ctx) {
                                  return SizedBox(
                                    height: 300,
                                    child: HomeBottomSheet(
                                      id: favouritesListFromDb.value[index].id
                                          .toString(),
                                      index: index,
                                    ),
                                  );
                                });
                          },
                        ),
                      ),
                    );
                  }),
                  itemCount: favouritesListFromDb.value.length,
                  shrinkWrap: true,
                ),
              );
      },
    );
  }
}
