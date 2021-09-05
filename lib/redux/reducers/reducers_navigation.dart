import 'package:instapic/redux/actions/action_navigation.dart';
import 'package:redux/redux.dart';

final reducersNavigation = combineReducers<String>([
  TypedReducer<String, ActionNavigation>(_reducerNavigation),
]);

String _reducerNavigation(String status, ActionNavigation action) {
  return action.routeDetails.route;
}