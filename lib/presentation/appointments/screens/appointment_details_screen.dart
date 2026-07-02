import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd_client_app/core/extensions/string_extension.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/widgets/app_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/extensions/clean_html.dart';
import '../../../core/helper/file_downloader.dart';
import '../../../domain/models/appointment/appointment_data_model.dart';
import '../cubit/appointments_cubit.dart';
import '../cubit/appointments_state.dart';

class AppointmentDetailsScreen extends StatefulWidget {

  final int appointmentId ;

   const AppointmentDetailsScreen({
    super.key,
    required this.appointmentId
  });

  @override
  State<AppointmentDetailsScreen> createState() => _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {

  @override
  void initState() {
    context.read<AppointmentsCubit>().getAppointmentById(id: widget.appointmentId);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    final appointmentsCubit = context.read<AppointmentsCubit>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(titleKey: "تفاصيل الموعد",),
      body: BlocBuilder<AppointmentsCubit,AppointmentsState>(
          builder: (context,state){
            if(state is GetAppointmentByIdLoading){
              return Center(child: CircularProgressIndicator(),);
            }if(state is GetAppointmentByIdError){
              return Center(child: Text(state.errorMsg),);
            }else{
              final appointment = appointmentsCubit.appointmentDataModel!;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withOpacity(.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.calendar_month,
                              color: AppColors.primary,
                              size: 35,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Text(
                            appointment.status,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            appointment.date,
                            style: const TextStyle(
                              color: Colors.white70,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _headerInfo(
                                Icons.access_time,
                                "${appointment.fromTime} - ${appointment.toTime}",
                              ),
                              _headerInfo(
                                Icons.person,
                                appointment.clinic.doctor.fullName,
                              ),
                            ],
                          ),

                          if (appointment.type == "عن بعد") ...[
                            const SizedBox(height: 20),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  final uri = Uri.parse(appointment.joinUrl ?? "");

                                  print("الزوم ${uri}");


                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(
                                      uri,
                                      mode: LaunchMode.externalApplication,
                                    );
                                  }
                                },
                                icon: const Icon(Icons.video_call),
                                label: const Text("الانضمام إلى الاجتماع"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    /// ================= BASIC INFO =================
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: Column(
                        children: [

                          _item("التاريخ", appointment.date),
                          _item("من", appointment.fromTime),
                          _item("إلى", appointment.toTime),
                          _item("الحالة", appointment.status),
                          _item("النوع", appointment.type),
                          _item("التأكيد", appointment.confirmed),
                          _item("السعر", "${appointment.price} ريال"),

                          if (appointment.notes != null)
                            _item("ملاحظات", appointment.notes!.ellipsis(250)),

                          const Divider(),

                          _item("الخدمة", appointment.service.name),
                          _item("العيادة", appointment.clinic.name),
                          _item("الدكتور", appointment.clinic.doctor.fullName),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// ================= USERS =================
                    _section(
                      title: "العملاء",
                      count: appointment.users.length,
                      children: [
                        ...buildUsersList(appointment.users),
                      ],
                    ),

                    /// ================= ATTACHMENTS =================
                    _section(
                      title: "الملفات والمرفقات",
                      count: appointment.attachments.length,
                      children: appointment.attachments.isEmpty
                          ? [
                            SizedBox(height: 5,),
                            Text("لا توجد مرفقات"),
                            SizedBox(height: 5,),
                      ]
                          : [
                        ...buildAttachments(appointment.attachments),
                      ],
                    ),
                    _section(
                      title: "الخطط العلاجية",
                      count: appointment.treatmentPlans.length,
                      children: appointment.treatmentPlans.isEmpty
                          ? [
                        SizedBox(height: 5,),
                        Text("لا توجد خطط علاجية"),
                        SizedBox(height: 5,),
                      ] : [
                        ...buildTreatmentPlans(
                          appointment.treatmentPlans,
                        ),
                      ],

                    ),

                    _section(
                      title: "التقارير",
                      count: appointment.reports.length,
                      children: appointment.reports.isEmpty
                          ? [
                        SizedBox(height: 5,),
                        Text("لا توجد تقارير"),
                        SizedBox(height: 5,),
                      ]
                          : appointment.reports.map((rep) {
                            return Text("التقارير");

                      }).toList(),
                    ),
                  ],
                ),
              );
            }
          }
      ),
    );
  }

  Widget _headerInfo(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(height: 4),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
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
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _section({
    required String title,
    required int count,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
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
          "$title ($count)",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        children: children,
      ),
    );
  }

  List<Widget> buildUsersList(List<UserModel> users) {
    return users.map((u) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.blue.withOpacity(0.1),
              child: Text(
                u.fullName.isNotEmpty
                    ? u.fullName[0].toUpperCase()
                    : "?",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    u.fullName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    u.mobile,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  List<Widget> buildAttachments(List<AttachmentModel> files) {
    return files.map((file) {
      return InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          FileDownloader.downloadPdf(
            file.attachment,
            file.fileName,
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey.shade200,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.picture_as_pdf,
                  color: Colors.red,
                  size: 24,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      file.fileName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      file.type,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.withOpacity(.1),
                ),
                child: const Icon(
                  Icons.download_rounded,
                  color: Colors.blue,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  List<Widget> buildTreatmentPlans(List<TreatmentPlan> plans) {
    return plans.map((plan) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.medical_services_outlined,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    cleanHtml(plan.name),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            if (plan.currentComplaint?.isNotEmpty == true)
              _item(
                "الشكوى",
                cleanHtml(plan.currentComplaint),
              ),

            if (plan.organicDiseases?.isNotEmpty == true)
              _item(
                "الأمراض",
                cleanHtml(plan.organicDiseases),
              ),

            if (plan.recommendations?.isNotEmpty == true)
              _item(
                "التوصيات",
                cleanHtml(plan.recommendations),
              ),

            if (plan.notes?.isNotEmpty == true)
              _item(
                "ملاحظات",
                cleanHtml(plan.notes),
              ),
          ],
        ),
      );
    }).toList();
  }
}
