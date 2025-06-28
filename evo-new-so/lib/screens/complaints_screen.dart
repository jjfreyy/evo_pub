part of 'screens.dart';

class ComplaintsScreen extends StatefulWidget {
  const ComplaintsScreen({Key? key}) : super(key: key);

  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  final cubit = ComplaintsCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocConsumer<ComplaintsCubit, CState>(
        listener: (context, state) {
          if (state != CState.expiredToken) return;
          navigateTo(context, const SigninScreen(), true);
        },
        builder: (context, state) {
          Widget body = buildLoader();

          if (state == CState.init) {
            cubit.init();
          } else if ([CState.idle, CState.changing, CState.updating]
              .contains(state)) {
            body = buildComplaintsScreen(state);
          }

          return Scaffold(
            body: body,
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add, color: Colors.white),
              backgroundColor: mainColor,
              onPressed: () => navigateTo(context, const SaveComplaintScreen()),
            ),
          );
        },
      ),
    );
  }

  Widget buildComplaintsScreen(CState state) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15.0),
            Row(
              children: [
                buildDatePicker('Dari', cubit.tgl1),
                buildDatePicker('Sampai', cubit.tgl2),
              ],
            ),
            buildStatusDropdown(),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: cubit.complaints.length,
                itemBuilder: (context, i) {
                  return GestureDetector(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildImage(i),
                              buildComplaintDetails(i),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        navigateTo(
                            context,
                            ComplaintDetailScreen(
                                complaint: cubit.complaints[i]));
                      });
                },
              ),
            ),
          ],
        ),
        [CState.changing, CState.updating].contains(state)
            ? buildLoader()
            : const SizedBox(),
      ],
    );
  }

  Container buildDatePicker(String label, DateTime tgl) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: getScreenSize(context).width / 2,
      child: Row(
        children: [
          Text(label),
          const SizedBox(width: 5.0),
          Expanded(
            child: Container(
              height: 25.0,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black45),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    cubit.dateFormatter.format(tgl),
                    style: const TextStyle(
                      fontSize: 13.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onTap: () => cubit.updateTgl(context, label),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildStatusDropdown() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: getScreenSize(context).width * 0.75,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text('Status'),
          const SizedBox(width: 10.0),
          Expanded(
            child: DropdownButton(
              style: const TextStyle(color: Colors.black54),
              value: cubit.currentSt,
              items: cubit.stList.map((st) {
                return DropdownMenuItem<int>(
                  value: st,
                  child: Text(st == 0
                      ? 'Semua'
                      : st == 1
                          ? 'Dalam Antrian'
                          : st == 2
                              ? 'Sedang Dikerjakan'
                              : st == 3
                                  ? 'Selesai'
                                  : 'Batal'),
                );
              }).toList(),
              onChanged: (value) {
                if (int.tryParse(value.toString()) == null) return;
                cubit.updateStatus(int.parse(value.toString()));
              },
              isExpanded: true,
            ),
          ),
        ],
      ),
    );
  }

  Container buildImage(int i) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      height: 100,
      width: 100,
      child: CachedNetworkImage(
        imageUrl: apiUrl('uploads/complaints/${cubit.complaints[i].img}'),
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) =>
            const Icon(Icons.error, color: Colors.red),
        fit: BoxFit.cover,
      ),
    );
  }

  Expanded buildComplaintDetails(int i) {
    Widget buildComplaintDetailRow(IconData icon, String text) {
      return Row(
        children: [
          Icon(
            icon,
            size: 20.0,
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 13.0,
            ),
          ),
        ],
      );
    }

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cubit.complaints[i].judul,
            style: const TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            DateFormat('dd MMM yyyy HH:mm:ss')
                .format(cubit.complaints[i].tglInput!),
            style: const TextStyle(
              fontSize: 13.0,
            ),
          ),
          const Divider(),
          buildComplaintDetailRow(
              Icons.person_outline, cubit.complaints[i].namaLengkap),
          const SizedBox(
            height: 3.0,
          ),
          Row(
            children: [
              const Icon(
                Icons.all_inclusive,
                size: 20.0,
              ),
              user.id == 1 && cubit.complaints[i].st != 3
                  ? Expanded(
                      child: DropdownButton(
                        style: const TextStyle(color: Colors.black54),
                        value: cubit.complaints[i].st,
                        items: cubit.stList
                            .where((c) => c != 0 && c != 3)
                            .map((st) {
                          return DropdownMenuItem<int>(
                            value: st,
                            child: Text(st == 1
                                ? 'Dalam Antrian'
                                : st == 2
                                    ? 'Sedang Dikerjakan'
                                    : st == 3
                                        ? 'Selesai'
                                        : 'Batal'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (int.tryParse(value.toString()) == null) return;
                          cubit.updateComplaintStatus(
                              i, int.parse(value.toString()));
                        },
                        isExpanded: true,
                      ),
                    )
                  : Text(
                      cubit.complaints[i].st == 1
                          ? 'Dalam Antrian'
                          : cubit.complaints[i].st == 2
                              ? 'Sedang Dikerjakan'
                              : cubit.complaints[i].st == 3
                                  ? 'Selesai'
                                  : 'Batal',
                      style: const TextStyle(
                        fontSize: 13.0,
                      ),
                    ),
            ],
          ),
          const SizedBox(height: 3.0),
          cubit.complaints[i].tglSelesai == null
              ? const SizedBox()
              : buildComplaintDetailRow(
                  Icons.check_circle_outline_outlined,
                  DateFormat('dd MMM yyyy HH:mm:ss')
                      .format(cubit.complaints[i].tglSelesai!)),
        ],
      ),
    );
  }
}
