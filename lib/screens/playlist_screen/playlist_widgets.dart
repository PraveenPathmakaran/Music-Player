//dialogue box for creating playlist in playlist screen
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:musicplayer/screens/playlist_screen/playlist_functions.dart';
import '../../functions/design_widgets.dart';

TextEditingController playlistTextController = TextEditingController();
Future openDialog(BuildContext context3) async {
  showDialog(
      context: context3,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: backgroundColor1,
          title: functionText(
              'Create Playlist', Colors.white, FontWeight.normal, 20),
          content: TextField(
            style: TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            controller: playlistTextController,
            autofocus: true,
            decoration: InputDecoration(
                hintText: 'Playlist Name',
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: roseColor))),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                playlistCreation(playlistTextController.text);
                keyUpdate();
                playlistTextController.clear();
                Navigator.of(ctx).pop();
              },
              child: Text(
                'Create',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      });
}
