import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/features/auth/domain/repository/auth_respository.dart';
import 'package:fpdart/fpdart.dart';

class CurrentUser implements UseCase<User, NoParams> {
  AuthRespository authRespository;
  CurrentUser(this.authRespository);
  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await authRespository.curretUser();
  }
}
