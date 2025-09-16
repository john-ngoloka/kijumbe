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
import 'package:kijumbe/core/services/jwt_service.dart' as _i19;
import 'package:kijumbe/features/authentication/data/datasources/local/auth_local_datasource.dart'
    as _i3;
import 'package:kijumbe/features/authentication/data/datasources/remote/auth_remote_datasource.dart'
    as _i5;
import 'package:kijumbe/features/authentication/data/repositories/auth_repository_impl.dart'
    as _i31;
import 'package:kijumbe/features/authentication/domain/repositories/auth_repository.dart'
    as _i30;
import 'package:kijumbe/features/authentication/domain/usecases/create_user_with_phone_password_usecase.dart'
    as _i33;
import 'package:kijumbe/features/authentication/domain/usecases/get_current_user_usecase.dart'
    as _i34;
import 'package:kijumbe/features/authentication/domain/usecases/is_logged_in_usecase.dart'
    as _i40;
import 'package:kijumbe/features/authentication/domain/usecases/login_usecase.dart'
    as _i41;
import 'package:kijumbe/features/authentication/domain/usecases/logout_usecase.dart'
    as _i42;
import 'package:kijumbe/features/authentication/domain/usecases/signup_usecase.dart'
    as _i43;
import 'package:kijumbe/features/authentication/presentation/cubit/auth_cubit.dart'
    as _i44;
import 'package:kijumbe/features/group/data/datasources/local/dao/contribution_dao.dart'
    as _i7;
import 'package:kijumbe/features/group/data/datasources/local/dao/cycle_dao.dart'
    as _i10;
import 'package:kijumbe/features/group/data/datasources/local/dao/group_dao.dart'
    as _i13;
import 'package:kijumbe/features/group/data/datasources/local/dao/group_member_dao.dart'
    as _i14;
import 'package:kijumbe/features/group/data/datasources/local/dao/notification_dao.dart'
    as _i21;
import 'package:kijumbe/features/group/data/datasources/local/dao/payout_dao.dart'
    as _i24;
import 'package:kijumbe/features/group/data/repository/contribution_repository_impl.dart'
    as _i9;
import 'package:kijumbe/features/group/data/repository/cycle_repository_impl.dart'
    as _i12;
import 'package:kijumbe/features/group/data/repository/group_member_repository_impl.dart'
    as _i16;
import 'package:kijumbe/features/group/data/repository/group_repository_impl.dart'
    as _i18;
import 'package:kijumbe/features/group/data/repository/notification_repository_impl.dart'
    as _i23;
import 'package:kijumbe/features/group/data/repository/payout_repository_impl.dart'
    as _i26;
import 'package:kijumbe/features/group/domain/repositories/contribution_repository.dart'
    as _i8;
import 'package:kijumbe/features/group/domain/repositories/cycle_repository.dart'
    as _i11;
import 'package:kijumbe/features/group/domain/repositories/group_member_repository.dart'
    as _i15;
import 'package:kijumbe/features/group/domain/repositories/group_repository.dart'
    as _i17;
import 'package:kijumbe/features/group/domain/repositories/notification_repository.dart'
    as _i22;
import 'package:kijumbe/features/group/domain/repositories/payout_repository.dart'
    as _i25;
import 'package:kijumbe/features/group/domain/useCases/add_member_to_group_usecase.dart'
    as _i29;
import 'package:kijumbe/features/group/domain/useCases/create_group_usecase.dart'
    as _i32;
import 'package:kijumbe/features/group/domain/useCases/get_group_members_usecase.dart'
    as _i35;
import 'package:kijumbe/features/group/domain/useCases/get_groups_by_admin_usecase.dart'
    as _i36;
import 'package:kijumbe/features/group/domain/useCases/get_user_groups_usecase.dart'
    as _i37;
import 'package:kijumbe/features/group/domain/useCases/join_group_by_code_usecase.dart'
    as _i20;
import 'package:kijumbe/features/group/domain/useCases/remove_member_from_group_usecase.dart'
    as _i27;
import 'package:kijumbe/features/group/domain/useCases/search_groups_usecase.dart'
    as _i28;
import 'package:kijumbe/features/group/presentation/cubit/group_cubit.dart'
    as _i38;
import 'package:kijumbe/features/group/presentation/cubit/group_member_cubit.dart'
    as _i39;
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
    gh.factory<_i7.ContributionDAO>(() => _i7.ContributionDAO());
    gh.lazySingleton<_i8.ContributionRepository>(
        () => _i9.ContributionRepositoryImpl(gh<_i7.ContributionDAO>()));
    gh.factory<_i10.CycleDAO>(() => _i10.CycleDAO());
    gh.lazySingleton<_i11.CycleRepository>(
        () => _i12.CycleRepositoryImpl(gh<_i10.CycleDAO>()));
    gh.factory<_i13.GroupDAO>(() => _i13.GroupDAO());
    gh.factory<_i14.GroupMemberDAO>(() => _i14.GroupMemberDAO());
    gh.lazySingleton<_i15.GroupMemberRepository>(
        () => _i16.GroupMemberRepositoryImpl(gh<_i14.GroupMemberDAO>()));
    gh.lazySingleton<_i17.GroupRepository>(
        () => _i18.GroupRepositoryImpl(gh<_i13.GroupDAO>()));
    gh.lazySingleton<_i19.JWTService>(() => _i19.JWTService());
    gh.factory<_i20.JoinGroupByCodeUseCase>(
        () => _i20.JoinGroupByCodeUseCase(gh<_i17.GroupRepository>()));
    gh.factory<_i21.NotificationDAO>(() => _i21.NotificationDAO());
    gh.lazySingleton<_i22.NotificationRepository>(
        () => _i23.NotificationRepositoryImpl(gh<_i21.NotificationDAO>()));
    gh.factory<_i24.PayoutDAO>(() => _i24.PayoutDAO());
    gh.lazySingleton<_i25.PayoutRepository>(
        () => _i26.PayoutRepositoryImpl(gh<_i24.PayoutDAO>()));
    gh.factory<_i27.RemoveMemberFromGroupUseCase>(() =>
        _i27.RemoveMemberFromGroupUseCase(gh<_i15.GroupMemberRepository>()));
    gh.factory<_i28.SearchGroupsUseCase>(
        () => _i28.SearchGroupsUseCase(gh<_i17.GroupRepository>()));
    gh.factory<_i29.AddMemberToGroupUseCase>(
        () => _i29.AddMemberToGroupUseCase(gh<_i15.GroupMemberRepository>()));
    gh.lazySingleton<_i30.AuthRepository>(() => _i31.AuthRepositoryImpl(
          gh<_i3.AuthLocalDataSource>(),
          gh<_i19.JWTService>(),
        ));
    gh.factory<_i32.CreateGroupUseCase>(
        () => _i32.CreateGroupUseCase(gh<_i17.GroupRepository>()));
    gh.factory<_i33.CreateUserWithPhonePasswordUseCase>(() =>
        _i33.CreateUserWithPhonePasswordUseCase(gh<_i30.AuthRepository>()));
    gh.factory<_i34.GetCurrentUserUseCase>(
        () => _i34.GetCurrentUserUseCase(gh<_i30.AuthRepository>()));
    gh.factory<_i35.GetGroupMembersUseCase>(
        () => _i35.GetGroupMembersUseCase(gh<_i15.GroupMemberRepository>()));
    gh.factory<_i36.GetGroupsByAdminUseCase>(
        () => _i36.GetGroupsByAdminUseCase(gh<_i17.GroupRepository>()));
    gh.factory<_i37.GetUserGroupsUseCase>(
        () => _i37.GetUserGroupsUseCase(gh<_i17.GroupRepository>()));
    gh.factory<_i38.GroupCubit>(() => _i38.GroupCubit(
          gh<_i32.CreateGroupUseCase>(),
          gh<_i36.GetGroupsByAdminUseCase>(),
          gh<_i37.GetUserGroupsUseCase>(),
          gh<_i28.SearchGroupsUseCase>(),
          gh<_i20.JoinGroupByCodeUseCase>(),
          gh<_i29.AddMemberToGroupUseCase>(),
          gh<_i35.GetGroupMembersUseCase>(),
        ));
    gh.factory<_i39.GroupMemberCubit>(() => _i39.GroupMemberCubit(
          gh<_i29.AddMemberToGroupUseCase>(),
          gh<_i35.GetGroupMembersUseCase>(),
          gh<_i27.RemoveMemberFromGroupUseCase>(),
        ));
    gh.factory<_i40.IsLoggedInUseCase>(
        () => _i40.IsLoggedInUseCase(gh<_i30.AuthRepository>()));
    gh.factory<_i41.LoginUseCase>(
        () => _i41.LoginUseCase(gh<_i30.AuthRepository>()));
    gh.factory<_i42.LogoutUseCase>(
        () => _i42.LogoutUseCase(gh<_i30.AuthRepository>()));
    gh.factory<_i43.SignupUseCase>(
        () => _i43.SignupUseCase(gh<_i30.AuthRepository>()));
    gh.singleton<_i44.AuthCubit>(() => _i44.AuthCubit(
          gh<_i41.LoginUseCase>(),
          gh<_i42.LogoutUseCase>(),
          gh<_i34.GetCurrentUserUseCase>(),
          gh<_i40.IsLoggedInUseCase>(),
          gh<_i43.SignupUseCase>(),
        ));
    return this;
  }
}
