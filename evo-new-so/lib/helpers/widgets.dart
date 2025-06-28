part of 'helpers.dart';

PreferredSize buildAppBar(String title) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(55.0),
    child: AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );
}

Widget buildConfirmButton(IconData iconData, Function onPressed, Color bgColor) {
  return Container(
    height: 30.0,
    width: 45.0,
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(25.0),
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(iconData),
          color: Colors.white,
          onPressed: () => onPressed(),
          alignment: AlignmentDirectional.center,
        ),
      ),
    ),
  );
}

Widget buildDialog(
    {required BuildContext context,
    String? title,
    required Widget widget,
    required double radius}) {
  bool isClosed = false;
  return Padding(
    padding: const EdgeInsets.only(bottom: 2.5),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 30.0,
          decoration: BoxDecoration(
            color: mainColor,
            borderRadius:
                BorderRadiusDirectional.vertical(top: Radius.circular(radius)),
          ),
          child: Row(
            mainAxisAlignment: isEmpty(title)
                ? MainAxisAlignment.end
                : MainAxisAlignment.spaceBetween,
            children: [
              isEmpty(title)
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        title!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
              InkWell(
                child: const Icon(
                  Icons.close,
                  size: 30.0,
                  color: Colors.white,
                ),
                onTap: () {
                  if (!isClosed) {
                    isClosed = true;
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: widget,
        ),
      ],
    ),
  );
}

Widget buildLoader([bool withBackground = true, size = 15.0]) {
  Widget loader = Center(
    child: SpinKitThreeBounce(
      color: loaderColor,
      size: size,
    ),
  );

  if (withBackground) {
    loader = Container(
      color: Colors.black.withOpacity(0.4),
      child: loader,
    );
  }

  return loader;
}

void showCustomDialog(
    {required BuildContext context,
    String? title,
    required Widget widget}) async {
  const radius = 7.5;
  showGeneralDialog(
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) => Container(),
    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: const Color(0x80000000),
    transitionDuration: const Duration(milliseconds: 300),
    transitionBuilder: (context, a1, a2, child) {
      return Transform.scale(
        scale: a1.value,
        child: Opacity(
          opacity: a1.value,
          child: Dialog(
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 25.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
              side: const BorderSide(color: Colors.white, width: 1.5),
            ),
            child: buildDialog(
              context: context,
              title: title,
              widget: widget,
              radius: radius,
            ),
          ),
        ),
      );
    },
  );
}

void showToast(String msg, [Color bgColor = Colors.red]) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: msg,
    backgroundColor: bgColor,
    toastLength: Toast.LENGTH_LONG,
    fontSize: 13.0,
  );
}
