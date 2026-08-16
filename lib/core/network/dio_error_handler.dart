import 'package:dio/dio.dart';

String extractErrorMessage(DioException e) {
  if (e.response == null) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'انتهت مهلة الاتصال، تحقق من اتصالك بالإنترنت';
      case DioExceptionType.connectionError:
        return 'تعذر الاتصال بالخادم، تحقق من اتصالك بالإنترنت';
      default:
        return 'حدث خطأ غير متوقع، حاول مرة أخرى';
    }
  }

  final statusCode = e.response?.statusCode;
  final data = e.response?.data;

  if (data is Map) {
    if (data['error'] != null) return data['error'].toString();
    if (data['detail'] != null) return data['detail'].toString();

    final errorsContainer = data['errors'] is Map ? data['errors'] as Map : data;
    for (final value in errorsContainer.values) {
      if (value is List && value.isNotEmpty) return value.first.toString();
      if (value is String && value.trim().isNotEmpty) return value;
    }

    if (data['message'] != null) return data['message'].toString();
  }

  if (data is List && data.isNotEmpty) return data.first.toString();

  if (statusCode != null && statusCode >= 500) {
    return 'حدث خطأ في الخادم، حاول مرة أخرى لاحقاً';
  }
  return 'حدث خطأ غير متوقع، حاول مرة أخرى';
}