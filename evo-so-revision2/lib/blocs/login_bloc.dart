part of 'blocs.dart';

class LoginCubit extends Cubit<BlocState> implements IBloc {
  LoginCubit() : super(BlocState.idle);

  @override
  bool fSuccess = true;
  @override
  String fTitle = '';
  @override
  String fMsg = '';

  @override
  void changeState(BlocState newState) {}

  @override
  void dispose() {}  

  @override
  Future<void> init() async {}

  @override
  void resetFlushbar() {}

  Future<String?> login(String name, String password) async {
    final result = await fetchPost2(
        'signin',
        {
          'type': 'signin',
          'username': name,
          'password': password,
        },
        withToken: false);

    if (!result.success) return result.msg;

    final token = result.value['token'];
    final prefs = await getSharedPreferences();
    prefs.setString('token', token);

    final userData = Jwt.parseJwt(token);
    kodePerusahaan = userData['Kode_Perusahaan'];
    userID = userData['UserID'];
    lokasi = userData['Lokasi'];

    return null;
  }
}
