part of 'blocs.dart';

class GantiPasswordCubit extends Cubit<BlocState> implements IBloc {
  GantiPasswordCubit() : super(BlocState.init);

  @override
  bool fSuccess = true;
  @override
  String fTitle = '';
  @override
  String fMsg = '';

  late TextEditingController tecPasswordLama;
  late TextEditingController tecPasswordBaru;
  late TextEditingController tecKonfirmasiPassword;
  late List<bool> obscuredPassword;
  late List<String?> errorMsgs;

  @override
  void changeState(BlocState newState) {
    if (isClosed) return dispose();
    emit(newState);
  }

  @override
  void dispose() {
    tecPasswordLama.dispose();
    tecPasswordBaru.dispose();
    tecKonfirmasiPassword.dispose();
  }

  @override
  Future<void> init() async {
    changeState(BlocState.loading);
    await Future.delayed(Duration(milliseconds: initDelay));
    tecPasswordLama = TextEditingController();
    tecPasswordBaru = TextEditingController();
    tecKonfirmasiPassword = TextEditingController();
    obscuredPassword = [true, true, true];
    _resetErrorMsgs();
    changeState(BlocState.idle);
  }

  @override
  void resetFlushbar() {
    fMsg = '';
  }

  void _resetErrorMsgs() {
    errorMsgs = [null, null, null];
  }

  Future<void> gantiPassword() async {
    changeState(BlocState.updating);

    _resetErrorMsgs();

    if (tecPasswordLama.text.trim().isEmpty) {
      errorMsgs[0] = 'Password Lama harus diisi!';
      return changeState(BlocState.idle);
    }

    if (tecPasswordBaru.text.trim().isEmpty) {
      errorMsgs[1] = 'Password Baru harus diisi!';
      return changeState(BlocState.idle);
    }

    if (tecPasswordBaru.text.trim() != tecKonfirmasiPassword.text.trim()) {
      errorMsgs[1] = 'Password baru dan konfirmasi password tidak sama!';
      return changeState(BlocState.idle);
    }

    final response = await fetchPost2('change-password', {
      'type': 'ubah_password',
      'passwordLama': tecPasswordLama.text,
      'passwordBaru': tecPasswordBaru.text,
      'konfirmasiPassword': tecKonfirmasiPassword.text,
    });

    if (response.isTokenExpired) return changeState(BlocState.expiredToken);

    fMsg = response.msg!;
    if (!response.success) {
      fSuccess = false;
      return changeState(BlocState.idle);
    }

    tecPasswordLama.text = '';
    tecPasswordBaru.text = '';
    tecKonfirmasiPassword.text = '';

    fSuccess = true;
    changeState(BlocState.idle);
  }

  Future<void> togglePasswordVisibility(int i) async {
    changeState(BlocState.changing);
    obscuredPassword[i] = !obscuredPassword[i];
    changeState(BlocState.idle);
  }
}
