import 'package:dio/dio.dart';
import 'package:text2tale_mobile/core/network/dio_error_handler.dart';
import '../models/subject_model.dart';

class SubjectRepository {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://text2tale-backend.alllahhham.com/api',
    headers: {'Content-Type': 'application/json'},
  ));

  // جلب كل المواد المتاحة في النظام (لعرضها في نافذة الاختيار)
  Future<List<SubjectModel>> getAllSubjects(String token) async {
    try {
      final response = await _dio.get(
        '/subjects/all/',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final List<dynamic> data = response.data['subjects'];
      return data.map((json) => SubjectModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(extractErrorMessage(e));
    }
  }

  // جلب المواد التي سجّلها الطالب مسبقاً (لعرضها في شاشة "موادي")
  Future<List<SubjectModel>> getChosenSubjects(String token) async {
    try {
      final response = await _dio.get(
        '/subjects/chosen/',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final List<dynamic> data = response.data['enrolled_subjects'];
      return data.map((json) => SubjectModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(extractErrorMessage(e));
    }
  }

  // تسجيل مواد جديدة للطالب
  Future<List<SubjectModel>> chooseSubjects(String token, List<int> selectedIds) async {
    try {
      final response = await _dio.post(
        '/subjects/choose/',
        data: {"subjects": selectedIds},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final List<dynamic> responseData = response.data['selected_subjects'];
      return responseData.map((json) => SubjectModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(extractErrorMessage(e));
    }
  }
}