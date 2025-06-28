part of 'screens.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    mainCubit = MainCubit();
    msg = FirebaseMessaging.instance;
    msg.subscribeToTopic(user.username);
    FirebaseMessaging.onMessage.listen((event) {
      showToast(event.notification!.title!, Colors.green);
      // dd(event.notification!.title);
      // dd(event.notification!.body);
      // dd(event.data.values);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      showToast(event.notification!.title!, Colors.green);
      // dd(event.notification!.title);
      // dd(event.notification!.body);
      // dd(event.data.values);
    });
    dd('subscribe to ${user.username}');
    super.initState();
  }

  @override
  void dispose() {
    msg.unsubscribeFromTopic(user.username);
    dd('unsubscribe from ${user.username}');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => mainCubit,
      child: BlocConsumer<MainCubit, CState>(
        listener: (context, state) {
          if (state != CState.expiredToken) return;
          navigateTo(context, const SigninScreen(), true);
        },
        builder: (context, state) {
          Widget body = buildLoader();
          Widget? bottomNavbar;

          if (state == CState.init) {
            mainCubit.init();
          } else if ([CState.idle].contains(state)) {
            body = mainCubit.menus[mainCubit.currentIndex];
            bottomNavbar = buildBottomNavbar();
          }

          return SafeArea(
            child: Scaffold(
              body: body,
              bottomNavigationBar: bottomNavbar,
            ),
          );
        },
      ),
    );
  }

  BottomNavigationBar buildBottomNavbar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: mainCubit.currentIndex,
      onTap: (value) => mainCubit.changeTab(value),
      selectedFontSize: 9,
      unselectedFontSize: 8,
      iconSize: 25,
      selectedLabelStyle:
          TextStyle(color: mainCubit.color2, fontWeight: FontWeight.bold),
      unselectedLabelStyle:
          TextStyle(color: mainCubit.color1, fontWeight: FontWeight.bold),
      selectedItemColor: mainCubit.color2,
      unselectedItemColor: mainCubit.color1,
      items: mainCubit.bottomNavbarItems,
    );
  }
}
