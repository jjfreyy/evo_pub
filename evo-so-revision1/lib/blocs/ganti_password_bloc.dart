part of "bloc_shared.dart";

class GantiPasswordCubit extends Cubit<String> {
  GantiPasswordCubit() : super("init");

  bool fSuccess = true;
  String fMsg = "";

  late TextEditingController tecPasswordLama;
  late TextEditingController tecPasswordBaru;
  late TextEditingController tecKonfirmasiPassword;
  late List<bool> obscuredPassword;
  late List<String?> errorMsgs;

  void _changeState(String newState) {
    if (!isClosed) emit(newState);
  }

  void _resetErrorMsgs() {
    errorMsgs = [null, null, null];
  }

  Future<void> gantiPassword() async {
    _changeState("showLoader");

    try {
      _resetErrorMsgs();

      if (tecPasswordLama.text.trim().isEmpty) {
        errorMsgs[0] = "Password Lama harus diisi!";
        return _changeState("idle");
      }
      if (tecPasswordBaru.text.trim().isEmpty) {
        errorMsgs[1] = "Password Baru harus diisi!";
        return _changeState("idle");
      }
      if (tecPasswordBaru.text.trim() != tecKonfirmasiPassword.text.trim()) {
        errorMsgs[1] = "Password baru dan konfirmasi password tidak sama!";
        return _changeState("idle");
      }

      final response = await fetchPost("change-password", {
        "type": "ubah_password",
        "passwordLama": tecPasswordLama.text,
        "passwordBaru": tecPasswordBaru.text,
        "konfirmasiPassword": tecKonfirmasiPassword.text,
      });

      if (response.statusCode == 500) {
        fSuccess = false;
        fMsg = getInternalServerMsg();
        return _changeState("idle");
      }

      final jsonBody = jsonDecode(response.body);
      if (response.statusCode != 200) {
        fSuccess = false;
        fMsg = jsonBody["msg"];
        return _changeState("idle");
      }

      tecPasswordLama.text = "";
      tecPasswordBaru.text = "";
      tecKonfirmasiPassword.text = "";

      fSuccess = true;
      fMsg = jsonBody["msg"];
    } catch (_) {
      if (debug) dd(_);
      fSuccess = false;
      fMsg = getInternalServerMsg();
    }

    _changeState("idle");
  }

  Future<void> init() async {
    _changeState("loading");
    await Future.delayed(Duration(milliseconds: initDelay));
    tecPasswordLama = TextEditingController();
    tecPasswordBaru = TextEditingController();
    tecKonfirmasiPassword = TextEditingController();
    obscuredPassword = [true, true, true];
    _resetErrorMsgs();
    _changeState("idle");
  }

  void resetFlushbar() {
    fMsg = "";
  }

  Future<void> togglePasswordVisibility(int i) async {
    _changeState("togglePassword");
    obscuredPassword[i] = !obscuredPassword[i];
    _changeState("idle");
  }
}
