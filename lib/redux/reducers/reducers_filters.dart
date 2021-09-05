import 'package:instapic/models/filters.dart';
import 'package:instapic/redux/actions/action_filters.dart';
import 'package:redux/redux.dart';

final reducersFilters = combineReducers<Filters>([
  TypedReducer<Filters, ActionUpdateFilters>(_reducerFilters)
]);

Filters _reducerFilters(Filters state, ActionUpdateFilters action){
  return action.newFilters;
}