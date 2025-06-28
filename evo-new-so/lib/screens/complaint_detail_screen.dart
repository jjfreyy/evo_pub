part of 'screens.dart';

class ComplaintDetailScreen extends StatefulWidget {
  final Complaint complaint;

  const ComplaintDetailScreen({Key? key, required this.complaint})
      : super(key: key);

  @override
  State<ComplaintDetailScreen> createState() => _ComplaintDetailScreenState();
}

class _ComplaintDetailScreenState extends State<ComplaintDetailScreen> {
  late ComplaintDetailCubit cubit = ComplaintDetailCubit(widget.complaint);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocConsumer<ComplaintDetailCubit, CState>(
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
          } else if ([CState.idle, CState.updating].contains(state)) {
            body = buildComplaintDetailScreen(state);
          }

          return Scaffold(
            appBar: buildAppBar('Complaint Detail'),
            body: body,
          );
        },
      ),
    );
  }

  Widget buildComplaintDetailScreen(CState state) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              buildTglInput(),
              buildNamaLengkap(),
              const SizedBox(
                height: 10.0,
              ),
              buildJudul(),
              const SizedBox(height: 5.0),
              buildDeskripsi(),
              buildImg(),
              buildStatus(),
              buildTglSelesai(),
              buildHasil(),
              buildUpdateButton(),
              buildTandaiSelesaiButton(),
            ],
          ),
        ),
        [CState.navigating].contains(state) ? buildLoader() : const SizedBox(),
      ],
    );
  }

  Widget buildTandaiSelesaiButton() {
    return user.userLevel == 1 && cubit.complaint.st != 3 ? ElevatedButton(
      child: const Text('Tandai Selesai'),
      style: ElevatedButton.styleFrom(
        onPrimary: Colors.white,
      ),
      onPressed: () => cubit.tandaiSelesai(context),
    ) : const SizedBox();
  }

  Widget buildUpdateButton() {
    return user.id == cubit.complaint.idUser && cubit.complaint.st != 3 ? ElevatedButton(
      child: const Text('Update'),
      style: ElevatedButton.styleFrom(
        onPrimary: Colors.white,
      ),
      onPressed: () =>
          navigateTo(context, SaveComplaintScreen(complaint: cubit.complaint)),
    ) : const SizedBox();
  }

  Row buildHasil() {
    return Row(
      children: [
        const Expanded(
          flex: 1,
          child: Text(
            'Hasil',
            style: TextStyle(fontSize: 17.0),
          ),
        ),
        const SizedBox(width: 10.0),
        Expanded(flex: 4, child: Text(ifEmptyThen(cubit.complaint.hasil))),
      ],
    );
  }

  Row buildTglSelesai() {
    return Row(
      children: [
        const Expanded(
          flex: 1,
          child: Text(
            'Selesai',
            style: TextStyle(fontSize: 17.0),
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Expanded(
            flex: 4,
            child: Text(
              cubit.complaint.tglSelesai == null
                  ? '-'
                  : DateFormat('dd MMM yyyy HH:mm:ss')
                      .format(cubit.complaint.tglSelesai!),
              style: const TextStyle(
                fontSize: 17.0,
              ),
            )),
      ],
    );
  }

  Container buildStatus() {
    return Container(
      padding: const EdgeInsets.all(0.0),
      width: getScreenSize(context).width * 0.75,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Expanded(
            flex: 1,
            child: Text('Status',
                style: TextStyle(
                  fontSize: 17.0,
                )),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            flex: 4,
            child: Text(
                cubit.complaint.st == 1
                    ? 'Dalam Antrian'
                    : cubit.complaint.st == 2
                        ? 'Sedang Dikerjakan'
                        : cubit.complaint.st == 3
                            ? 'Selesai'
                            : 'Batal',
                style: const TextStyle(fontSize: 17.0)),
          ),
        ],
      ),
    );
  }

  Container buildImg() {
    return Container(
      padding: const EdgeInsets.all(5.0),
      height: 300,
      child: CachedNetworkImage(
        imageUrl: apiUrl('uploads/complaints/${cubit.complaint.img}'),
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) =>
            const Icon(Icons.error, color: Colors.red),
        fit: BoxFit.cover,
      ),
    );
  }

  Text buildDeskripsi() {
    return Text(
      cubit.complaint.deskripsi,
      style: const TextStyle(fontSize: 17.0),
    );
  }

  Text buildJudul() {
    return Text(
      cubit.complaint.judul,
      style: const TextStyle(fontSize: 17.0),
    );
  }

  Text buildNamaLengkap() {
    return Text(
      cubit.complaint.namaLengkap,
      style: const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Text buildTglInput() {
    return Text(
      DateFormat('dd MMM yyyy HH:mm:ss').format(cubit.complaint.tglInput!),
      style: const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
