import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart';

GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<Client>(() => Client());
  getIt.registerLazySingleton<JsonDecoder>(() => JsonDecoder());
}