part of 'screens.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final cubit = SigninCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocConsumer<SigninCubit, CState>(
        listener: (context, state) {
          if (cubit.isAuthorized) navigateTo(context, const MainScreen(), true);
        },
        builder: (context, state) {
          Widget body = buildLoader();

          if (state == CState.init) {
            cubit.init();
          } else if ([CState.idle, CState.processing].contains(state)) {
            body = buildSigninScreen(state);
          }

          return Scaffold(
            body: body,
          );
        },
      ),
    );
  }

  Widget buildSigninScreen(CState state) {
    return Stack(
      children: [
        buildTopRightCircle(),
        buildTopLeftCircle(),
        buildBottomRightCircle(),
        Align(
          alignment: Alignment.bottomCenter,
          child: ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5)),
                margin: const EdgeInsets.fromLTRB(24, 300, 24, 10),
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 25),
                child: Column(
                  children: <Widget>[buildUsername(), buildPassword()],
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(24, 0, 24, 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildSigninButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
        [CState.processing].contains(state)
            ? Container(
                color: Colors.black.withOpacity(0.55),
                child: buildLoader(),
              )
            : const SizedBox(),
      ],
    );
  }

  TextField buildUsername() {
    return TextField(
      controller: cubit.tecUsername,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
          icon: Icon(
            Icons.person_rounded,
            color: cubit.color2,
          ),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: cubit.color2)),
          labelText: 'Username',
          labelStyle: TextStyle(color: cubit.color2)),
    );
  }

  TextField buildPassword() {
    return TextField(
      controller: cubit.tecPassword,
      obscureText: cubit.obscureText,
      decoration: InputDecoration(
        icon: Icon(
          Icons.vpn_key,
          color: cubit.color2,
        ),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: cubit.color2)),
        labelText: 'Password',
        labelStyle: TextStyle(color: cubit.color2),
        suffixIcon: IconButton(
            icon: Icon(
                cubit.obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey[700],
                size: 20),
            onPressed: () {
              cubit.toggleObscureText();
            }),
      ),
    );
  }

  TextButton buildSigninButton() {
    return TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) => Colors.transparent,
          ),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
        ),
        onPressed: () {
          cubit.signin();
        },
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [cubit.color3, cubit.color2],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Container(
            constraints: const BoxConstraints(
                maxWidth: 190, minHeight: 40), // min sizes for Material buttons
            alignment: Alignment.center,
            child: const Text(
              'SIGN IN',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
        ));
  }

  Positioned buildTopLeftCircle() {
    return Positioned(
      top: -cubit.getBigDiameter(context) / 4,
      left: -cubit.getBigDiameter(context) / 4,
      child: Container(
        child: Center(
          child: Container(
            alignment: const Alignment(0.2, 0.2),
            child: Image.asset('assets/logo.png', height: 120),
          ),
        ),
        width: cubit.getBigDiameter(context),
        height: cubit.getBigDiameter(context),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
                colors: [cubit.color4, cubit.color3],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
      ),
    );
  }

  Positioned buildTopRightCircle() {
    return Positioned(
      top: -cubit.getSmallDiameter(context) / 3,
      right: -cubit.getSmallDiameter(context) / 3,
      child: Container(
        width: cubit.getSmallDiameter(context),
        height: cubit.getSmallDiameter(context),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
              colors: [cubit.color2, cubit.color3],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
      ),
    );
  }

  Positioned buildBottomRightCircle() {
    return Positioned(
      bottom: -cubit.getBigDiameter(context) / 2,
      right: -cubit.getBigDiameter(context) / 2,
      child: Container(
        width: cubit.getBigDiameter(context),
        height: cubit.getBigDiameter(context),
        decoration: BoxDecoration(shape: BoxShape.circle, color: cubit.color4),
      ),
    );
  }
}
