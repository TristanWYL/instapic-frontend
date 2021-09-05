import 'package:flutter/material.dart';
import 'package:instapic/ui/widgets/page_base.dart';
import 'package:instapic/ui/widgets/post_uploader_widget.dart';

class PageUpload extends StatelessWidget {
  const PageUpload({Key? key, required this.pageID}) : super(key: key);
  final int pageID;
  @override
  Widget build(BuildContext context) {
    return WidgetPageBase(child: SingleChildScrollView(
      child: WidgetUploader(),
    ), navigationRailIndex: pageID);
  }
}