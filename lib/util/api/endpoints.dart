abstract class EndPoints{
  static const _baseUrl = 'http://api-staging.jungle.rocks/';
  // Login -> email: " dev@jungledevs.com ", password: " developer123"
  static String login(){
    return '$_baseUrl/api/v1/login/';
  }
  
}