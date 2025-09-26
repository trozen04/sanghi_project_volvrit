
class Constants {
  // Regex patterns
  static const String emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String passwordPattern =
      r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]{6,}$';

  // Strings
  static const String appName = 'SANGHI';
  static const String loginTitle = 'Login to your Account';
  static const String signUpTitle = 'Signup to your Account';
  static const String loginSubtitle = 'Please enter your details';
  static const String emailHint = 'Enter your email';
  static const String passwordHint = 'Enter your password';
  static const String emailLabel = 'Email';
  static const String passwordLabel = 'Password';
  static const String loginBtn = 'Login';
  static const String noAccount = "Don’t have an account? ";
  static const String signup = 'Signup';
}
