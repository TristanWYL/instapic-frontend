// This class is for packaging the data from 
// the response of the api request
class ApiResponse{

  static const CODE_OK = 200;

  // API_KEY is missed
  static const CODE_API_KEY_MISSED = 400;

  // user should log in first
  static const CODE_UNAUTHORIZED = 401;

  // the request parameters are invlid
  static const CODE_INVALID_PARAMETERS = 402;

  // the data from the POST request  are invlid
  static const CODE_INVALID_DATA = 403;

  // The request resource is not found
  static const CODE_NOT_FOUND = 404;

  // server internal error
  static const CODE_SERVER_ERROR = 500;

  final int code;
  final String msg;
  final dynamic data;

  ApiResponse(this.code, this.msg, {this.data});
  
  ApiResponse.fromJSON(Map<String, dynamic> json)
  : this.code = json["code"],
    this.msg = json["msg"],
    this.data = json.containsKey("data")?json["data"]:null;

  @override
  String toString(){
    return "code: $code, msg: $msg";
  }
}
