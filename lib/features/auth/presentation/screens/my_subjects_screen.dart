import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text2tale_mobile/core/theme/app_colors.dart';
import 'package:text2tale_mobile/core/widgets/auth_header.dart';
import 'package:text2tale_mobile/core/widgets/subject_selection_bottom_sheet.dart';
import '../providers/subject_provider.dart';

class MySubjectsScreen extends StatefulWidget {
  const MySubjectsScreen({Key? key}) : super(key: key);

  @override
  State<MySubjectsScreen> createState() => _MySubjectsScreenState();
}

class _MySubjectsScreenState extends State<MySubjectsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubjectProvider>().fetchMySubjects();
    });
  }

  void _openSelectionSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SubjectSelectionBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SubjectProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const AuthHeader(
            icon: Icons.menu_book_rounded,
            title: "موادي الدراسية",
            subtitle: "اختر المواد التي تدرسها لتبدأ بتحويل دروسها إلى قصص.",
            showBackButton: true,
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : provider.mySubjects.isEmpty
                      ? _buildEmptyState()
                      : _buildSubjectsGrid(provider),
            ),
          ),
        ],
      ),
      floatingActionButton: provider.mySubjects.isNotEmpty
          ? FloatingActionButton(
              onPressed: _openSelectionSheet,
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book_rounded, size: 100, color: AppColors.inputBorder),
            const SizedBox(height: 24),
            const Text(
              "لم تقم بإضافة أي مواد بعد!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.secondary),
            ),
            const SizedBox(height: 12),
            const Text(
              "اختر موادك الدراسية الآن لنبدأ بتحويلها إلى قصص مشوقة.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: _openSelectionSheet,
                icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                label: const Text("أضف موادك الدراسية", style: TextStyle(fontSize: 16, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectsGrid(SubjectProvider provider) {
    return RefreshIndicator(
      onRefresh: provider.fetchMySubjects,
      child: GridView.builder(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
        ),
        itemCount: provider.mySubjects.length,
        itemBuilder: (context, index) {
          final subject = provider.mySubjects[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.inputBorder.withOpacity(0.5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: const Icon(Icons.book, color: AppColors.primary, size: 28),
                ),
                const SizedBox(height: 12),
                Text(
                  subject.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.secondary),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}