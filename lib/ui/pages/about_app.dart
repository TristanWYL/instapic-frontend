import 'package:flutter/material.dart';
import 'package:instapic/ui/widgets/footer.dart';
import 'package:instapic/ui/widgets/page_base.dart';

class PageAbout extends StatelessWidget {
  const PageAbout({Key? key, required this.pageID}) : super(key: key);
  final int pageID;
  @override
  Widget build(BuildContext context) {
    return WidgetPageBase(child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 30, bottom: 30),
            child: Image.asset('assets/images/logo.png'),
            ),
          WidgetFooter()
        ],
      ),
    ), navigationRailIndex: pageID);
  }
}