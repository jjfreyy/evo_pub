part of 'shared.dart';

Widget buildSearchBar(TextEditingController tec, Function onChanged) {
  return Container(
      height: 35,
      margin: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 8),
      child: TextFormField(
        style: GoogleFonts.openSans().copyWith(fontSize: 14.0),
        controller: tec,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(5.0),
            ),
            contentPadding: const EdgeInsets.only(top: 10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: Colors.red, width: 2.0),
            ),
            prefixIcon: const Icon(Icons.search),
            hintText: 'Search'),
        onChanged: (value) => onChanged(),
      ));
}

Future<dynamic> showConfirmDialog(
    {required BuildContext context,
    String? title,
    required String dialogTitle,
    Color? bgColor}) async {
  const radius = 7.5;
  Widget buildConfirmButton(
      IconData iconData, Function onPressed, Color bgColor) {
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

  final result = await showGeneralDialog(
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
              child: buildDialogWidget(
                context: context,
                title: title,
                radius: radius,
                widget: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dialogTitle),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          buildConfirmButton(
                            Icons.close,
                            () => Navigator.pop(context),
                            appbarColor,
                          ),
                          const SizedBox(width: 5.0),
                          buildConfirmButton(
                              Icons.check,
                              () => Navigator.pop(context, true),
                              Colors.green.shade500),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ),
      );
    },
  );
  return result;
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
              child: buildDialogWidget(
                  context: context,
                  title: title,
                  widget: widget,
                  radius: radius)),
        ),
      );
    },
  );
}

Widget buildDialogWidget(
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
            color: appbarColor,
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

Widget showLoader([bool withBackground = false, double topMargin = 0.0]) {
  Widget loader = const Center(
    child: ColorLoader3(
      radius: 15.0,
      dotRadius: 6.0,
    ),
  );
  if (withBackground) {
    loader = Container(
      margin: EdgeInsets.only(top: topMargin),
      color: Colors.black.withOpacity(0.55),
      child: loader,
    );
  }
  return loader;
}

void showFlushbar(
    {String? title,
    required String msg,
    required BuildContext context,
    backgroundColor = Colors.black87}) {
  if (title == null || title.isEmpty) title = null;
  Flushbar(
    title: title,
    message: msg,
    duration: const Duration(seconds: 3),
    backgroundColor: backgroundColor,
  ).show(context);
}
