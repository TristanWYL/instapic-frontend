import 'package:flutter/material.dart';
import 'package:instapic/ui/keys.dart';
import 'package:instapic/ui/pages/about_app.dart';
import 'package:instapic/ui/pages/account.dart';
import 'package:instapic/ui/pages/browse.dart';
import 'package:instapic/ui/pages/filters.dart';
import 'package:instapic/ui/pages/login.dart';
import 'package:instapic/ui/pages/upload.dart';

class RouteNames {
  static final login = '/login';
  static final upload = '/upload';
  static final browse = '/browse';
  static final filters = '/filters';
  static final about = '/about';
  static final account = '/account';
}

class RouteDetails{
  final String route;
  final Widget page;
  final Icon navigationBarIcon;
  final String navigationBarLabel;
  const RouteDetails({required this.route, required this.page, required this.navigationBarIcon, required this.navigationBarLabel});
}

final mapRouteDetails = {
  RouteNames.login : RouteDetails(
                      route: RouteNames.login,
                      page: PageLogin(key: Key(WidgetKeys.loginPage)),
                      navigationBarIcon: const Icon(Icons.nat),
                      navigationBarLabel: ""
                    ),
  RouteNames.account : RouteDetails(
                      route: RouteNames.account,
                      page: PageAccount(pageID: 0, key: Key(WidgetKeys.accountPage)),
                      navigationBarIcon: const Icon(Icons.person_outline, key: Key(WidgetKeys.accountPageMenuIcon)),
                      navigationBarLabel: "Account"
                    ),
  RouteNames.browse : RouteDetails(
                      route: RouteNames.browse,
                      page: PageBrowser(pageID: 1, key: Key(WidgetKeys.browsePage)),
                      navigationBarIcon: const Icon(Icons.picture_in_picture, key: Key(WidgetKeys.browsePageMenuIcon)),
                      navigationBarLabel: "Posts"
                    ),
  RouteNames.filters : RouteDetails(
                      route: RouteNames.filters,
                      page: PageFilters(pageID: 2, key: Key(WidgetKeys.filtersPage)),
                      navigationBarIcon: const Icon(Icons.filter_alt_outlined, key: Key(WidgetKeys.filtersPageMenuIcon)),
                      navigationBarLabel: "Filters"
                    ),
  RouteNames.upload : RouteDetails(
                      route: RouteNames.upload,
                      page: PageUpload(pageID: 3, key: Key(WidgetKeys.uploadPage)),
                      navigationBarIcon: const Icon(Icons.post_add, key: Key(WidgetKeys.uploadPageMenuIcon)),
                      navigationBarLabel: "Upload"
                    ),
  RouteNames.about : RouteDetails(
                      route: RouteNames.about,
                      page: PageAbout(pageID: 4, key: Key(WidgetKeys.aboutPage)),
                      navigationBarIcon: const Icon(Icons.recommend, key: Key(WidgetKeys.aboutPageMenuIcon)),
                      navigationBarLabel: "About"
                    )
};

final listRouteDetails = mapRouteDetails.values.toList();

// This list will be used for building the pages with the [NavigationRail]
// Since the login page does not need the NavigationRail, so we slice the login page off
final listRouteDetailsWithoutLogin = mapRouteDetails.values.toList().sublist(1);
final Map<String, Widget Function(BuildContext)> routes = {for (var e in listRouteDetails) e.route: (context)=>e.page};
