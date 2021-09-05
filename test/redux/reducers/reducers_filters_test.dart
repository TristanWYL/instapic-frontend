import 'package:flutter_test/flutter_test.dart';
import 'package:instapic/models/apple_state.dart';
import 'package:instapic/models/filters.dart';
import 'package:instapic/redux/actions/action_filters.dart';
import 'package:instapic/redux/reducers/reducers.dart';
import 'package:instapic/redux/selectors/selectors.dart';
import 'package:redux/redux.dart';

void main() {
  group("Reducers for Filters", (){
    test("should update the filters, in response to ActionUpdateFilters", (){
      final oldFilters = Filters();
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(filters: oldFilters)
      );
      final newFilters = Filters();
      final action = ActionUpdateFilters(newFilters);
      store.dispatch(action);
      expect(selectorFilters(store.state), newFilters);
    });
  });
}