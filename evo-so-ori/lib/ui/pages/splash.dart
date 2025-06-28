part of 'pages.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Wrapper();
      }));
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
              decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage("assets/logo.png"))),
            ),
          )),
    );
  }
}
