class Config {
  // This key will be used to help the backend (RESTful API) to 
  // identify this client, and then the api service will be provided
  static const String API_KEY = "your_api_key";

  // an integer indicating how many posts should be loaded
  // each time the client app fetches the data
  static const int PAGE_SIZE = 10;

  // base url for the restful backend
  static const String BASE_URL = "https://instapic.club/";
  
  // current api version
  static const int API_VERSION = 1;

  static String getApiURL() => "${BASE_URL}api/v$API_VERSION/";

  // The maximum size of the uploaded image file
  // The one whose size exceeds this will not be allowed
  
  static const int MAX_PICTURE_SIZE_BYTE = 500000;
}
