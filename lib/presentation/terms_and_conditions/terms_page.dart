import 'package:flutter/material.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/widgets/app_app_bar.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(titleKey: "الشروط والاحكام",),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [

          _TermsItem(
            title: "أحقية الحصول على الخدمات",
            content: """
أنت تقر وتضمن التالي:
• أنه لم يسبق أن تم تعطيل استخدامك لخدمات نبض الاسرة.
• أي سوء استخدام سيؤدي إلى إيقاف الحساب مباشرة.
""",
          ),

          _TermsItem(
            title: "التعهدات والضمانات",
            content: """
• لن تستخدم الخدمة إلا للاستخدام الشخصي.
• لن تسبب أي ضرر أو إزعاج.
• ستحافظ على سرية كلمة المرور.
""",
          ),

          _TermsItem(
            title: "حقوق الملكية الفكرية",
            content: """
• جميع الحقوق مملوكة لتطبيق نبض الأسرة.
• يمنع استخدام الحساب لأي طرف آخر.
""",
          ),

          _TermsItem(
            title: "الأسعار",
            content: """
• الأسعار تظهر قبل الطلب.
• يحق للمستشار تعديل السعر.
""",
          ),

          _TermsItem(
            title: "الدفع",
            content: """
• الدفع يتم عند الحجز.
• الوسائل: مدى - فيزا - Apple Pay - STC Pay.
""",
          ),

          _TermsItem(
            title: "سياسة الاسترجاع",
            content: """
• استرجاع قبل 24 ساعة مع خصم 15%.
• عدم الحضور = لا استرجاع.
• بعد الاستشارة لا يوجد استرجاع.
""",
          ),

          _TermsItem(
            title: "المسؤولية القانونية",
            content: """
• الخدمة مقدمة كما هي.
• التطبيق غير مسؤول عن سوء الاستخدام.
""",
          ),

          _TermsItem(
            title: "سياسة حذف الحساب",
            content: """
• يمكن حذف الحساب من الإعدادات أو البريد.
• يتم حذف البيانات خلال 7 أيام.
""",
          ),
        ],
      ),
    );
  }
}

class _TermsItem extends StatelessWidget {
  final String title;
  final String content;

  const _TermsItem({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 8,vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        childrenPadding: const EdgeInsets.all(16),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        children: [
          Text(
            content,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              height: 1.6,
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}