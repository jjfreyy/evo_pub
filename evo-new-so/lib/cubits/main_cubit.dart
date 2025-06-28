part of 'cubits.dart';

class MainCubit extends Cubit<CState> implements JCubit {
  MainCubit() : super(CState.init);

  late List<BottomNavigationBarItem> bottomNavbarItems;
  final Color color1 = const Color(0xFF37474f);
  final Color color2 = const Color(0xFFf7941e);
  late int currentIndex;
  late FirebaseMessaging msg;
  late List<Widget> menus;
  late String title;

  @override
  void changeState(CState newState) {
    if (!isClosed) emit(newState);
  }

  @override
  Future<void> init() async {
    changeState(CState.loading);
    await Future.delayed(Duration(milliseconds: initDelay));

    currentIndex = 0;
    bottomNavbarItems = [
      const BottomNavigationBarItem(
        label: 'Komplain',
        icon: Icon(Icons.desktop_windows),
      ),
    ];
    menus = [
      const ComplaintsScreen(),
    ];
    if (user.userLevel == 1) {
      bottomNavbarItems.add(const BottomNavigationBarItem(
        label: 'Proyek',
        icon: Icon(Icons.apps),
      ));
      menus.add(const ProjectsScreen());
    }
    bottomNavbarItems.add(const BottomNavigationBarItem(
      label: 'Profile',
      icon: Icon(Icons.person_pin),
    ));
    menus.add(const ProfileScreen());

    changeState(CState.idle);
  }

  void changeTab(int selected) {
    changeState(CState.changing);
    currentIndex = selected;
    changeState(CState.idle);
  }
}
