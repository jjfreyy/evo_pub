import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:flutter/services.dart";
import 'package:flutter_login/flutter_login.dart';
import "package:another_flushbar/flushbar.dart";
import 'package:salesorder/loader/color_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import "package:flutter_bloc/flutter_bloc.dart";
import "package:jwt_decode/jwt_decode.dart";
import 'package:proste_indexed_stack/proste_indexed_stack.dart';

import "package:salesorder/shared/shared.dart";
import "package:salesorder/blocs/bloc_shared.dart";
import "package:salesorder/loader/color_loader.dart";

part 'splash.dart';
part "login_page.dart";
part "dashboard_page.dart";
part "main_page.dart";
part "kat_brg_page.dart";
part "error_page_500.dart";
part "barang_page.dart";
part "paket_page.dart";
part "paket_detail_page.dart";
part "paket_detail_range_page.dart";
part "profile_page.dart";
part "ganti_password_page.dart";
part "checkout_page.dart";
