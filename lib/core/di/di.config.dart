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

import '../../features/AddChildren/data/datasources/AddChildren_datasource_repo.dart'
    as _i658;
import '../../features/AddChildren/data/datasources/AddChildren_datasource_repo_impl.dart'
    as _i459;
import '../../features/AddChildren/data/repositories_impl/AddChildren_repo_impl.dart'
    as _i283;
import '../../features/AddChildren/domain/repositories/AddChildren_repository.dart'
    as _i199;
import '../../features/AddChildren/domain/useCases/AddChildren_useCase_repo.dart'
    as _i828;
import '../../features/AddChildren/domain/useCases/AddChildren_useCase_repo_impl.dart'
    as _i151;
import '../../features/AddChildren/presentation/bloc/AddChildren_cubit.dart'
    as _i95;
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
    gh.factory<_i680.ApiService>(() => _i680.ApiService(gh<_i361.Dio>()));
    gh.factory<_i196.ChatBotAssistantDatasourceRepo>(
      () => _i710.ChatBotAssistantDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i20.ChatBotAssistantRepository>(
      () => _i16.ChatBotAssistantRepositoryImpl(
        gh<_i196.ChatBotAssistantDatasourceRepo>(),
      ),
    );
    gh.factory<_i223.ChatBotAssistantUseCaseRepo>(
      () =>
          _i659.ChatBotAssistantUseCase(gh<_i20.ChatBotAssistantRepository>()),
    );
    gh.factory<_i354.AuthDatasourceRepo>(
      () => _i485.AuthDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i647.AuthRepository>(
      () => _i295.AuthRepositoryImpl(gh<_i354.AuthDatasourceRepo>()),
    );
    gh.factory<_i658.AddChildrenDatasourceRepo>(
      () => _i459.AddChildrenDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i628.AuthUseCaseRepo>(
      () => _i971.AuthUseCase(gh<_i647.AuthRepository>()),
    );
    gh.factory<_i582.ChatBotAssistantCubit>(
      () =>
          _i582.ChatBotAssistantCubit(gh<_i223.ChatBotAssistantUseCaseRepo>()),
    );
    gh.factory<_i424.ChildrenDatasourceRepo>(
      () => _i464.ChildrenDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i199.AddChildrenRepository>(
      () => _i283.AddChildrenRepositoryImpl(
        gh<_i658.AddChildrenDatasourceRepo>(),
      ),
    );
    gh.factory<_i159.DirectionsCubit>(
      () => _i159.DirectionsCubit(gh<_i223.ChatBotAssistantUseCaseRepo>()),
    );
    gh.factory<_i151.ChildrenRepository>(
      () => _i750.ChildrenRepositoryImpl(gh<_i424.ChildrenDatasourceRepo>()),
    );
    gh.factory<_i192.AuthCubit>(
      () => _i192.AuthCubit(gh<_i628.AuthUseCaseRepo>()),
    );
    gh.factory<_i828.AddChildrenUseCaseRepo>(
      () => _i151.AddChildrenUseCase(gh<_i199.AddChildrenRepository>()),
    );
    gh.factory<_i341.ChildrenUseCaseRepo>(
      () => _i129.ChildrenUseCase(gh<_i151.ChildrenRepository>()),
    );
    gh.factory<_i95.AddChildrenCubit>(
      () => _i95.AddChildrenCubit(gh<_i828.AddChildrenUseCaseRepo>()),
    );
    gh.factory<_i537.ChildrenCubit>(
      () => _i537.ChildrenCubit(gh<_i341.ChildrenUseCaseRepo>()),
    );
    return this;
  }
}

class _$DioModule extends _i784.DioModule {}
