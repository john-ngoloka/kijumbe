// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:kijumbe/core/network/dio_client.dart' as _i6;
import 'package:kijumbe/core/network/network_info.dart' as _i9;
import 'package:kijumbe/features/authentication/data/datasources/local/auth_local_datasource.dart'
    as _i3;
import 'package:kijumbe/features/authentication/data/datasources/remote/auth_remote_datasource.dart'
    as _i5;
import 'package:kijumbe/features/authentication/data/repositories/auth_repository_impl.dart'
    as _i8;
import 'package:kijumbe/features/authentication/domain/repositories/auth_repository.dart'
    as _i7;
import 'package:kijumbe/features/authentication/domain/usecases/get_current_user_usecase.dart'
    as _i10;
import 'package:kijumbe/features/authentication/domain/usecases/is_logged_in_usecase.dart'
    as _i11;
import 'package:kijumbe/features/authentication/domain/usecases/login_usecase.dart'
    as _i12;
import 'package:kijumbe/features/authentication/domain/usecases/logout_usecase.dart'
    as _i13;
import 'package:kijumbe/features/authentication/presentation/cubit/auth_cubit.dart'
    as _i14;
import 'package:shared_preferences/shared_preferences.dart' as _i4;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i3.AuthLocalDataSource>(
        () => _i3.AuthLocalDataSourceImpl(gh<_i4.SharedPreferences>()));
    gh.lazySingleton<_i5.AuthRemoteDataSource>(
        () => _i5.AuthRemoteDataSourceImpl(gh<_i6.DioClient>()));
    gh.lazySingleton<_i7.AuthRepository>(() => _i8.AuthRepositoryImpl(
          gh<_i5.AuthRemoteDataSource>(),
          gh<_i3.AuthLocalDataSource>(),
          gh<_i9.NetworkInfo>(),
        ));
    gh.factory<_i10.GetCurrentUserUseCase>(
        () => _i10.GetCurrentUserUseCase(gh<_i7.AuthRepository>()));
    gh.factory<_i11.IsLoggedInUseCase>(
        () => _i11.IsLoggedInUseCase(gh<_i7.AuthRepository>()));
    gh.factory<_i12.LoginUseCase>(
        () => _i12.LoginUseCase(gh<_i7.AuthRepository>()));
    gh.factory<_i13.LogoutUseCase>(
        () => _i13.LogoutUseCase(gh<_i7.AuthRepository>()));
    gh.factory<_i14.AuthCubit>(() => _i14.AuthCubit(
          gh<_i12.LoginUseCase>(),
          gh<_i13.LogoutUseCase>(),
          gh<_i10.GetCurrentUserUseCase>(),
          gh<_i11.IsLoggedInUseCase>(),
        ));
    return this;
  }
}
