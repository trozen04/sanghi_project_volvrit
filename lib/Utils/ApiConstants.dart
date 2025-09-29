class ApiConstants {
  //static String baseUrl = "http://192.168.0.116:3000";
  static String baseUrl = "http://192.168.0.112:5000";

  //Auth
  static String login = "/api/user/loginuser";
  static String register = "/api/user/registeruser";

  //Products
  static String productList = "/api/product/getallcatesubcateandproduct"; //minWeight/maxWeight
  static String goldPrice = "/api/gold-prices";

  //Profile
  static String getProfile = "/api/auth/profile";
  static String updateProfile = "/api/auth/profile";

}