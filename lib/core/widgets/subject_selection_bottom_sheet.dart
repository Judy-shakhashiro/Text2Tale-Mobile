import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text2tale_mobile/features/auth/presentation/providers/subject_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/primary_button.dart';

class SubjectSelectionBottomSheet extends StatefulWidget {
  const SubjectSelectionBottomSheet({Key? key}) : super(key: key);

  @override
  State<SubjectSelectionBottomSheet> createState() => _SubjectSelectionBottomSheetState();
}

class _SubjectSelectionBottomSheetState extends State<SubjectSelectionBottomSheet> {
  final Set<int> _tempSelectedIds = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubjectProvider>().fetchAllSubjects();
    });
  }

  void _saveSelection() async {
    if (_tempSelectedIds.isEmpty) return;

    final provider = context.read<SubjectProvider>();
    final error = await provider.saveSelectedSubjects(_tempSelectedIds.toList());

    if (!mounted) return;

    if (error == null) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تمت إضافة المواد بنجاح! 📚'), backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SubjectProvider>();

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.inputBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const Text(
            "اختر موادك الدراسية",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.secondary),
          ),
          const SizedBox(height: 4),
          const Text(
            "يمكنك اختيار أكثر من مادة",
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          if (provider.isSelectionLoading)
            const Center(child: Padding(padding: EdgeInsets.all(32.0), child: CircularProgressIndicator()))
          else if (provider.availableSubjects.isEmpty)
            const Center(child: Padding(padding: EdgeInsets.all(24.0), child: Text("لا توجد مواد متاحة حالياً.")))
          else
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: provider.availableSubjects.map((subject) {
                final isSelected = _tempSelectedIds.contains(subject.id);
                return ChoiceChip(
                  label: Text(subject.name),
                  selected: isSelected,
                  selectedColor: AppColors.primary.withOpacity(0.15),
                  backgroundColor: AppColors.background,
                  side: BorderSide(color: isSelected ? AppColors.primary : AppColors.inputBorder),
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.primary : AppColors.secondary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _tempSelectedIds.add(subject.id);
                      } else {
                        _tempSelectedIds.remove(subject.id);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          const SizedBox(height: 28),
          PrimaryButton(
            text: "إضافة المواد المختارة",
            onPressed: _tempSelectedIds.isEmpty || provider.isSelectionLoading ? () {} : _saveSelection,
          ),
        ],
      ),
    );
  }
}