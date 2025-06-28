part of 'pages.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
        children: <Widget>[
          _buildAvatar(),
          const SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              _buildGantiLokasi(),
              const Divider(),
              _buildGantiPassword(),
              const Divider(),
              const SizedBox(
                height: 50,
              ),
              _buildLogout(),
            ],
          ),
        ],
      ),
    );
  }

  Column _buildAvatar() {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 70, bottom: 10),
          width: 120,
          height: 120,
          child: Stack(
            children: <Widget>[
              CircleAvatar(
                radius: 55,
                backgroundColor: const Color(0xffFDCF09),
                child: Text(
                  userID.substring(0, 1),
                  style: const TextStyle(
                    fontSize: 45,
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width - 2 * 5,
          child: Text(
            userID,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.clip,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width - 2 * 5,
          child: Text(
            lokasi,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.clip,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }

  Visibility _buildGantiLokasi() {
    return Visibility(
      visible: roleGantiLokasi == 'Y' ? true : false,
      child: InkWell(
        onTap: () async {},
        child: SizedBox(
          height: 35.0,
          child: Row(
            children: const [
              SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 24,
                height: 24,
                child: Icon(
                  Icons.location_city,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Ganti Lokasi',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  InkWell _buildGantiPassword() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const GantiPasswordPage(),
          ),
        );
      },
      child: SizedBox(
        height: 35.0,
        child: Row(
          children: const [
            SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 24,
              height: 24,
              child: Icon(Icons.vpn_key, color: Colors.black),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Ganti Password',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
      ),
    );
  }

  GestureDetector _buildLogout() {
    return GestureDetector(
      onTap: () {
        clearSharedPreferences();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      },
      child: const Center(
          child: Text(
        'Logout',
        style: TextStyle(
          color: Colors.red,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
      )),
    );
  }
}
