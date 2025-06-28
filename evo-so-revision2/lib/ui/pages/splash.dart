part of 'pages.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      getSharedPreferences().then((value) {
        final token = value.getString('token');
        if (isEmpty(token) || Jwt.isExpired(token as String)) {
          return Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginPage()));
        }

        userID = Jwt.parseJwt(token)['UserID'];
        return Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const MainPage()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
            height: 100,
            width: 100,
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/logo.png')),
            ),
          ),
        ),
      ),
    );
  }
}
