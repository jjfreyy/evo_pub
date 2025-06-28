part of 'cubits.dart';

class SaveComplaintCubit extends Cubit<CState> implements JCubit {
  SaveComplaintCubit(this.complaint) : super(CState.init);

  final Complaint? complaint;
  late ImagePicker picker;
  XFile? pfImg;
  String? errDeskripsi;
  String? errImg;
  String? errJudul;
  late bool saveImg;
  late TextEditingController tecDeskripsi;
  late TextEditingController tecJudul;

  @override
  void changeState(CState newState) {
    if (!isClosed) emit(newState);
  }

  @override
  Future<void> init() async {
    changeState(CState.loading);
    await Future.delayed(Duration(milliseconds: initDelay));

    picker = ImagePicker();
    saveImg = true;
    tecDeskripsi = TextEditingController();
    tecJudul = TextEditingController();
    if (complaint != null) {
      saveImg = false;
      tecJudul.text = complaint!.judul;
      tecDeskripsi.text = complaint!.deskripsi;
    }

    changeState(CState.idle);
  }

  void saveComplaint() async {
    changeState(CState.saving);

    try {
      bool hasError = false;
      final judul = tecJudul.text.trim();
      final deskripsi = tecDeskripsi.text.trim();

      if (judul.isEmpty) {
        errJudul = 'Bidang judul diperlukan.';
        hasError = true;
      } else {
        errJudul = null;
      }
      if (deskripsi.isEmpty) {
        errDeskripsi = 'Bidang deskripsi diperlukan.';
        hasError = true;
      } else {
        errDeskripsi = null;
      }
      if (saveImg && pfImg == null) {
        errImg = 'Bidang gambar diperlukan.';
        hasError = true;
      } else {
        errImg = null;
      }

      if (hasError) return changeState(CState.idle);

      if (await isTokenExpired()) {
        return changeState(CState.expiredToken);
      }

      final prefs = await getSharedPreferences();
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl('put')));

      if (saveImg) {
        File file = File(pfImg!.path);
        request.files.add(http.MultipartFile(
          'img',
          file.readAsBytes().asStream(),
          file.lengthSync(),
          filename: file.path,
          contentType: MediaType('image', 'jpeg'),
        ));
      }

      Map<String, String> headers = {
        'Accept': 'application/json',
        'Content-Type': 'multipart/form-data',
        'Authorization': prefs.getString('token') ?? '',
      };
      request.headers.addAll(headers);
      request.fields.addAll({
        'id': complaint == null ? '' : complaint!.id.toString(),
        'type': 'saveComplaint',
        'judul': judul,
        'deskripsi': deskripsi,
        'saveImg': saveImg ? '1' : '0',
      });
      final response = await request.send();
      final body = jsonDecode(await response.stream.bytesToString());
      
      Color bgColor = Colors.red;
      if (response.statusCode == 200) {
        bgColor = Colors.green;
        tecJudul.text = '';
        tecDeskripsi.text = '';
        pfImg = null;
      } else {
        errJudul = body['feedbacks']['judul']['msg'];
        errDeskripsi = body['feedbacks']['deskripsi']['msg'];
        errImg = body['feedbacks']['img']['msg'];
      }

      showToast(body['msg'], bgColor);
    } catch (_) {
      if (debug) dd(_);
      showToast(serverErrorMsg);
    }

    if (complaint != null) {
      return changeState(CState.navigating);
    }
    changeState(CState.idle);
  }

  void showImagePickerOptions(BuildContext context) {
    changeState(CState.updating);

    Widget buildListTile(IconData iconData, String title, ImageSource source) {
      return ListTile(
          leading: Icon(iconData),
          title: Text(title),
          onTap: () async {
            pfImg = await picker.pickImage(source: source);
            if (pfImg != null) saveImg = true;
            Navigator.pop(context);
            changeState(CState.idle);
          });
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: const Color(0xFF737373),
              child: Container(
                child: Column(
                  children: <Widget>[
                    buildListTile(Icons.camera_alt, 'Ambil foto dengan kamera',
                        ImageSource.camera),
                    buildListTile(Icons.photo_library, 'Ambil foto dari galeri',
                        ImageSource.gallery),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
