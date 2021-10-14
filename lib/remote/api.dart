import 'dart:io';
import 'dart:typed_data';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:instapic/misc/config.dart';
import 'package:instapic/remote/response.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stack_trace/stack_trace.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


/// Gets information from the API.
class Api{
  Dio dio = Dio();
  static const int API_EXCEPTION_CODE = 1000;

  Api(){
    if(!kIsWeb){
      getApplicationDocumentsDirectory().then((value){
        var cj = PersistCookieJar(ignoreExpires: true, storage: FileStorage(value.path +"/.cookies/" ));
        dio.interceptors.add(CookieManager(cj));
      });
    }
  }

  String getErrorMsg(Object e, int statusCode){
    // print(e);
    var errMsg = e.toString().split("\n")[0];
    return "[error from api: ${Trace.current().frames[1].member!}]\nStatus Code: $statusCode\n$errMsg";
  }

  Future<ApiResponse> signUp(String username, String password) async {
    String _url = "${Config.getApiURL()}signup?api_key=${Config.API_KEY}";
    try {
      Response response = await dio.post(
        _url,
        data:{"username":username, "password":password},
        options: Options(contentType: 'application/json'));
      return ApiResponse.fromJSON(response.data);
    }on DioError catch (e){
      if(e.type == DioErrorType.response){
        return ApiResponse(e.response!.data["code"], getErrorMsg(e.response!.data["msg"], e.response!.data["code"]));
      }else{
        throw e;
      }
    } catch (e){
      return ApiResponse(API_EXCEPTION_CODE, getErrorMsg(e, API_EXCEPTION_CODE));
    }
  }

  Future<ApiResponse> signIn(String username, String password) async {
    String _url = "${Config.getApiURL()}signin?api_key=${Config.API_KEY}";
    try {
      Response response = await dio.post(
        _url,
        data:{"username":username, "password":password},
        options: Options(
          contentType: 'application/json',
          )
        );
      return ApiResponse.fromJSON(response.data);
    }on DioError catch (e){
      if(e.type == DioErrorType.response){
        return ApiResponse(e.response!.data["code"], getErrorMsg(e.response!.data["msg"], e.response!.data["code"]));
      }else{
        throw e;
      }
    }
     catch (e){
      return ApiResponse(API_EXCEPTION_CODE, getErrorMsg(e, API_EXCEPTION_CODE));
    }
  }

  Future<ApiResponse> signInQuery() async {
    String _url = "${Config.getApiURL()}signin_query?api_key=${Config.API_KEY}";
    try {
      Response response = await dio.get(_url);
      return ApiResponse.fromJSON(response.data);
    } on DioError catch (e){
      if(e.type == DioErrorType.response){
        return ApiResponse(e.response!.data["code"], getErrorMsg(e.response!.data["msg"], e.response!.data["code"]));
      }else{
        throw e;
      }
    }catch (e){
      return ApiResponse(API_EXCEPTION_CODE, getErrorMsg(e, API_EXCEPTION_CODE));
    }
  }

  Future<ApiResponse> logOut() async {
    String _url = "${Config.getApiURL()}signout?api_key=${Config.API_KEY}";
    try {
      Response response = await dio.get(_url);
      return ApiResponse.fromJSON(response.data);
    } on DioError catch (e){
      if(e.type == DioErrorType.response){
        return ApiResponse(e.response!.data["code"], getErrorMsg(e.response!.data["msg"], e.response!.data["code"]));
      }else{
        throw e;
      }
    }catch (e){
      return ApiResponse(API_EXCEPTION_CODE, getErrorMsg(e, API_EXCEPTION_CODE));
    }
  }

  Future<ApiResponse> post(Uint8List imageBytes, String description, String imageFileName, {void Function(int, int)? onSendProgress}) async {
    String _url = "${Config.getApiURL()}post?api_key=${Config.API_KEY}";
    try {
      var formData = FormData();
      formData.fields.add(MapEntry("description", description));
      formData.files.add(MapEntry("image", MultipartFile.fromBytes(imageBytes, filename: imageFileName)));
      Response response = await dio.post(
        _url,
        data: formData,
        onSendProgress: onSendProgress
      );
      return ApiResponse.fromJSON(response.data);
    } on DioError catch (e){
      if(e.type == DioErrorType.response){
        return ApiResponse(e.response!.data["code"], getErrorMsg(e.response!.data["msg"], e.response!.data["code"]));
      }else{
        throw e;
      }
    }catch (e){
      return ApiResponse(API_EXCEPTION_CODE, getErrorMsg(e, API_EXCEPTION_CODE));
    }
  }

  Future<ApiResponse> posts({int start:0, int limit:Config.PAGE_SIZE, String? username, String? sortby, String? order}) async {
    String _url = "${Config.getApiURL()}posts?api_key=${Config.API_KEY}&start=$start&limit=$limit";
    if(username != null){
      _url += "&user=$username";
    }
    if(sortby != null){
      _url += "&sortby=$sortby";
    }
    if(order != null){
      _url += "&order=$order";
    }
    try {
      Response response = await dio.get(_url);
      return ApiResponse.fromJSON(response.data);
    } on DioError catch (e){
      if(e.type == DioErrorType.response){
        return ApiResponse(e.response!.data["code"], getErrorMsg(e.response!.data["msg"], e.response!.data["code"]));
      }else{
        throw e;
      }
    }catch (e){
      return ApiResponse(API_EXCEPTION_CODE, getErrorMsg(e, API_EXCEPTION_CODE));
    }
  }
}
