// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../../functions/audio_functions.dart';
import '../../functions/design_widgets.dart';
import '../splash_screen/screen_splash.dart';
import 'favourites_functions.dart';
import 'screen_favourite.dart';

bool addfavouriteScreenAudioListUpdation = true;

class ScreenAddToFavourits extends StatelessWidget {
  const ScreenAddToFavourits({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            ValueListenableBuilder(
                valueListenable: favouritesListFromDb,
                builder: (context, value, child) {
                  return ListView.builder(
                    controller: ScrollController(),
                    itemBuilder: ((context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: colorListTile,
                        child: ListTile(
                          onTap: () async {
                            if (addfavouriteScreenAudioListUpdation) {
                              await createAudiosFileList(allAudioListFromDB);
                            }
                            favouriteScreenAudioListUpdation = true;
                            // audioPlayer.playlistPlayAtIndex(index);
                            miniPlayerVisibility.value = true;
                          },
                          leading: CircleAvatar(
                            radius: 35,
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
                            icon: favouritesListFromDb.value
                                    .contains(allAudioListFromDB[index])
                                ? functionIcon(Icons.remove, 20, Colors.white)
                                : functionIcon(Icons.add, 20, Colors.white),
                            onPressed: () async {
                              tempFavouriteList.contains(
                                      allAudioListFromDB[index].id.toString())
                                  ? await favouritesRemove(
                                      allAudioListFromDB[index].id.toString())
                                  : await addFavouritesToDB(
                                      allAudioListFromDB[index].id.toString());
                            },
                          ),
                        ),
                      );
                    }),
                    itemCount: allAudioListFromDB.length,
                    shrinkWrap: true,
                  );
                })
          ],
        ),
      ),
    );
  }
}
