import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:instapic/misc/config.dart';
import 'package:instapic/remote/response.dart';
import 'package:stack_trace/stack_trace.dart';


/// Gets information from the API.
class Api{
  Dio dio = Dio();
  static const int API_EXCEPTION_CODE = 1000;

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
