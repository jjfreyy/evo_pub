part of 'pages.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //FirebaseUser firebaseUser = Provider.of<FirebaseUser>(context);
    refreshKodeUnik();
    return LoginPage2();
    //return (firebaseUser == null) ? LoginPage2() : MainPage2();
  }
}
