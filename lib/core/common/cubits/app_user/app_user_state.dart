part of 'app_user_cubit.dart';

@immutable
sealed class AppUserState {}

final class AppUserInitial extends AppUserState {}

final class AppUserLogedIn extends AppUserState {
  final User user;

  AppUserLogedIn(this.user);
}
