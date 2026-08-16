import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/repositories/subject_repository.dart';
import '../../data/models/subject_model.dart';

class SubjectProvider extends ChangeNotifier {
  final SubjectRepository _repository = SubjectRepository();
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSelectionLoading = false;
  bool get isSelectionLoading => _isSelectionLoading;

  List<SubjectModel> _mySubjects = [];
  List<SubjectModel> get mySubjects => _mySubjects;

  List<SubjectModel> _availableSubjects = [];
  List<SubjectModel> get availableSubjects => _availableSubjects;

  // جلب المواد التي اختارها الطالب مسبقاً (عند فتح الصفحة)
  Future<void> fetchMySubjects() async {
    _setLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token') ?? '';
      
      _mySubjects = await _repository.manageChosenSubjects(token);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // جلب كل المواد المتاحة ليختار منها الطالب
  Future<void> fetchAllSubjects() async {
    _isSelectionLoading = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token') ?? '';
      
      _availableSubjects = await _repository.getAllSubjects(token);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isSelectionLoading = false;
      notifyListeners();
    }
  }

  // حفظ المواد المختارة
  Future<String?> saveSelectedSubjects(List<int> selectedIds) async {
    _isSelectionLoading = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token') ?? '';
      
      // نرسل التحديث، والـ API سيعيد القائمة المحدثة
      _mySubjects = await _repository.manageChosenSubjects(token, selectedIds: selectedIds);
      return null; // نجاح
    } catch (e) {
      return 'حدث خطأ أثناء حفظ المواد';
    } finally {
      _isSelectionLoading = false;
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}