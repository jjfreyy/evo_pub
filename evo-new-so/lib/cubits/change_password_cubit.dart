part of 'cubits.dart';

class ChangePasswordCubit extends Cubit<CState> implements JCubit {
  ChangePasswordCubit() : super(CState.init);

  String? errPass;
  String? errNewPass;
  late bool obscurePass;
  late bool obscureNewPass;
  late bool obscureConfirmPass;
  late TextEditingController tecPass;
  late TextEditingController tecNewPass;
  late TextEditingController tecConfirmPass;

  @override
  void changeState(CState newState) {
    if (!isClosed) emit(newState);
  }

  @override
  Future<void> init() async {
    changeState(CState.loading);
    await Future.delayed(Duration(milliseconds: initDelay));

    obscurePass = true;
    obscureNewPass = true;
    obscureConfirmPass = true;
    tecPass = TextEditingController();
    tecNewPass = TextEditingController();
    tecConfirmPass = TextEditingController();

    changeState(CState.idle);
  }

  void changePassword() async {
    changeState(CState.updating);

    bool hasError = false;
    final pass = tecPass.text.trim();
    final newPass = tecNewPass.text.trim();
    final confirmPass = tecConfirmPass.text.trim();

    if (pass.isEmpty) {
      errPass = 'Bidang password diperlukan.';
      hasError = true;
    } else {
      errPass = null;
    }
    if (newPass.isEmpty) {
      errNewPass = 'Bidang password baru diperlukan.';
      hasError = true;
    } else if (newPass != confirmPass) {
      errNewPass = 'Password baru dan konfirmasi password tidak sama.';
      hasError = true;
    } else {
      errNewPass = null;
    }

    if (hasError) return changeState(CState.idle);

    final response = await fetchPost2(
      'auth',
      {
        'type': 'changePassword',
        'pass': pass,
        'newPass': newPass,
        'confirmPass': confirmPass,
      },
      debugging: true,
    );

    if (response.isTokenExpired) return changeState(CState.expiredToken);

    final msg = response.msg!;
    if (!response.success) {
      errPass = response.feedbacks['pass']['msg'];
      errNewPass = response.feedbacks['newPass']['msg'];
      showToast(msg);
      return changeState(CState.idle);
    }

    errPass = null;
    errNewPass = null;
    tecPass.text = '';
    tecNewPass.text = '';
    tecConfirmPass.text = '';
    showToast(msg, Colors.green);
    changeState(CState.idle);
  }

  void toggleObscureText(String label) {
    changeState(CState.changing);

    label = label.toLowerCase();
    if (label == 'password') {
      obscurePass = !obscurePass;
    } else if (label == 'password baru') {
      obscureNewPass = !obscureNewPass;
    } else if (label == 'konfirmasi password') {
      obscureConfirmPass = !obscureConfirmPass;
    }

    changeState(CState.idle);
  }
}
