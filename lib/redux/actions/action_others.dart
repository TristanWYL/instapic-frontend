// This action is only for show prompting message
// when there happens an error
// This action will not change the AppState
// This action could be intercepted by some middlewares directly
class ActionPromptError{
  final String error;
  ActionPromptError(this.error);
}

