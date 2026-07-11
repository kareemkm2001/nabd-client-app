import 'package:flutter/material.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/theme/app_text_styles.dart';

class SubUserCard extends StatelessWidget {
  final int id;
  final String fullName;
  final String fullNameEn;
  final String mobile;
  final String telephone;
  final String email;
  final String gender;
  final String socialSituation;
  final int age;
  final String nationality;
  final String status;
  final String smsStatus;
  final String proofNum;
  final String createdAt;

  const SubUserCard({
    super.key,
    required this.id,
    required this.fullName,
    required this.fullNameEn,
    required this.mobile,
    required this.telephone,
    required this.email,
    required this.gender,
    required this.socialSituation,
    required this.age,
    required this.nationality,
    required this.status,
    required this.smsStatus,
    required this.proofNum,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      style: AppTextStyles.mediumBoldBlack,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      fullNameEn,
                      style: AppTextStyles.smallGrey,
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: status == "مفعل"
                      ? Colors.green.shade100
                      : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: status == "مفعل"
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),

          const SizedBox(height: 16),

          Wrap(
            spacing: 20,
            runSpacing: 12,
            children: [
              _InfoItem(title: "رقم الهوية", value: proofNum),
              _InfoItem(title: "الجوال", value: mobile),
              _InfoItem(title: "الهاتف", value: telephone),
              _InfoItem(title: "البريد", value: email),
              _InfoItem(title: "الجنس", value: gender),
              _InfoItem(title: "العمر", value: age.toString()),
              _InfoItem(title: "الجنسية", value: nationality),
              _InfoItem(title: "الحالة الاجتماعية", value: socialSituation),
            ],
          ),

          const SizedBox(height: 16),

          const Divider(),

          Row(
            children: [
              Expanded(
                child: Text(
                  "تاريخ التسجيل: $createdAt",
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: smsStatus == "مفعل"
                      ? Colors.green.shade100
                      : Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  smsStatus,
                  style: TextStyle(
                    color: smsStatus == "مفعل"
                        ? Colors.green
                        : Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String title;
  final String value;

  const _InfoItem({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * .38,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}