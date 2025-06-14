// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/Auth/data/datasources/Auth_datasource_repo.dart'
    as _i354;
import '../../features/Auth/data/datasources/Auth_datasource_repo_impl.dart'
    as _i485;
import '../../features/Auth/data/repositories_impl/Auth_repo_impl.dart'
    as _i295;
import '../../features/Auth/domain/repositories/Auth_repository.dart' as _i647;
import '../../features/Auth/domain/useCases/Auth_useCase_repo.dart' as _i628;
import '../../features/Auth/domain/useCases/Auth_useCase_repo_impl.dart'
    as _i971;
import '../../features/Auth/presentation/bloc/Auth_cubit.dart' as _i192;
import '../../features/ChatBotAssistant/data/datasources/ChatBotAssistant_datasource_repo.dart'
    as _i196;
import '../../features/ChatBotAssistant/data/datasources/ChatBotAssistant_datasource_repo_impl.dart'
    as _i710;
import '../../features/ChatBotAssistant/data/repositories_impl/ChatBotAssistant_repo_impl.dart'
    as _i16;
import '../../features/ChatBotAssistant/domain/repositories/ChatBotAssistant_repository.dart'
    as _i20;
import '../../features/ChatBotAssistant/domain/useCases/ChatBotAssistant_useCase_repo.dart'
    as _i223;
import '../../features/ChatBotAssistant/domain/useCases/ChatBotAssistant_useCase_repo_impl.dart'
    as _i659;
import '../../features/ChatBotAssistant/presentation/bloc/ChatBotAssistant_cubit.dart'
    as _i582;
import '../../features/ChatBotAssistant/presentation/bloc/directions_cubit/directions_cubit.dart'
    as _i159;
import '../../features/Children/data/datasources/Children_datasource_repo.dart'
    as _i424;
import '../../features/Children/data/datasources/Children_datasource_repo_impl.dart'
    as _i464;
import '../../features/Children/data/repositories_impl/Children_repo_impl.dart'
    as _i750;
import '../../features/Children/domain/repositories/Children_repository.dart'
    as _i151;
import '../../features/Children/domain/useCases/Children_useCase_repo.dart'
    as _i341;
import '../../features/Children/domain/useCases/Children_useCase_repo_impl.dart'
    as _i129;
import '../../features/Children/presentation/bloc/Children_cubit.dart' as _i537;
import '../../features/Home/data/datasources/Home_datasource_repo.dart'
    as _i827;
import '../../features/Home/data/datasources/Home_datasource_repo_impl.dart'
    as _i97;
import '../../features/Home/data/repositories_impl/Home_repo_impl.dart' as _i60;
import '../../features/Home/domain/repositories/Home_repository.dart' as _i126;
import '../../features/Home/domain/useCases/Home_useCase_repo.dart' as _i543;
import '../../features/Home/domain/useCases/Home_useCase_repo_impl.dart'
    as _i557;
import '../../features/Home/presentation/bloc/Home_cubit.dart' as _i371;
import '../../features/NewChildren/data/datasources/NewChildren_datasource_repo.dart'
    as _i172;
import '../../features/NewChildren/data/datasources/NewChildren_datasource_repo_impl.dart'
    as _i122;
import '../../features/NewChildren/data/repositories_impl/NewChildren_repo_impl.dart'
    as _i666;
import '../../features/NewChildren/domain/repositories/NewChildren_repository.dart'
    as _i781;
import '../../features/NewChildren/domain/useCases/NewChildren_useCase_repo.dart'
    as _i416;
import '../../features/NewChildren/domain/useCases/NewChildren_useCase_repo_impl.dart'
    as _i863;
import '../../features/NewChildren/presentation/bloc/NewChildren_cubit.dart'
    as _i36;
import '../../features/Settings/data/datasources/Settings_datasource_repo.dart'
    as _i826;
import '../../features/Settings/data/datasources/Settings_datasource_repo_impl.dart'
    as _i625;
import '../../features/Settings/data/repositories_impl/Settings_repo_impl.dart'
    as _i583;
import '../../features/Settings/domain/repositories/Settings_repository.dart'
    as _i271;
import '../../features/Settings/domain/useCases/Settings_useCase_repo.dart'
    as _i650;
import '../../features/Settings/domain/useCases/Settings_useCase_repo_impl.dart'
    as _i502;
import '../../features/Settings/presentation/bloc/Settings_cubit.dart' as _i241;
import '../../features/Stories/data/datasources/Stories_datasource_repo.dart'
    as _i1073;
import '../../features/Stories/data/datasources/Stories_datasource_repo_impl.dart'
    as _i256;
import '../../features/Stories/data/repositories_impl/Stories_repo_impl.dart'
    as _i166;
import '../../features/Stories/domain/repositories/Stories_repository.dart'
    as _i55;
import '../../features/Stories/domain/useCases/Stories_useCase_repo.dart'
    as _i891;
import '../../features/Stories/domain/useCases/Stories_useCase_repo_impl.dart'
    as _i809;
import '../../features/Stories/presentation/bloc/Stories_cubit.dart' as _i879;
import '../api/api_manager/api_manager.dart' as _i680;
import '../api/dio_module.dart' as _i784;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final dioModule = _$DioModule();
    gh.lazySingleton<_i361.Dio>(() => dioModule.providerDio());
    gh.factory<_i271.SettingsRepository>(() => _i583.SettingsRepositoryImpl());
    gh.factory<_i126.HomeRepository>(() => _i60.HomeRepositoryImpl());
    gh.factory<_i55.StoriesRepository>(() => _i166.StoriesRepositoryImpl());
    gh.factory<_i680.ApiService>(() => _i680.ApiService(gh<_i361.Dio>()));
    gh.factory<_i196.ChatBotAssistantDatasourceRepo>(
      () => _i710.ChatBotAssistantDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i543.HomeUseCaseRepo>(
      () => _i557.HomeUseCase(gh<_i126.HomeRepository>()),
    );
    gh.factory<_i20.ChatBotAssistantRepository>(
      () => _i16.ChatBotAssistantRepositoryImpl(
        gh<_i196.ChatBotAssistantDatasourceRepo>(),
      ),
    );
    gh.factory<_i891.StoriesUseCaseRepo>(
      () => _i809.StoriesUseCase(gh<_i55.StoriesRepository>()),
    );
    gh.factory<_i223.ChatBotAssistantUseCaseRepo>(
      () =>
          _i659.ChatBotAssistantUseCase(gh<_i20.ChatBotAssistantRepository>()),
    );
    gh.factory<_i650.SettingsUseCaseRepo>(
      () => _i502.SettingsUseCase(gh<_i271.SettingsRepository>()),
    );
    gh.factory<_i354.AuthDatasourceRepo>(
      () => _i485.AuthDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i647.AuthRepository>(
      () => _i295.AuthRepositoryImpl(gh<_i354.AuthDatasourceRepo>()),
    );
    gh.factory<_i826.SettingsDatasourceRepo>(
      () => _i625.SettingsDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i1073.StoriesDatasourceRepo>(
      () => _i256.StoriesDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i172.NewChildrenDatasourceRepo>(
      () => _i122.NewChildrenDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i879.StoriesCubit>(
      () => _i879.StoriesCubit(gh<_i891.StoriesUseCaseRepo>()),
    );
    gh.factory<_i628.AuthUseCaseRepo>(
      () => _i971.AuthUseCase(gh<_i647.AuthRepository>()),
    );
    gh.factory<_i582.ChatBotAssistantCubit>(
      () =>
          _i582.ChatBotAssistantCubit(gh<_i223.ChatBotAssistantUseCaseRepo>()),
    );
    gh.factory<_i827.HomeDatasourceRepo>(
      () => _i97.HomeDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i424.ChildrenDatasourceRepo>(
      () => _i464.ChildrenDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i781.NewChildrenRepository>(
      () => _i666.NewChildrenRepositoryImpl(
        gh<_i172.NewChildrenDatasourceRepo>(),
      ),
    );
    gh.factory<_i371.HomeCubit>(
      () => _i371.HomeCubit(gh<_i543.HomeUseCaseRepo>()),
    );
    gh.factory<_i416.NewChildrenUseCaseRepo>(
      () => _i863.NewChildrenUseCase(gh<_i781.NewChildrenRepository>()),
    );
    gh.factory<_i159.DirectionsCubit>(
      () => _i159.DirectionsCubit(gh<_i223.ChatBotAssistantUseCaseRepo>()),
    );
    gh.factory<_i151.ChildrenRepository>(
      () => _i750.ChildrenRepositoryImpl(gh<_i424.ChildrenDatasourceRepo>()),
    );
    gh.factory<_i241.SettingsCubit>(
      () => _i241.SettingsCubit(gh<_i650.SettingsUseCaseRepo>()),
    );
    gh.factory<_i192.AuthCubit>(
      () => _i192.AuthCubit(gh<_i628.AuthUseCaseRepo>()),
    );
    gh.factory<_i36.NewChildrenCubit>(
      () => _i36.NewChildrenCubit(gh<_i416.NewChildrenUseCaseRepo>()),
    );
    gh.factory<_i341.ChildrenUseCaseRepo>(
      () => _i129.ChildrenUseCase(gh<_i151.ChildrenRepository>()),
    );
    gh.factory<_i537.ChildrenCubit>(
      () => _i537.ChildrenCubit(gh<_i341.ChildrenUseCaseRepo>()),
    );
    return this;
  }
}

class _$DioModule extends _i784.DioModule {}
