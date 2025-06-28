part of 'pages.dart';

class PaketPage extends StatefulWidget {
  const PaketPage({Key? key}) : super(key: key);

  @override
  _PaketPageState createState() => _PaketPageState();
}

class _PaketPageState extends State<PaketPage> {
  final PaketCubit cubit = PaketCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocConsumer<PaketCubit, BlocState>(
        listener: (context, state) {
          if (state == BlocState.expiredToken) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false);
          }
        },
        builder: (context, state) {
          Widget body = showLoader();

          if (state == BlocState.init) {
            cubit.init();
          } else if ([BlocState.idle, BlocState.searching].contains(state)) {
            body = Stack(
              children: [
                Column(
                  children: [
                    buildSearchBar(cubit.tecSearch, cubit.searchPaket),
                    _buildPaketList(),
                  ],
                ),
                [BlocState.searching].contains(state)
                    ? showLoader(true, 50)
                    : const SizedBox(),
              ],
            );
          }

          return body;
        },
      ),
    );
  }

  Widget _buildPaketList() {
    return cubit.paketList.isEmpty
        ? Expanded(child: tidakAdaData())
        : Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              // physics: NeverScrollableScrollPhysics(),
              itemCount: cubit.paketList.length,
              itemBuilder: (context, i) {
                return InkWell(
                  child: Card(
                    child: ListTile(
                      title: Text(cubit.paketList[i].kodePaket,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          )),
                      trailing: const Icon(
                        Icons.arrow_right,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                cubit.paketList[i].pakaiRange == 'Y'
                                    ? PaketDetailRangePage(
                                        kodePaket: cubit.paketList[i].kodePaket)
                                    : PaketDetailPage(
                                        kodePaket:
                                            cubit.paketList[i].kodePaket)));
                  },
                );
              },
            ),
          );
  }
}
