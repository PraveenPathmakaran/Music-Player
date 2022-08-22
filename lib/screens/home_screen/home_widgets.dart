// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musicplayer/screens/playlist_screen/screen_playlist.dart';
import '../../functions/audio_functions.dart';
import '../../functions/design_widgets.dart';
import '../../main.dart';
import '../favourite_screen/favourites_functions.dart';
import '../play_screen/screen_play.dart';
import '../splash_screen/screen_splash.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, {bool mounted = true}) {
    loopButton.value = true;
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      color: Colors.black,
      child: SingleChildScrollView(
        child: Column(children: [
          ListView.builder(
            controller: ScrollController(),
            itemBuilder: ((context, index) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                margin: EdgeInsets.all(3),
                color: Color(0xFF14202E),
                child: ListTile(
                    onTap: () async {
                      await createAudiosFileList(allAudioListFromDB);
                      await audioPlayer.playlistPlayAtIndex(index);
                      if (!mounted) return;
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ScreenPlay();
                          },
                        ),
                      );
                      miniPlayerVisibility.value = true;
                    },
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          AssetImage('assets/images/musicIcon1.png'),
                    ),
                    title: Text(
                      allAudioListFromDB[index].title.toString(),
                      maxLines: 1,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    subtitle: Text(
                      allAudioListFromDB[index].artist.toString(),
                      maxLines: 1,
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    trailing: IconButton(
                      icon: functionIcon(Icons.more_vert, 20, Colors.white),
                      onPressed: () {
                        showModalBottomSheet(
                            backgroundColor: appbarColor,
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30),
                              ),
                            ),
                            builder: (ctx) {
                              return SizedBox(
                                height: 300,
                                child: HomeBottomSheet(
                                  id: allAudioListFromDB[index].id.toString(),
                                ),
                              );
                            });
                      },
                    )),
              );
            }),
            itemCount: allAudioListFromDB.length,
            shrinkWrap: true,
          ),
        ]),
      ),
    );
  }
}

class DrawerContent extends StatelessWidget {
  const DrawerContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                functionText('PLAY', whiteColor, FontWeight.bold, 35),
                SizedBox(
                  height: height * 0.01,
                ),
                functionText('Music Player', whiteColor, FontWeight.bold, 25),
                functionSizedBox(0, 50),
                Row(
                  children: [
                    functionTextButton(() {}, 'Notifications'),
                    ValueListenableBuilder(
                        valueListenable: notification,
                        builder: (context, value, child) {
                          return Switch(
                            activeTrackColor: roseColor,
                            activeColor: whiteColor,
                            inactiveTrackColor: Colors.white,
                            value: notification.value,
                            onChanged: ((value) {
                              notification.value = value;
                            }),
                          );
                        })
                  ],
                ),
                functionTextButton(() {}, 'Share'),
                functionTextButton(() {}, 'Privacy Policy'),
                functionTextButton(() {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          titlePadding: EdgeInsets.all(12),
                          title: ListTile(
                            contentPadding: EdgeInsets.all(0),
                            minVerticalPadding: 0,
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.transparent,
                              backgroundImage:
                                  AssetImage('assets/images/musicIcon1.png'),
                            ),
                            title: functionText("Play\nMusic Player",
                                Colors.black, FontWeight.bold, 20),
                            subtitle: Text(
                                "It is a Ad free Music player Play all local storage musics"),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                showLicensePage(context: context);
                              },
                              child: Text("View License"),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Close"))
                          ],
                        );
                      });
                }, 'About'),
                functionTextButton(() {
                  SystemNavigator.pop();
                }, 'Exit'),
              ],
            ),
            Column(
              children: [
                functionText("Version", Colors.white, FontWeight.bold, 15),
                functionText(
                    packageInfo.version, Colors.white, FontWeight.bold, 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HomeBottomSheet extends StatelessWidget {
  final String id;
  const HomeBottomSheet({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
            onPressed: () {
              tempFavouriteList.contains(id)
                  ? favouritesRemove(id)
                  : addFavouritesToDB(id);
              Navigator.pop(context);
              tempFavouriteList.contains(id)
                  ? snackBar("Added to favourites", backgroundColor2, context)
                  : snackBar("Removed Succesfully", backgroundColor2, context);
            },
            child: ValueListenableBuilder(
              valueListenable: favouritesListFromDb,
              builder: (context, value, child) {
                return tempFavouriteList.contains(id)
                    ? functionText(
                        "Favourites Remove", Colors.white, FontWeight.bold, 20)
                    : functionText(
                        "Add to Favourites", Colors.white, FontWeight.bold, 20);
              },
            )),
        TextButton(
          child: functionText(
              "Add to Playist ", Colors.white, FontWeight.bold, 20),
          onPressed: () {
            Navigator.pop(context);
            showModalBottomSheet(
                backgroundColor: appbarColor,
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                builder: (context) {
                  return ScreenAddToPlaylistFromHome(
                    id: id,
                  );
                });
          },
        ),
      ],
    );
  }
}
