part of 'screens.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final cubit = ProfileCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocConsumer<ProfileCubit, CState>(
        listener: (context, state) {
          if (state != CState.expiredToken) return;
          navigateTo(context, const SigninScreen(), true);
        },
        builder: (context, state) {
          return Scaffold(
            body: buildProfileScreen(state),
          );
        },
      ),
    );
  }

  ListView buildProfileScreen(CState state) {
    return ListView(
      padding: const EdgeInsets.all(32),
      shrinkWrap: true,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 32),
          padding: const EdgeInsets.all(32),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextUserDetail('Nama', user.namaLengkap),
              buildTextUserDetail('Username', user.username),
              buildTextUserDetail(
                'Posisi',
                user.userLevel == 1
                    ? 'Developer/Super'
                    : user.userLevel == 2
                        ? 'Kacab'
                        : 'Admin',
              ),
              user.idCabang == null
                  ? const SizedBox()
                  : buildTextUserDetail('Cabang', user.cabang!),
              user.idLokasi == null
                  ? const SizedBox()
                  : buildTextUserDetail('Lokasi', user.lokasi!),
            ],
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        buildUbahPasswordButton(),
        buildSignoutButton(),
      ],
    );
  }

  Column buildTextUserDetail(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: Colors.grey[700], fontSize: 13)),
        const SizedBox(height: 4),
        Text(content,
            style: const TextStyle(
                color: Color(0xFF666666),
                fontSize: 15,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
      ],
    );
  }

  TextButton buildUbahPasswordButton() {
    return TextButton(
      child: const Text('Ubah Password'),
      onPressed: () => navigateTo(context, const ChangePasswordScreen()),
    );
  }

  Widget buildSignoutButton() {
    return InkWell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.power_settings_new, color: Colors.red),
          SizedBox(width: 4.0),
          Text(
            'Sign Out',
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
      onTap: () => cubit.signout(),
    );
  }
}
