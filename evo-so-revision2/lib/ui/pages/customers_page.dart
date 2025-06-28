part of 'pages.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({Key? key}) : super(key: key);

  @override
  _CustomersPageState createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  final CustomersCubit cubit = CustomersCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => cubit,
        child: BlocConsumer<CustomersCubit, BlocState>(
          listener: (context, state) {
            if (state == BlocState.expiredToken) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false);
            } else if (cubit.fMsg.isNotEmpty) {
              showFlushbar(
                  msg: cubit.fMsg,
                  context: context,
                  backgroundColor: cubit.fSuccess ? Colors.green : Colors.red);
              cubit.resetFlushbar();
            }
          },
          builder: (context, state) {
            Widget body = showLoader();
            if (state == BlocState.init) {
              cubit.init();
            } else if ([BlocState.idle, BlocState.searching].contains(state)) {
              body = buildCustomers(state);
            }

            return Scaffold(
              appBar: AppBar(
                  title: const Text('Pilih Customer'),
                  backgroundColor: appbarColor,
                  actions: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const MainPage()),
                                (Route<dynamic> route) => false);
                          },
                          child: const Icon(
                            Icons.home,
                            size: 26.0,
                          ),
                        )),
                  ]),
              body: body,
            );
          },
        ));
  }

  Widget buildCustomers(BlocState state) {
    return Stack(
      children: [
        Column(children: <Widget>[
          buildSearchBar(cubit.tecSearch, cubit.searchCustomers),
          buildCustomerList(),
        ]),
        [BlocState.searching].contains(state)
            ? showLoader(true, 50)
            : const SizedBox(),
      ],
    );
  }

  Widget buildCustomerList() {
    return cubit.customers.isEmpty
        ? Expanded(child: tidakAdaData())
        : ListView.builder(
            shrinkWrap: true,
            // physics: const NeverScrollableScrollPhysics(),
            itemCount: cubit.customers.length,
            itemBuilder: (context, i) {
              return Card(
                  child: ListTile(
                title: Text(cubit.customers[i].nama,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    )),
                trailing: const Icon(
                  Icons.navigate_next,
                  color: Colors.red,
                ),
                onTap: () {
                  Navigator.pop(context, cubit.customers[i]);
                },
              ));
            });
  }
}
