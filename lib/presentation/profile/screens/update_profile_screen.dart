import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/widgets/app_app_bar.dart';
import 'package:nabd_client_app/core/widgets/app_button.dart';
import 'package:nabd_client_app/core/widgets/top_snackbar.dart';
import 'package:nabd_client_app/presentation/profile/cubit/profile_cubit.dart';

import '../widgets/app_country_code_field.dart';
import '../widgets/app_dropdown_field.dart';
import '../widgets/app_text_field.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreen();
}

class _UpdateProfileScreen extends State<UpdateProfileScreen> {


  @override
  void initState() {
    context.read<ProfileCubit>().fillController() ;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final profileCubit = context.read<ProfileCubit>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(titleKey: "تاكيد بياناتك",),
      body: SafeArea(
        child: Form(
          key: profileCubit.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                ///================ Personal =================

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: Column(
                    children: [

                      AppTextField(
                        controller: profileCubit.firstNameController,
                        title: "الاسم الاول",
                        icon: Icons.person_outline,
                      ),

                      const SizedBox(height: 10),

                      AppTextField(
                        controller: profileCubit.secondNameController,
                        title: "اسم الاب",
                        icon: Icons.person_outline,
                      ),

                      const SizedBox(height: 10),

                      AppTextField(
                        controller: profileCubit.thirdNameController,
                        title: "اسم الجد",
                        icon: Icons.person_outline,
                      ),

                      const SizedBox(height: 10),

                      AppTextField(
                        controller: profileCubit.lastNameController,
                        title: "اسم العائلة",
                        icon: Icons.person_outline,
                      ),

                      const SizedBox(height: 10),

                      AppTextField(
                        controller: profileCubit.fullNameEnController,
                        title: "الاسم كامل بالانجليزي",
                        icon: Icons.person_outline,
                      ),

                      const SizedBox(height: 10),

                      AppTextField(
                        controller: profileCubit.usernameController,
                        title: "اسم المستخدم",
                        icon: Icons.alternate_email,
                      ),

                      const SizedBox(height: 10),

                      AppTextField(
                        controller: profileCubit.emailController,
                        title: "البريد الالكتروني",
                        keyboardType: TextInputType.emailAddress,
                        icon: Icons.email_outlined,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                ///================ Contact =================

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                      )
                    ],
                  ),
                  child: Column(
                    children: [

                      Row(
                        children: [
                          AppCountryCodeField(
                            controller: profileCubit.countryCodeController,
                            onChanged: (code){
                              profileCubit.countryCode = int.parse(code) ;
                              print("كود الدوله $code");
                            },
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: AppTextField(
                              title: "رقم الهاتف",
                              controller: profileCubit.mobileController,
                              icon: Icons.mobile_friendly_sharp,
                              keyboardType: TextInputType.phone,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      AppTextField(
                        controller: profileCubit.telephoneController,
                        title: "التليفون",
                        keyboardType: TextInputType.number,
                        icon: Icons.phone,
                        minLength: 9,
                        maxLength: 9,
                        validator: (value) {
                          if (value == null || value.length != 9) {
                            return "رقم التليفون غير صحيح";
                          }
                          return null;
                        },
                      ),

                      AppTextField(
                        controller: profileCubit.proofController,
                        title: "رقم الاثبات",
                        keyboardType: TextInputType.number,
                        icon: Icons.badge_outlined,
                        minLength: 10,
                        maxLength: 10,
                        validator: (value) {
                          if (value == null || value.length != 10) {
                            return "رقم الاثبات غير صحيح";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),

                      AppTextField(
                        controller: profileCubit.addressController,
                        title: "العنوان",
                        icon: Icons.location_on_outlined,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                ///================ Other =================

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                      )
                    ],
                  ),
                  child: Column(
                    children: [

                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2000),
                            firstDate: DateTime(1950),
                            lastDate: DateTime.now(),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: AppColors.primary,
                                    onPrimary: Colors.white,
                                    surface: AppColors.background,
                                    onSurface: Colors.black87,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );

                          if (date != null) {
                            profileCubit.birthdayController.text =
                            "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                          }
                        },
                        child: IgnorePointer(
                          child: AppTextField(
                            controller: profileCubit.birthdayController,
                            title: "تاريخ الميلاد",
                            icon: Icons.calendar_month,
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      AppDropdownField<int>(
                        title: "الجنس",
                        icon: Icons.person_outline,
                        value: profileCubit.gender,
                        onChanged: (value) {
                          setState(() {
                            profileCubit.gender = value!;
                          });
                        },
                        items: const [
                          DropdownMenuEntry(
                            value: 1,
                            label: "ذكر",
                          ),
                          DropdownMenuEntry(
                            value: 2,
                            label: "أنثي",
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      AppDropdownField<int>(
                        title: "الحالة الاجتماعية",
                        icon: Icons.favorite_outline,
                        value: profileCubit.socialSituation,
                        onChanged: (value) {
                          setState(() {
                            profileCubit.socialSituation = value!;
                          });
                        },
                        items: const [
                          DropdownMenuEntry(
                            value: 1,
                            label:"عازب/عازبة",
                          ),
                          DropdownMenuEntry(
                            value: 2,
                            label: "متزوج/متزوجة",
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      AppDropdownField<int>(
                        title: "الجنسية",
                        icon: Icons.flag_outlined,
                        value: profileCubit.nationality,
                        onChanged: (value) {
                          setState(() {
                            profileCubit.nationality = value!;
                          });
                        },
                        items: const [
                          DropdownMenuEntry(value: 1, label: "السعودية"),
                          DropdownMenuEntry(value: 2, label: "الإمارات"),
                          DropdownMenuEntry(value: 3, label: "البحرين"),
                          DropdownMenuEntry(value: 4, label: "سلطنة عمان"),
                          DropdownMenuEntry(value: 5, label: "الكويت"),
                          DropdownMenuEntry(value: 6, label: "قطر"),
                          DropdownMenuEntry(value: 7, label: "الأردن"),
                          DropdownMenuEntry(value: 8, label: "مصر"),
                          DropdownMenuEntry(value: 9, label: "اليمن"),
                          DropdownMenuEntry(value: 10, label: "فلسطين"),
                          DropdownMenuEntry(value: 11, label: "العراق"),
                          DropdownMenuEntry(value: 12, label: "سوريا"),
                          DropdownMenuEntry(value: 13, label: "لبنان"),
                          DropdownMenuEntry(value: 14, label: "ليبيا"),
                          DropdownMenuEntry(value: 15, label: "الجزائر"),
                          DropdownMenuEntry(value: 16, label: "تونس"),
                          DropdownMenuEntry(value: 17, label: "المغرب"),
                          DropdownMenuEntry(value: 18, label: "السودان"),
                          DropdownMenuEntry(value: 19, label: "باكستان"),
                          DropdownMenuEntry(value: 20, label: "الفلبين"),
                        ],
                      ),

                      const SizedBox(height: 15),

                      AppTextField(
                        controller: profileCubit.notesController,
                        title: "ملاحظات",
                        icon: Icons.notes,
                        maxLines: 4,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),

                AppButton(
                  titleKey: "حفظ بياناتي",
                    onTap: (){
                      if (profileCubit.formKey.currentState!.validate()) {
                        FocusScope.of(context).unfocus();

                        profileCubit.updateProfile(context);
                      }else {
                        showAppSnackBarError(context: context, message: "البيانات غير صحيحة");
                      }
                    }
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}