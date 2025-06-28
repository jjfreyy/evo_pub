part of "pages.dart";

class ErrorPage500 extends StatelessWidget {
  const ErrorPage500({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            height: MediaQuery.of(context).size.height * 0.35,
            fit: BoxFit.cover,
            image: AssetImage("assets/error3.jpg"),
          ),
          SizedBox(height: 10),
          Text("Oops!",
              style: GoogleFonts.openSans().copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                  fontSize: 15.0)),
          SizedBox(
            height: 10,
          ),
          Text("Internal server error.",
              style: GoogleFonts.openSans().copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0)),
          SizedBox(
            height: 5,
          ),
          Text(
            "Harap laporkan masalah ini, agar kami dapat segera memperbaikinya.",
            style: GoogleFonts.openSans().copyWith(
                color: Colors.red, fontWeight: FontWeight.w500, fontSize: 16.0),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
