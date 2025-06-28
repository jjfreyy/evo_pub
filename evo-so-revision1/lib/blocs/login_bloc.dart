part of "bloc_shared.dart";

class LoginCubit extends Cubit<String> {
  LoginCubit() : super("idle");

  Future<String?> login(String name, String password) async {
    try {
      final response = await fetchPost(
          "signin",
          {
            "type": "signin",
            "username": name,
            "password": password,
          },
          false);

      if (response.statusCode == 500) throw Exception("Status Code 500!");

      final jsonBody = jsonDecode(response.body);
      if (response.statusCode != 200) {
        return jsonBody["msg"];
      }

      final token = jsonBody["data"]["token"];
      final prefs = await getSharedPreferences();
      prefs.setString("token", token);

      final userData = Jwt.parseJwt(token);
      kodePerusahaan = userData["Kode_Perusahaan"];
      userID = userData["UserID"];
      lokasi = userData["Lokasi"];

      return null;
    } catch (_) {
      if (debug) dd(_);
      return getInternalServerMsg();
    }
  }
}
