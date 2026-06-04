import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/widgets/app_app_bar.dart';

import '../../../core/helper/file_downloader.dart';
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

                    /// ================= BASIC INFO =================
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
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
                            _item("ملاحظات", appointment.notes!),

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
                      children: appointment.users.map((u) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text(u.fullName),
                          subtitle: Text(u.mobile),
                        );
                      }).toList(),
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
                          :appointment.attachments.map((file) {
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.attach_file),
                            title: Text(file.fileName),
                            subtitle: Text(file.type),
                            trailing: Text(file.status),
                            onTap: (){
                              FileDownloader.downloadPdf(
                                file.attachment,
                                file.fileName,
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ),

                    /// ================= TREATMENT PLANS =================
                    _section(
                      title: "الخطط العلاجية",
                      count: appointment.treatmentPlans.length,
                      children: appointment.treatmentPlans.isEmpty
                          ? [
                        SizedBox(height: 5,),
                        Text("لا توجد خطط علاجية"),
                        SizedBox(height: 5,),
                      ]
                          :appointment.treatmentPlans.map((plan) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text(
                                  plan.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                if (plan.currentComplaint != null)
                                  _item("الشكوى", plan.currentComplaint!),

                                if (plan.organicDiseases != null)
                                  _item("الأمراض", plan.organicDiseases!),

                                if (plan.recommendations != null)
                                  _item("التوصيات", plan.recommendations!),

                                if (plan.notes != null)
                                  _item("ملاحظات", plan.notes!),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
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
}
