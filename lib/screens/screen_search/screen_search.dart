// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:musicplayer/functions/audio_functions.dart';

import '../../functions/design_widgets.dart';
import '../home_screen/home_widgets.dart';
import '../play_screen/screen_play.dart';
import '../splash_screen/screen_splash.dart';

class MusicSearch extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    final suggetionList = allAudioListFromDB
        .where((element) =>
            element.title!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return Container(
      color: Colors.black,
      padding: EdgeInsets.all(10),
      child: ListView.builder(
        itemCount: suggetionList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: colorListTile,
            child: ListTile(
              leading: const CircleAvatar(
                radius: 25,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage('assets/images/musicIcon1.png'),
              ),
              title: Text(
                suggetionList[index].title.toString(),
                maxLines: 1,
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              subtitle: Text(
                suggetionList[index].artist.toString(),
                maxLines: 1,
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
              trailing: IconButton(
                icon: functionIcon(Icons.more_horiz, 20, Colors.white),
                onPressed: () {
                  showModalBottomSheet(
                      backgroundColor: backgroundColor2,
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      builder: (ctx) {
                        return HomeBottomSheet(
                          id: suggetionList[index].id.toString(),
                        );
                      });
                },
              ),
              onTap: () async {
                await createAudiosFileList(allAudioListFromDB);
                final index1 = allAudioListFromDB.indexWhere((element) =>
                    element.id == suggetionList[index].id.toString());

                if (index1 >= 0) {
                  audioPlayer.playlistPlayAtIndex(index1);
                  // ignore: use_build_context_synchronously
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const ScreenPlay();
                      },
                    ),
                  );
                  miniPlayerVisibility.value = true;
                }
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggetionList = allAudioListFromDB
        .where((element) =>
            element.title!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return suggetionList.isEmpty
        ? Container(
            color: Colors.black,
            child: Center(
              child: Text(
                'No Results Found',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        : Container(
            color: Colors.black,
            padding: EdgeInsets.all(10),
            child: ListView.builder(
              itemCount: suggetionList.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: colorListTile,
                  child: ListTile(
                    leading: const CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          AssetImage('assets/images/musicIcon1.png'),
                    ),
                    title: Text(
                      suggetionList[index].title.toString(),
                      maxLines: 1,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    subtitle: Text(
                      suggetionList[index].artist.toString(),
                      maxLines: 1,
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    trailing: IconButton(
                      icon: functionIcon(Icons.more_horiz, 20, Colors.white),
                      onPressed: () {
                        showModalBottomSheet(
                            backgroundColor: backgroundColor2,
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30),
                              ),
                            ),
                            builder: (ctx) {
                              return HomeBottomSheet(
                                id: suggetionList[index].id.toString(),
                              );
                            });
                      },
                    ),
                    onTap: () async {
                      await createAudiosFileList(allAudioListFromDB);
                      final index1 = allAudioListFromDB.indexWhere((element) =>
                          element.id == suggetionList[index].id.toString());

                      if (index1 >= 0) {
                        audioPlayer.playlistPlayAtIndex(index1);
                        // ignore: use_build_context_synchronously
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const ScreenPlay();
                            },
                          ),
                        );
                        miniPlayerVisibility.value = true;
                      }
                    },
                  ),
                );
              },
            ),
          );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: AppBarTheme(backgroundColor: appbarColor),
      textTheme: const TextTheme(headline6: TextStyle(color: Colors.white)),
      hintColor: Colors.white,
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(color: Colors.white),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent)),
      ),
    );
  }
}