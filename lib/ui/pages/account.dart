import 'package:flutter/material.dart';
import 'package:instapic/ui/widgets/account.dart';
import 'package:instapic/ui/widgets/page_base.dart';

class PageAccount extends StatelessWidget {
  const PageAccount({Key? key, required this.pageID}) : super(key: key);
  final int pageID;
  @override
  Widget build(BuildContext context) {
    return WidgetPageBase(child: SingleChildScrollView(child: WidgetAccount()), navigationRailIndex: pageID);
  }
}