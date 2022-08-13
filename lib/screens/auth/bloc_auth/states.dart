abstract class RegisterStates{}

class InitialShopStates extends RegisterStates{}

class RegisterSuccessState extends RegisterStates{}
class RegisterLoadingState extends RegisterStates{}
class RegisterErrorState extends RegisterStates{
  String error;
  RegisterErrorState(this.error);
}
class LoginSuccessState extends RegisterStates{}
class LoginLoadingState extends RegisterStates{}
class LoginErrorState extends RegisterStates{
  String error;
  LoginErrorState(this.error);
}
class CreateUserSuccessState extends RegisterStates{}
class RegisterGetImageState extends RegisterStates{}
class CreateUserErrorState extends RegisterStates{
  String error;
  CreateUserErrorState(this.error);
}
class RegisterWithGoogleLoadingState extends RegisterStates{}
class RegisterWithFacebookLoadingState extends RegisterStates{}