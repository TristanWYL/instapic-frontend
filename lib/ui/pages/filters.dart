import 'package:flutter/material.dart';
import 'package:instapic/ui/widgets/filter.dart';
import 'package:instapic/ui/widgets/page_base.dart';

class PageFilters extends StatelessWidget {
  const PageFilters({Key? key, required this.pageID}) : super(key: key);
  final int pageID;
  @override
  Widget build(BuildContext context) {
    return WidgetPageBase(
      child: WidgetFilter(), 
      navigationRailIndex: pageID);
  }
}