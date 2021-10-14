import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:instapic/models/apple_state.dart';
import 'package:instapic/models/filters.dart';
import 'package:instapic/redux/actions/action_filters.dart';
import 'package:instapic/redux/actions/action_navigation.dart';
import 'package:instapic/redux/selectors/selectors.dart';
import 'package:instapic/ui/keys.dart';
import 'package:instapic/ui/routes.dart';
import 'package:redux/redux.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class WidgetFilter extends StatefulWidget {
  WidgetFilter({Key? key}) : super(key: key);

  @override
  _WidgetFilterState createState() => _WidgetFilterState();
}

class _WidgetFilterState extends State<WidgetFilter> {
  String? username;
  QuerySortBy sortBy = QuerySortBy.NONE;
  QuerySortOrder? sortOrder;
  Filters? filters;
  TextEditingController textEditingController;

  _WidgetFilterState():textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filters = selectorFilters(StoreProvider.of<AppState>(context, listen: false).state);
    username = filters!.username;
    sortBy = filters!.sortby;
    sortOrder = filters!.order;
    textEditingController.text = username??"";
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSortOrderNull = (username!=null && sortBy == QuerySortBy.USER) || sortBy == QuerySortBy.NONE;
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: _ViewModel.fromStore,
      builder: (context, vm){
        return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            WidgetFilterItem(
                title: "username:",
                item: SizedBox(
                  width: 50,
                  child: TextField(
                    obscureText: false,
                    controller: textEditingController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Browse posts of the specific user?"),
                    onChanged: (value){
                      setState(() {
                        var _v = value.trim();
                        if(_v == ""){
                          username = null;
                        }else{
                          username = _v;
                        }
                      });
                    },
                  ),
                )),
            WidgetFilterItem(title: "Sort by:", item: Column(
                children: [
                  ListTile(
                    title: const Text("username"),
                    leading: Radio<QuerySortBy>(
                      key: Key(WidgetKeys.radioSortbyUsername),
                      groupValue: sortBy,
                      value: QuerySortBy.USER,
                      onChanged: username!=null?null:(QuerySortBy? sb){
                        setState(() {
                          sortBy = sb!;
                        });
                      },),
                  ),
                  ListTile(
                    title: const Text("time"),
                    leading: Radio<QuerySortBy>(
                      key: Key(WidgetKeys.radioSortbyTime),
                      groupValue: sortBy,
                      value: QuerySortBy.TIME,
                      onChanged: (QuerySortBy? sb){
                        setState(() {
                          sortBy = sb!;
                        });
                      },),
                  ),
                  ListTile(
                    title: const Text("none"),
                    leading: Radio<QuerySortBy>(
                      key: Key(WidgetKeys.radioSortbyNone),
                      groupValue: sortBy,
                      value: QuerySortBy.NONE,
                      onChanged: (QuerySortBy? sb){
                        setState(() {
                          sortBy = sb!;
                        });
                      },),
                  ),
                ],
            )),
            WidgetFilterItem(title: "Sort Order:", item: Column(
                children: [
                  ListTile(
                    title: const Text("ascending"),
                    leading: Radio<QuerySortOrder>(
                      key: Key(WidgetKeys.radioOrderAscending),
                      groupValue: sortOrder,
                      value: QuerySortOrder.ASCENDING,
                      onChanged: isSortOrderNull
                      ? null
                      : (QuerySortOrder? so){
                        setState(() {
                          sortOrder = so;
                        });
                      },),
                  ),
                  ListTile(
                    title: const Text("descending"),
                    leading: Radio<QuerySortOrder>(
                      key: Key(WidgetKeys.radioOrderDescending),
                      groupValue: sortOrder,
                      value: QuerySortOrder.DESCENDING,
                      onChanged: isSortOrderNull
                      ? null
                      : (QuerySortOrder? so){
                        setState(() {
                          sortOrder = so;
                        });
                      },),
                  )
                ],
            )),
            SizedBox(height: 30,),
            Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                key: Key(WidgetKeys.btnConfirmUpdateFilters),
                heroTag: null,
                onPressed: (){
                  final isSortByNone = username!=null && sortBy == QuerySortBy.USER;
                  Filters _f = Filters(
                    username: username,
                    sortby: isSortByNone?QuerySortBy.NONE:sortBy,
                    order: isSortOrderNull?null:sortOrder);
                    vm.onConfirmUpdateFilters(_f);
                },
                child: const Icon(Icons.check),
                backgroundColor: Colors.green,
                tooltip: "Save",
                ),
              SizedBox(width: 40,),
              FloatingActionButton(
                key: Key(WidgetKeys.btnCancelUpdateFilters),
                onPressed: vm.onCancelUpdateFilters,
                child: const Icon(Icons.cancel_outlined),
                backgroundColor: Colors.red,
                tooltip: "Cancel",
                )
            ],
          ),
          ],
        ),
      );
      }
    );
  }
}

class WidgetFilterItem extends StatelessWidget {
  const WidgetFilterItem({Key? key, required this.title, required this.item})
      : super(key: key);
  final String title;
  final Widget item;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: kIsWeb?70:50,
              height: 30,
              child: Text(title, style: TextStyle(color: Colors.cyan[900], fontWeight: FontWeight.bold),),
            ),
            SizedBox(width: kIsWeb?30:10),
            SizedBox(width: kIsWeb?300:200, child: item)
          ],
        ),
        SizedBox(height: 30,)
      ],
    );
  }
}

class _ViewModel {
  final Function(Filters) onConfirmUpdateFilters;
  final Function() onCancelUpdateFilters;
  final Filters filters;

  _ViewModel({
    required this.filters,
    required this.onCancelUpdateFilters,
    required this.onConfirmUpdateFilters,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      filters: selectorFilters(store.state),
      onCancelUpdateFilters: (){store.dispatch(ActionNavigation(mapRouteDetails[RouteNames.browse]!));},
      onConfirmUpdateFilters: (filter){
        // only update filters when it changes
        if(store.state.filters != filter){
          store.dispatch(ActionUpdateFilters(filter));
        }
        store.dispatch(ActionNavigation(mapRouteDetails[RouteNames.browse]!));
      }
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          filters == other.filters;

  @override
  int get hashCode => filters.hashCode;
}