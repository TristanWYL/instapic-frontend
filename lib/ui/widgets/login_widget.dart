import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:instapic/models/apple_state.dart';
import 'package:instapic/redux/actions/action_sign_in_out_up.dart';
import 'package:instapic/ui/keys.dart';

enum SignType { SignUp, SignIn }

class WidgetSign extends StatefulWidget {
  WidgetSign({Key? key}) : super(key: key);

  @override
  _WidgetSignState createState() => _WidgetSignState();
}

class _WidgetSignState extends State<WidgetSign> {
  SignType _signType = SignType.SignIn;
  String _formUsername = "";
  String _formPassword = "";
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<_SignState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 450,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_signType==SignType.SignIn?"Sign In":"Sign Up", style: TextStyle(fontSize: 20),
            key: Key(WidgetKeys.textFunction)),
          SizedBox(height: 18,),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Form(
                key: _formKey,
                 child: Column(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     TextFormField(
                       key: Key(WidgetKeys.textFieldUsername),
                       maxLength: 10,
                       textInputAction: TextInputAction.next,
                       obscureText: false,
                       // The validator receives the text that the user has entered.
                       validator: (value){
                         if(value==null || value.isEmpty){
                           return 'Please enter your username!';
                         }
                         RegExp regExp = new RegExp(r"^\w{1,10}$");
                         if(!regExp.hasMatch(value)){
                           return "Username can only include alphanumeric characters!";
                         }
                         return null;
                       },
                       onChanged: (value){
                         _formUsername = value;
                       },
                        decoration: InputDecoration(
                          filled: true,
                          icon: const Icon(Icons.person),
                          hintText: "username"
                        ),
                     ),
                     SizedBox(height: 18,),
                     TextFormField(
                       key: Key(WidgetKeys.textFieldPassword),
                       maxLength: 20,                       
                       textInputAction: TextInputAction.next,
                       obscureText: true,
                       // The validator receives the text that the user has entered.
                       validator: (value){
                         if(value==null || value.isEmpty){
                           return 'Please enter your password!';
                         }
                         if(_signType==SignType.SignUp){
                            RegExp regExp = new RegExp(r"^[^\s]{1,20}$");
                            if(!regExp.hasMatch(value)){
                              return "Cannot include whitespaces anywhere!";
                            }
                          }
                         return null;
                       },
                       onChanged: (value){
                         _formPassword = value;
                       },
                        decoration: InputDecoration(
                          filled: true,
                          icon: const Icon(Icons.lock),
                          hintText: "password"
                        ),
                     ),
                     SizedBox(height: 18,),
                     _signType==SignType.SignIn?SizedBox(height: 0,):TextFormField(
                       key: Key(WidgetKeys.textFieldPasswordConfirm),
                       maxLength: 20,
                       textInputAction: TextInputAction.next,
                       obscureText: true,
                       // The validator receives the text that the user has entered.
                       validator: (value){
                         if(value==null || value.isEmpty){
                           return 'Please confirm your password!';
                         }else if(_formPassword != value){
                           return 'Password confirmation failed!';
                         }
                         return null;
                       },
                       
                        decoration: InputDecoration(
                          filled: true,
                          icon: const Icon(Icons.lock),
                          hintText: "Re-enter password"
                        ),
                     ),
                     _signType==SignType.SignIn?SizedBox(height: 0,):SizedBox(height: 18,),
                     ElevatedButton(
                       key: Key(WidgetKeys.btnSubmit),
                       onPressed: () async {
                         // validate returns true if the form is valid, or false otherwise.
                         if (_formKey.currentState!.validate()){
                           // pass the validation
                           // the form could be submitted
                           if(_signType == SignType.SignIn){
                             final store = StoreProvider.of<AppState>(context, listen: false);
                             store.dispatch(ActionSignIn(username: _formUsername, password: _formPassword));
                           }else{
                             final store = StoreProvider.of<AppState>(context, listen: false);
                             store.dispatch(ActionSignUp(username: _formUsername, password: _formPassword));
                           }
                         }
                       }, 
                       child: Text("Submit")),
                       SizedBox(height: 18,),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         mainAxisSize: MainAxisSize.min,
                         children: [
                           Flexible(
                             child: Text(_signType==SignType.SignIn?"Does not have an account? ":"Already have an account? ", 
                                style: TextStyle(fontSize: 14),
                              ),
                           ),
                           TextButton(
                             key: Key(WidgetKeys.btnSignInUpSwitch),
                             onPressed: (){
                               setState(() {
                                 _signType = _signType==SignType.SignIn? SignType.SignUp:SignType.SignIn;
                               });
                             }, 
                            child: Text(_signType==SignType.SignIn?"Sign Up?":"Sign In?", style: TextStyle(fontSize: 14),))
                         ],
                       )
                   ],
                 ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
