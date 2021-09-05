import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class _DialogInfo{
  final Function action;
  final List positionalArguments;
  final Map<Symbol, dynamic> namedArguments;
  _DialogInfo(this.action, this.positionalArguments, this.namedArguments);
}

class _DialogController{
  static _DialogController? _singleton;
  _DialogController._internal():_controller = StreamController<_DialogInfo>();
  factory _DialogController(){
    if(_singleton == null){
      _singleton = _DialogController._internal();
      _singleton!._init();
    }
    return _singleton!;
  }
  void _init(){
    
  }

  void enqueueEvent(_DialogInfo event){
    _controller.add(event);
  }

  void listen(void Function(_DialogInfo) f){
    _streamSubscription = _controller.stream.listen((event) { f(event); });
  }

  void dispose(){
    _streamSubscription?.cancel();
    _controller.close();
  }

  final StreamController<_DialogInfo> _controller;
  StreamSubscription<_DialogInfo>? _streamSubscription;
}

/// received the pushed events of _DialogController
class PromptDialogs{
  static PromptDialogs? _singleton;
  PromptDialogs._internal();

  factory PromptDialogs(){
    if(_singleton == null){
      _singleton = PromptDialogs._internal();
      _singleton!._init();
    }
    return _singleton!;
  }

  void _init(){
    _DialogController().listen((event){
      Function.apply(event.action, event.positionalArguments, event.namedArguments);
    });
  }

  void dispose(){
    _DialogController().dispose();
  }

  static void showErrorAsync(String error){
    _DialogController().enqueueEvent(_DialogInfo(showError, [error], {}));
  }

  static void showError(String error) {
    EasyLoading.showError(
      error,
      duration: Duration(seconds: 10),
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: true);
  }

  // static _DialogInfo getDialogInfoShowInfo(String info, {int durationSec = 2}) {
  //   return _DialogInfo(showInfo, [info], {#durationSec:durationSec});
  // }
  static void showInfo(String info, {int durationSec = 2}) {
    EasyLoading.showInfo(
      info,
      duration: Duration(seconds: durationSec),
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: true);
  }

  // static _DialogInfo getDialogInfoShowSuccess({String msg = "Success", int durationSec = 2}) {
  //   return _DialogInfo(showSuccess, [], {#msg:msg, #durationSec:durationSec});
  // }
  static void showSuccess({String msg = "Success", int durationSec = 2}) {
    EasyLoading.showSuccess(
      msg,
      duration: Duration(seconds: durationSec),
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: true);
  }

  // static _DialogInfo getDialogInfoShowProgress(double value, {String? status}){
  //   return _DialogInfo(showProgress, [value], {#status:status});
  // }

  /// value should be in [0,1]
  static void showProgress(double value, {String? status}){
    EasyLoading.showProgress(
      value,
      status: status,
      maskType: EasyLoadingMaskType.black
    );
  }
}