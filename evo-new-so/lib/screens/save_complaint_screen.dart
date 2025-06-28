part of 'screens.dart';

class SaveComplaintScreen extends StatefulWidget {
  final Complaint? complaint;

  const SaveComplaintScreen({Key? key, this.complaint}) : super(key: key);

  @override
  State<SaveComplaintScreen> createState() => _SaveComplaintScreenState();
}

class _SaveComplaintScreenState extends State<SaveComplaintScreen> {
  late SaveComplaintCubit cubit = SaveComplaintCubit(widget.complaint);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocConsumer<SaveComplaintCubit, CState>(
        listener: (context, state) {
          if (state == CState.expiredToken) {
            return navigateTo(context, const SigninScreen(), true);
          }
          if (state == CState.navigating) {
            return navigateTo(context, const MainScreen(), true);
          }
        },
        builder: (context, state) {
          Widget body = buildLoader();

          if (state == CState.init) {
            cubit.init();
          } else if ([CState.idle, CState.updating, CState.saving]
              .contains(state)) {
            body = buildSaveComplaintScreen(state);
          }

          return Scaffold(
            appBar: buildAppBar('Pengajuan Komplain'),
            body: body,
          );
        },
      ),
    );
  }

  Widget buildSaveComplaintScreen(CState state) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ListView(
            children: [
              buildTextField(cubit.tecJudul, 'Judul', cubit.errJudul),
              const SizedBox(
                height: 5.0,
              ),
              buildTextField(
                  cubit.tecDeskripsi, 'Deskripsi', cubit.errDeskripsi),
              const SizedBox(
                height: 10.0,
              ),
              buildGambar(),
              const SizedBox(
                height: 5.0,
              ),
              buildSimpanButton(),
            ],
          ),
        ),
        [CState.saving].contains(state) ? buildLoader() : const SizedBox(),
      ],
    );
  }

  TextFormField buildTextField(
      TextEditingController tec, String labelText, String? errorText) {
    return TextFormField(
      controller: tec,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.amber.shade400)),
        labelText: labelText,
        contentPadding: const EdgeInsets.all(0),
        labelStyle: TextStyle(color: Colors.grey.shade600),
        errorText: errorText,
      ),
    );
  }

  Column buildGambar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gambar',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 16.0,
          ),
        ),
        const SizedBox(height: 5.0),
        GestureDetector(
          child: cubit.complaint != null && !cubit.saveImg
              ? Container(
                  padding: const EdgeInsets.all(5.0),
                  height: 200,
                  width: getScreenSize(context).width,
                  child: CachedNetworkImage(
                    imageUrl:
                        apiUrl('uploads/complaints/${cubit.complaint!.img}'),
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error, color: Colors.red),
                    fit: BoxFit.fill,
                  ),
                )
              : cubit.pfImg == null
                  ? Image.asset(
                      'assets/placeholder-img.jpg',
                      fit: BoxFit.cover,
                      height: 200,
                      width: getScreenSize(context).width,
                    )
                  : Image.file(
                      File(cubit.pfImg!.path),
                      fit: BoxFit.fill,
                      height: 200,
                      width: getScreenSize(context).width,
                    ),
          onTap: () => cubit.showImagePickerOptions(context),
        ),
        cubit.errImg == null
            ? const SizedBox()
            : Text(
                cubit.errImg!,
                style: const TextStyle(color: Colors.red, fontSize: 13.0),
              ),
      ],
    );
  }

  Widget buildSimpanButton() {
    return ElevatedButton(
      child: const Text(
        'Simpan',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () => cubit.saveComplaint(),
    );
  }
}
