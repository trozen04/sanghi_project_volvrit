class ApiConstants {
  //static String baseUrl = "http://192.168.0.112:5000";
  //static String imageUrl = "http://192.168.0.112:5000/";
  static String baseUrl = "http://192.168.1.39:5000";
  static String imageUrl = "http://192.168.1.39:5000/";

  //Auth
  static String login = "/api/user/loginuser";
  static String register = "/api/user/registeruser";

  //Products
  static String goldPrice = "/api/gold-rate/today";
  static String productList = "/api/product/getallcatesubcateandproduct";
  static String productDetails = "/api/product/getproductbyid/";

  //cart
  static String addToCart = "/api/cart/addtocart/";
  static String removeFromCart = "/api/cart/removefromcart/";
  static String addOrRemoveCart = "/api/cart/quantityupdate/";
  static String myCart = "/api/cart/getcartitems/";
  static String submitCart = "/api/cart/process-cart/";

  //Notification
  static String notification = "/api/notification/user";
  static String markReadOrRemove = "/api/notification/";

  //Profile
  static String getProfile = "/api/user/";
  static String updateProfile = "/api/user/update-profile/";

  //Orders
  static String myOrders = "/api/order/";
  static String myOrderDetails = "/api/order/user/";

}