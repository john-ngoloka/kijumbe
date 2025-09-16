// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:kijumbe/core/network/dio_client.dart' as _i11;
import 'package:kijumbe/core/services/jwt_service.dart' as _i20;
import 'package:kijumbe/features/authentication/data/datasources/local/auth_local_datasource.dart'
    as _i3;
import 'package:kijumbe/features/authentication/data/datasources/remote/auth_remote_datasource.dart'
    as _i34;
import 'package:kijumbe/features/authentication/data/repositories/auth_repository_impl.dart'
    as _i36;
import 'package:kijumbe/features/authentication/domain/repositories/auth_repository.dart'
    as _i35;
import 'package:kijumbe/features/authentication/domain/usecases/create_user_with_phone_password_usecase.dart'
    as _i39;
import 'package:kijumbe/features/authentication/domain/usecases/get_current_user_usecase.dart'
    as _i41;
import 'package:kijumbe/features/authentication/domain/usecases/is_logged_in_usecase.dart'
    as _i47;
import 'package:kijumbe/features/authentication/domain/usecases/login_usecase.dart'
    as _i48;
import 'package:kijumbe/features/authentication/domain/usecases/logout_usecase.dart'
    as _i49;
import 'package:kijumbe/features/authentication/domain/usecases/signup_usecase.dart'
    as _i50;
import 'package:kijumbe/features/authentication/presentation/cubit/auth_cubit.dart'
    as _i51;
import 'package:kijumbe/features/group/data/datasources/local/dao/contribution_dao.dart'
    as _i5;
import 'package:kijumbe/features/group/data/datasources/local/dao/cycle_dao.dart'
    as _i8;
import 'package:kijumbe/features/group/data/datasources/local/dao/group_dao.dart'
    as _i14;
import 'package:kijumbe/features/group/data/datasources/local/dao/group_member_dao.dart'
    as _i15;
import 'package:kijumbe/features/group/data/datasources/local/dao/notification_dao.dart'
    as _i22;
import 'package:kijumbe/features/group/data/datasources/local/dao/payout_dao.dart'
    as _i25;
import 'package:kijumbe/features/group/data/repository/contribution_repository_impl.dart'
    as _i7;
import 'package:kijumbe/features/group/data/repository/cycle_repository_impl.dart'
    as _i10;
import 'package:kijumbe/features/group/data/repository/group_member_repository_impl.dart'
    as _i17;
import 'package:kijumbe/features/group/data/repository/group_repository_impl.dart'
    as _i19;
import 'package:kijumbe/features/group/data/repository/notification_repository_impl.dart'
    as _i24;
import 'package:kijumbe/features/group/data/repository/payout_repository_impl.dart'
    as _i27;
import 'package:kijumbe/features/group/domain/repositories/contribution_repository.dart'
    as _i6;
import 'package:kijumbe/features/group/domain/repositories/cycle_repository.dart'
    as _i9;
import 'package:kijumbe/features/group/domain/repositories/group_member_repository.dart'
    as _i16;
import 'package:kijumbe/features/group/domain/repositories/group_repository.dart'
    as _i18;
import 'package:kijumbe/features/group/domain/repositories/notification_repository.dart'
    as _i23;
import 'package:kijumbe/features/group/domain/repositories/payout_repository.dart'
    as _i26;
import 'package:kijumbe/features/group/domain/useCases/add_member_to_group_usecase.dart'
    as _i33;
import 'package:kijumbe/features/group/domain/useCases/close_cycle_usecase.dart'
    as _i37;
import 'package:kijumbe/features/group/domain/useCases/create_group_usecase.dart'
    as _i38;
import 'package:kijumbe/features/group/domain/useCases/get_active_cycle_usecase.dart'
    as _i12;
import 'package:kijumbe/features/group/domain/useCases/get_contributions_by_group_usecase.dart'
    as _i13;
import 'package:kijumbe/features/group/domain/useCases/get_group_members_usecase.dart'
    as _i42;
import 'package:kijumbe/features/group/domain/useCases/get_groups_by_admin_usecase.dart'
    as _i43;
import 'package:kijumbe/features/group/domain/useCases/get_user_groups_usecase.dart'
    as _i44;
import 'package:kijumbe/features/group/domain/useCases/join_group_by_code_usecase.dart'
    as _i21;
import 'package:kijumbe/features/group/domain/useCases/process_cycle_completion_usecase.dart'
    as _i28;
import 'package:kijumbe/features/group/domain/useCases/record_contribution_usecase.dart'
    as _i29;
import 'package:kijumbe/features/group/domain/useCases/remove_member_from_group_usecase.dart'
    as _i30;
import 'package:kijumbe/features/group/domain/useCases/search_groups_usecase.dart'
    as _i31;
import 'package:kijumbe/features/group/domain/useCases/start_new_cycle_usecase.dart'
    as _i32;
import 'package:kijumbe/features/group/presentation/cubit/cycle_cubit.dart'
    as _i40;
import 'package:kijumbe/features/group/presentation/cubit/group_cubit.dart'
    as _i45;
import 'package:kijumbe/features/group/presentation/cubit/group_member_cubit.dart'
    as _i46;
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
    gh.factory<_i5.ContributionDAO>(() => _i5.ContributionDAO());
    gh.lazySingleton<_i6.ContributionRepository>(
        () => _i7.ContributionRepositoryImpl(gh<_i5.ContributionDAO>()));
    gh.factory<_i8.CycleDAO>(() => _i8.CycleDAO());
    gh.lazySingleton<_i9.CycleRepository>(
        () => _i10.CycleRepositoryImpl(gh<_i8.CycleDAO>()));
    gh.factory<_i11.DioClient>(
        () => _i11.DioClient(gh<_i4.SharedPreferences>()));
    gh.factory<_i12.GetActiveCycleUseCase>(
        () => _i12.GetActiveCycleUseCase(gh<_i9.CycleRepository>()));
    gh.factory<_i13.GetContributionsByGroupUseCase>(() =>
        _i13.GetContributionsByGroupUseCase(gh<_i6.ContributionRepository>()));
    gh.factory<_i14.GroupDAO>(() => _i14.GroupDAO());
    gh.factory<_i15.GroupMemberDAO>(() => _i15.GroupMemberDAO());
    gh.lazySingleton<_i16.GroupMemberRepository>(
        () => _i17.GroupMemberRepositoryImpl(gh<_i15.GroupMemberDAO>()));
    gh.lazySingleton<_i18.GroupRepository>(
        () => _i19.GroupRepositoryImpl(gh<_i14.GroupDAO>()));
    gh.lazySingleton<_i20.JWTService>(() => _i20.JWTService());
    gh.factory<_i21.JoinGroupByCodeUseCase>(
        () => _i21.JoinGroupByCodeUseCase(gh<_i18.GroupRepository>()));
    gh.factory<_i22.NotificationDAO>(() => _i22.NotificationDAO());
    gh.lazySingleton<_i23.NotificationRepository>(
        () => _i24.NotificationRepositoryImpl(gh<_i22.NotificationDAO>()));
    gh.factory<_i25.PayoutDAO>(() => _i25.PayoutDAO());
    gh.lazySingleton<_i26.PayoutRepository>(
        () => _i27.PayoutRepositoryImpl(gh<_i25.PayoutDAO>()));
    gh.factory<_i28.ProcessCycleCompletionUseCase>(
        () => _i28.ProcessCycleCompletionUseCase(
              gh<_i9.CycleRepository>(),
              gh<_i16.GroupMemberRepository>(),
              gh<_i6.ContributionRepository>(),
              gh<_i26.PayoutRepository>(),
            ));
    gh.factory<_i29.RecordContributionUseCase>(
        () => _i29.RecordContributionUseCase(gh<_i6.ContributionRepository>()));
    gh.factory<_i30.RemoveMemberFromGroupUseCase>(() =>
        _i30.RemoveMemberFromGroupUseCase(gh<_i16.GroupMemberRepository>()));
    gh.factory<_i31.SearchGroupsUseCase>(
        () => _i31.SearchGroupsUseCase(gh<_i18.GroupRepository>()));
    gh.factory<_i32.StartNewCycleUseCase>(
        () => _i32.StartNewCycleUseCase(gh<_i9.CycleRepository>()));
    gh.factory<_i33.AddMemberToGroupUseCase>(
        () => _i33.AddMemberToGroupUseCase(gh<_i16.GroupMemberRepository>()));
    gh.lazySingleton<_i34.AuthRemoteDataSource>(
        () => _i34.AuthRemoteDataSourceImpl(gh<_i11.DioClient>()));
    gh.lazySingleton<_i35.AuthRepository>(() => _i36.AuthRepositoryImpl(
          gh<_i3.AuthLocalDataSource>(),
          gh<_i20.JWTService>(),
        ));
    gh.factory<_i37.CloseCycleUseCase>(
        () => _i37.CloseCycleUseCase(gh<_i9.CycleRepository>()));
    gh.factory<_i38.CreateGroupUseCase>(
        () => _i38.CreateGroupUseCase(gh<_i18.GroupRepository>()));
    gh.factory<_i39.CreateUserWithPhonePasswordUseCase>(() =>
        _i39.CreateUserWithPhonePasswordUseCase(gh<_i35.AuthRepository>()));
    gh.factory<_i40.CycleCubit>(() => _i40.CycleCubit(
          gh<_i32.StartNewCycleUseCase>(),
          gh<_i28.ProcessCycleCompletionUseCase>(),
          gh<_i12.GetActiveCycleUseCase>(),
          gh<_i29.RecordContributionUseCase>(),
          gh<_i13.GetContributionsByGroupUseCase>(),
        ));
    gh.factory<_i41.GetCurrentUserUseCase>(
        () => _i41.GetCurrentUserUseCase(gh<_i35.AuthRepository>()));
    gh.factory<_i42.GetGroupMembersUseCase>(
        () => _i42.GetGroupMembersUseCase(gh<_i16.GroupMemberRepository>()));
    gh.factory<_i43.GetGroupsByAdminUseCase>(
        () => _i43.GetGroupsByAdminUseCase(gh<_i18.GroupRepository>()));
    gh.factory<_i44.GetUserGroupsUseCase>(
        () => _i44.GetUserGroupsUseCase(gh<_i18.GroupRepository>()));
    gh.factory<_i45.GroupCubit>(() => _i45.GroupCubit(
          gh<_i38.CreateGroupUseCase>(),
          gh<_i43.GetGroupsByAdminUseCase>(),
          gh<_i44.GetUserGroupsUseCase>(),
          gh<_i31.SearchGroupsUseCase>(),
          gh<_i21.JoinGroupByCodeUseCase>(),
          gh<_i33.AddMemberToGroupUseCase>(),
          gh<_i42.GetGroupMembersUseCase>(),
        ));
    gh.factory<_i46.GroupMemberCubit>(() => _i46.GroupMemberCubit(
          gh<_i33.AddMemberToGroupUseCase>(),
          gh<_i42.GetGroupMembersUseCase>(),
          gh<_i30.RemoveMemberFromGroupUseCase>(),
        ));
    gh.factory<_i47.IsLoggedInUseCase>(
        () => _i47.IsLoggedInUseCase(gh<_i35.AuthRepository>()));
    gh.factory<_i48.LoginUseCase>(
        () => _i48.LoginUseCase(gh<_i35.AuthRepository>()));
    gh.factory<_i49.LogoutUseCase>(
        () => _i49.LogoutUseCase(gh<_i35.AuthRepository>()));
    gh.factory<_i50.SignupUseCase>(
        () => _i50.SignupUseCase(gh<_i35.AuthRepository>()));
    gh.singleton<_i51.AuthCubit>(() => _i51.AuthCubit(
          gh<_i48.LoginUseCase>(),
          gh<_i49.LogoutUseCase>(),
          gh<_i41.GetCurrentUserUseCase>(),
          gh<_i47.IsLoggedInUseCase>(),
          gh<_i50.SignupUseCase>(),
        ));
    return this;
  }
}
