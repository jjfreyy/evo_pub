part of 'helpers.dart';

int animationDuration = 400;
bool debug = true;
int fetchDelay = 400;
bool isAuthorized = false;
int initDelay = 50;
Color mainColor = Colors.lightBlue;
Color loaderColor = Colors.amber.shade300;
late MainCubit mainCubit;
late FirebaseMessaging msg;
String serverErrorMsg = 'Terjadi kesalahan internal server.';
int splashScreenDelay = 1000;
late User user;
