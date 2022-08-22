// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/functions/design_widgets.dart';
import 'package:musicplayer/screens/favourite_screen/screen_favourite.dart';
import 'package:musicplayer/screens/playlist_screen/screen_playlist.dart';
import 'package:musicplayer/screens/screen_search/screen_search.dart';
import '../favourite_screen/screen_addtofavourite.dart';
import '../playlist_screen/playlist_widgets.dart';
import 'home_widgets.dart';

late TabController tabController;

class ScreenHomeMain extends StatefulWidget {
  const ScreenHomeMain({Key? key}) : super(key: key);

  @override
  State<ScreenHomeMain> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHomeMain>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    tabController.addListener(_handleSelected);
  }

//floating action button icon change
  void _handleSelected() {
    setState(() {
      tabController.index;
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ValueListenableBuilder(
      valueListenable: miniPlayerVisibility,
      builder: (BuildContext context, bool value, Widget? child) {
        return Scaffold(
            floatingActionButton: FloatingActionButton(
                backgroundColor: appbarColor,
                onPressed: (() {
                  if (tabController.index == 1) {
                    showModalBottomSheet(
                        backgroundColor: Colors.black,
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                        builder: (context) {
                          return ScreenAddToFavourits();
                        });
                  } else if (tabController.index == 2) {
                    openDialog(context);
                  } else {
                    showSearch(
                      context: context,
                      delegate: MusicSearch(),
                    );
                  }
                }),
                child: tabController.index == 0
                    ? functionIcon(Icons.search, 20, Colors.white)
                    : functionIcon(Icons.add, 20, Colors.white)),
            backgroundColor: Colors.black,
            extendBodyBehindAppBar: true,
            drawer: Drawer(
              width: 250,
              backgroundColor: appbarColor,
              child: DrawerContent(),
            ),
            appBar: AppBar(
              title: Text('Music Player'),
              centerTitle: true,
              backgroundColor: appbarColor,
              bottom: TabBar(
                onTap: (value) {
                  setState(() {
                    value;
                  });
                },
                controller: tabController,
                tabs: [
                  Tab(
                    text: 'Home',
                    icon: functionIcon(Icons.home, 25, whiteColor),
                  ),
                  Tab(
                    text: 'Favourites',
                    icon: functionIcon(Icons.favorite, 25, whiteColor),
                  ),
                  Tab(
                    text: 'Playlist',
                    icon: functionIcon(Icons.playlist_play, 25, whiteColor),
                  ),
                ],
              ),
              elevation: 0,
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: Icon(Icons.settings));
                },
              ),
            ),
            body: TabBarView(
              controller: tabController,
              children: const [
                ScreenHome(),
                ScreenFavourite(),
                ScreenPlaylist(),
              ],
            ),
            bottomNavigationBar: miniPlayer(context));
      },
    );
  }
}
