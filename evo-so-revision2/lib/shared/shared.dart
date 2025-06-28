import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:evo_new_sales_order/loader/color_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:another_flushbar/flushbar.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../loader/color_loader.dart';
import '../models/models.dart';

part 'theme.dart';
part 'shared_function.dart';
part 'shared_value.dart';
part 'shared_components.dart';
