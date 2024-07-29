import 'dart:io';

import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/features/blog/data/model/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSources {
  Future<BlogModel> upLoadBlog(BlogModel blog);
  Future<String> upLoadBlogImage(
      {required File image, required BlogModel blog});
  Future<List<BlogModel>> getAllBlogs();
}

class BlogRemoteDataSourcesImpl extends BlogRemoteDataSources {
  final SupabaseClient supabaseClient;

  BlogRemoteDataSourcesImpl(this.supabaseClient);
  // @override
  // Future<BlogModel> upLoadBlog(BlogModel blog) async {
  //   try {
  //     final blogData =
  //         await supabaseClient.from("blogs").insert({blog.toJson()}).select();

  //     return BlogModel.fromJson(blogData.first);
  //   } catch (e) {
  //     throw ServerException(e.toString());
  //   }
  // }

  @override
  Future<BlogModel> upLoadBlog(BlogModel blog) async {
    try {
      final blogData =
          await supabaseClient.from('blogs').insert(blog.toJson()).select();

      return BlogModel.fromJson(blogData.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> upLoadBlogImage({
    required File image,
    required BlogModel blog,
  }) async {
    try {
      await supabaseClient.storage.from('blog_images').upload(
            blog.id,
            image,
          );

      return supabaseClient.storage.from('blog_images').getPublicUrl(blog.id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> getAllBlogs() async {
    try {
      final blogs =
          await supabaseClient.from('blogs').select('*,profiles (name)');

      return blogs
          .map((blog) => BlogModel.fromJson(blog).copyWith(
                posterName: blog['profiles']['name'],
              ))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
