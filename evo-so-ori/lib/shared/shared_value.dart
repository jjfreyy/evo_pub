part of 'shared.dart';

String myUrl = "";

String lokasi = "DISTRIBUTOR";
String kodePerusahaan = "001";

String pemisah = "##";
String kodeUnik = "R451";

String kodeCust = "";
String namaCust = "";
String jnsTransaksiCustomer = "Tunai";
String userID = "HENDRY";

String bolehACC = "T";
String bolehSpcReq = "T";
String bolehNaikPlafon = "T";
String bolehTambahLamaJT = "T";
String bolehACCStock = "T";

String roleACC = "Y";
String roleSpcReq = "Y";
String roleNaikPlafon = "Y";
String roleTambahLamaJT = "Y";
String roleACCStock = "Y";
String roleGantiLokasi = "Y";
String roleRefresh = "Y";
String roleRefreshKhusus = "Y";
String roleBatal = "Y";
String roleBatalSdgProses = "Y";

String versi = "1.0.0.4";

String noImageUrl =
    "https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg";

Center tidakAdaData() {
  return Center(
    child: Text(
      "Data tidak ada!",
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 15,
      ),
    ),
  );
}
