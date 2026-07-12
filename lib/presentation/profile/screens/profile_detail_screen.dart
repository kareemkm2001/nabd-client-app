import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/widgets/app_app_bar.dart';
import 'package:nabd_client_app/core/widgets/app_button.dart';
import 'package:nabd_client_app/core/widgets/app_route_animation.dart';
import 'package:nabd_client_app/presentation/profile/cubit/profile_state.dart';
import 'package:nabd_client_app/presentation/profile/screens/update_profile_screen.dart';

import '../../../core/extensions/date_format.dart';
import '../../../core/helper/avatar_helper.dart';
import '../../../core/theme/app_text_styles.dart';
import '../cubit/profile_cubit.dart';

class ProfileDetailScreen extends StatelessWidget {
  const ProfileDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppAppBar(titleKey: "الملف الشخصي",),
      body: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 20),

            BlocBuilder<ProfileCubit , ProfileState>(
                builder: (context , state){
                  final profile = context.read<ProfileCubit>().profileModel ;

                  return Center(
                    child: Column(
                      children: [
                        Hero(
                          tag: "profile_avatar",
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 35,
                              child: AvatarHelper.getAvatar(
                                profile?.firstName ?? "",
                                profile?.lastName ?? "",
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Hero(
                          tag: "full_name",
                          child: Text(
                            "${profile?.firstName} ${profile?.lastName ?? ""}",
                            style: AppTextStyles.mediumBlack.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
            ),

            const SizedBox(height: 20),

            /// ================= MAIN CARD =================
            Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: BlocBuilder<ProfileCubit,ProfileState>(
                    builder: (context , state){
                      if(state is GetProfileLoading){
                        return Center(child: CircularProgressIndicator(),);
                      }if(state is GetProfileError){
                        return Center(child: Text(state.errorMsg),);
                      }else {
                        final profile = context.read<ProfileCubit>().profileModel ;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            _item("الاسم الأول", profile?.firstName ?? "-"),
                            _item("الاسم الثاني", profile?.secondName ?? "-"),
                            _item("الاسم الثالث", profile?.thirdName ?? "-"),
                            _item("الاسم الأخير", profile?.lastName ?? "-"),

                            const Divider(height: 30),

                            _item("اسم المستخدم", profile?.username ?? "-"),
                            _item("نوع المستخدم", profile?.userType ?? "-"),
                            _item("الحالة", profile?.status ?? "-"),
                            _item("النوع", profile?.gender ?? "-"),

                            const Divider(height: 30),

                            _item("رقم الجوال", profile?.mobile ?? "-"),
                            _item("الهاتف", profile?.telephone ?? "-"),
                            _item("كود الدولة", profile?.contryCode ?? "-"),
                            _item("البريد الإلكتروني", profile?.email ?? "-"),

                            const Divider(height: 30),

                            _item("العمر", "${profile?.age ?? "-"}"),
                            _item("تاريخ الميلاد", profile?.birthday ?? "-"),
                            _item("الحالة الاجتماعية", profile?.socialSituation ?? "-"),

                            const Divider(height: 30),

                            _item("تاريخ الإنشاء", _format(profile?.createdAt)),
                            _item("آخر تحديث", _format(profile?.updatedAt)),
                          ],
                        );
                      }
                    }
                ),
            ),
            AppButton(
              onTap: (){
                Navigator.push(
                    context,
                    AppRouteAnimation(page: UpdateProfileScreen())
                );
              },
              titleKey: "تعديل",
              margin: 16,
            ),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }

  Widget _item(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _format(String? date) {
    if (date == null) return "-";
    return date.toPrettyArabicDateTime();
  }
}


