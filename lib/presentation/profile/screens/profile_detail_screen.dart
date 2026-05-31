import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/widgets/app_app_bar.dart';
import 'package:nabd_client_app/core/widgets/app_button.dart';
import 'package:nabd_client_app/presentation/profile/cubit/profile_state.dart';

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
                  if(state is GetProfilesSuc){
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
                                  state.profile.firstName ?? "",
                                  state.profile.lastName ?? "",
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Hero(
                            tag: "full_name",
                            child: Text(
                              "${state.profile.firstName} ${state.profile.lastName ?? ""}",
                              style: AppTextStyles.mediumBlack.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return SizedBox(height: 50,);
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
                      }if(state is GetProfilesSuc){
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            _item("الاسم الأول", state.profile.firstName ?? "-"),
                            _item("الاسم الثاني", state.profile.secondName ?? "-"),
                            _item("الاسم الثالث", state.profile.thirdName ?? "-"),
                            _item("الاسم الأخير", state.profile.lastName ?? "-"),

                            const Divider(height: 30),

                            _item("اسم المستخدم", state.profile.username ?? "-"),
                            _item("نوع المستخدم", state.profile.userType ?? "-"),
                            _item("الحالة", state.profile.status ?? "-"),
                            _item("النوع", state.profile.gender ?? "-"),

                            const Divider(height: 30),

                            _item("رقم الجوال", state.profile.mobile ?? "-"),
                            _item("الهاتف", state.profile.telephone ?? "-"),
                            _item("كود الدولة", state.profile.contryCode ?? "-"),
                            _item("البريد الإلكتروني", state.profile.email ?? "-"),

                            const Divider(height: 30),

                            _item("العمر", "${state.profile.age ?? "-"}"),
                            _item("تاريخ الميلاد", state.profile.birthday ?? "-"),
                            _item("الحالة الاجتماعية", state.profile.socialSituation ?? "-"),

                            const Divider(height: 30),

                            _item("تاريخ الإنشاء", _format(state.profile.createdAt)),
                            _item("آخر تحديث", _format(state.profile.updatedAt)),
                          ],
                        );
                      }
                      return SizedBox();
                    }
                ),
            ),
            AppButton(
              onTap: (){

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


