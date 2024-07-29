import 'dart:io';

import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/blog/data/datasources/blog_remote_data_sources.dart';
import 'package:blog_app/features/blog/data/model/blog_model.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepoImpl implements BlogRepository {
  BlogRemoteDataSources blogRemoteDataSources;
  final ConnectionChecker connectionChecker;
  BlogRepoImpl(this.blogRemoteDataSources, this.connectionChecker);
  @override
  Future<Either<Failure, Blog>> upLoadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure('No Internet Connection'));
      }
      BlogModel blogModel = BlogModel(
          id: const Uuid().v1(),
          posterId: posterId,
          title: title,
          content: content,
          imageUrl: '',
          topics: topics,
          updatedAt: DateTime.now());

      final imageUrl = await blogRemoteDataSources.upLoadBlogImage(
        image: image,
        blog: blogModel,
      );

      blogModel = blogModel.copyWith(
        imageUrl: imageUrl,
      );
      final uplodedblog = await blogRemoteDataSources.upLoadBlog(blogModel);
      return right(uplodedblog);
    } on ServerException catch (e) {
      return left(Failure(e.messsage));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure('No Internet Connection'));
      }
      final blogs = await blogRemoteDataSources.getAllBlogs();
      return right(blogs);
    } on ServerException catch (e) {
      return left(Failure(e.messsage));
    }
  }
}
