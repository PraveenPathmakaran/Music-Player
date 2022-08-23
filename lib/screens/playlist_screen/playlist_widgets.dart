//dialogue box for creating playlist in playlist screen
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:musicplayer/screens/playlist_screen/playlist_functions.dart';
import '../../functions/design_widgets.dart';

TextEditingController playlistTextController = TextEditingController();

Future openDialog(BuildContext context) async {
  showDialog(
      context: context,
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
                if (playlistTextController.text == "") {
                  return;
                } else {
                  playlistCreation(playlistTextController.text);

                  keyUpdate();
                  playlistTextController.clear();
                  Navigator.of(ctx).pop();
                }
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

Future updatePlaylistName(BuildContext context, String playlistName) async {
  String value1 = "";
  showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: backgroundColor1,
          title: functionText(
              'Update Playlist Name', Colors.white, FontWeight.normal, 20),
          content: TextFormField(
            initialValue: playlistName == null ? "haii" : playlistName,
            onChanged: (value) {
              value1 = value;
            },
            style: TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            //controller: playlistTextController,
            autofocus: true,
            decoration: InputDecoration(
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
              onPressed: () async {
                Navigator.pop(context);
                if (value1 == "") {
                  return;
                }
                await playlistNameUpdate(playlistName, value1);
              },
              child: Text(
                'Update',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      });
}
