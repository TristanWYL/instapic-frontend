import 'package:flutter/material.dart';
import 'package:instapic/ui/widgets/page_base.dart';
import 'package:instapic/ui/widgets/posts_widget.dart';

class PageBrowser extends StatelessWidget {
  final int pageID;
  const PageBrowser({Key? key, required this.pageID}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return WidgetPageBase(child: PagedImageListView(), navigationRailIndex: pageID);
  }
}