import 'package:dio/dio.dart';
import '../models/subject_model.dart';

class SubjectRepository {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://text2tale-backend.alllahhham.com/api',
    headers: {'Content-Type': 'application/json'},
  ));


  Future<List<SubjectModel>> getAllSubjects(String token) async {
    try {
      final response = await _dio.get(
        '/subjects/all/',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      
      final List<dynamic> data = response.data['subjects'];
      return data.map((json) => SubjectModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('فشل في جلب المواد المتاحة');
    }
  }


  Future<List<SubjectModel>> manageChosenSubjects(String token, {List<int>? selectedIds}) async {
    try {
    
      final Map<String, dynamic> data = selectedIds != null && selectedIds.isNotEmpty 
          ? {"subjects": selectedIds} 
          : {};

      final response = await _dio.post(
        '/subjects/choose/',
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final List<dynamic> responseData = response.data['selected_subjects'];
      return responseData.map((json) => SubjectModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('فشل في تحديث المواد المختارة');
    }
  }
}