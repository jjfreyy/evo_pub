part of 'screens.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final cubit = SplashCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocConsumer<SplashCubit, CState>(
        listener: (context, state) {
          if (state != CState.navigating) return;
          
          Widget widget = const SigninScreen();
          if (isAuthorized) {
            widget = const MainScreen();
          }
          navigateTo(context, widget, true);
        },
        builder: (context, state) {
              
          if (state == CState.init) {
            cubit.init();
          } else if (state == CState.idle) {
            cubit.checkSession();
          }

          return SafeArea(
            child: Scaffold(
              body: buildSplashScreen(state),
            ),
          );
        },
      ),
    );
  }

  Column buildSplashScreen(CState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildLogo(),
        buildVersion(state), 
      ],
    );
  }

                  
  Expanded buildLogo() {
    return Expanded(
      child: Center(
        child: Container(
          height: 100,
          width: 100,
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/logo.png'),
          )),
        ),
      ),
    );
  }

  Padding buildVersion(CState state) {
    return Padding(
      
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Center(
        child: state == CState.init
            ? buildLoader(false)
            : Text(
                cubit.appVersion,
                style: const TextStyle(fontSize: 12.0),
              ),
      ),
    );
  }
}
                                                                                              