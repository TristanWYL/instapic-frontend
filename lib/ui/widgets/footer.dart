import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class WidgetFooter extends StatelessWidget {
  const WidgetFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Padding(padding: EdgeInsets.symmetric(vertical: 5),
          child: SelectableLinkify(
            text: "Authur: Tristan Yulong WU",
            style: TextStyle(
              fontSize: 20,
            ),
          ),),
          Padding(padding: EdgeInsets.symmetric(vertical: 5),
          child: SelectableLinkify(
            text: "Contact: tristan_wyl(at)hotmail.com",
            style: TextStyle(
              fontSize: 20,
            ),
          ),),
          Padding(padding: EdgeInsets.symmetric(vertical: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableLinkify(
                text: "GitHub repositories:",
                onOpen: (link) async {
                  await launch(link.url);
                },
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SelectableLinkify(
                text: "    Frontend: https://github.com/TristanWYL/instapic-frontend.git",
                onOpen: (link) async {
                  await launch(link.url);
                },
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SelectableLinkify(
                text: "    Backend: https://github.com/TristanWYL/instapic-backend.git",
                onOpen: (link) async {
                  await launch(link.url);
                },
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),),
          Padding(padding: EdgeInsets.symmetric(vertical: 5),
          child: SelectableLinkify(
            text: "License: MIT",
            style: TextStyle(
              fontSize: 20,
            ),
          ),),
      ],),
    );
  }
}