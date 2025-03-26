import 'package:dartz/dartz.dart';
import 'package:goshops/infrastructure/model/model/translation_model.dart';
import 'package:goshops/infrastructure/model/response/currencies_response.dart';
import 'package:goshops/infrastructure/model/response/global_settings_response.dart';
import 'package:goshops/infrastructure/model/response/help_response.dart';
import 'package:goshops/infrastructure/model/response/languages_response.dart';
import 'package:goshops/infrastructure/model/response/mobile_translations_response.dart';

abstract class SettingsInterface {

  Future<Either<GlobalSettingsResponse,dynamic>> getGlobalSettings();

  Future<Either<MobileTranslationsResponse,dynamic>> getMobileTranslations({String? lang});

  Future<Either<LanguagesResponse,dynamic>> getLanguages();

  Future<Either<CurrenciesResponse,dynamic>> getCurrencies();

  Future<Either<HelpResponseModel,dynamic>> getFaq();

  Future<Either<bool,dynamic>> getAdminInfo();

  Future<Either<Translation,dynamic>> getPolicy();

  Future<Either<Translation,dynamic>> getTerm();
}
