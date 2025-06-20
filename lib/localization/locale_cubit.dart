import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/utils/cashed_data_shared_preferences.dart';



class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('ar')) {
    _loadSavedLanguage();
  }

static LocaleCubit get(context) => BlocProvider.of(context);

  void changeLanguage(String languageCode) async {
    emit(Locale(languageCode));
    await CacheService.setData(
        key: CacheKeys.defaultLanguage, value: languageCode);
  }

  String changeFontFamily() {
    return state.languageCode == 'ar' ? 'NotoSansArabic' : 'Roboto';
  }

  void _loadSavedLanguage() {
    final savedLanguage =
        CacheService.getData(key: CacheKeys.defaultLanguage) ?? 'en';
    emit(Locale(savedLanguage));
  }
}
