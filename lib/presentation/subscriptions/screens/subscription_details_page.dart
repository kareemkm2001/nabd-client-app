import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd_client_app/core/extensions/date_format.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/widgets/app_app_bar.dart';
import 'package:nabd_client_app/core/widgets/app_button.dart';
import 'package:nabd_client_app/core/widgets/app_route_animation.dart';
import 'package:nabd_client_app/core/widgets/top_snackbar.dart';
import 'package:nabd_client_app/domain/models/subscriptions/subscriptions_response.dart';
import 'package:nabd_client_app/presentation/appointments/cubit/appointments_cubit.dart';
import 'package:nabd_client_app/presentation/appointments/screens/date_time_step_screen.dart';

class SubscriptionDetailScreen extends StatelessWidget {
  final SubscriptionModel subscription;

  const SubscriptionDetailScreen({
    super.key,
    required this.subscription,
  });

  double get progress =>
      subscription.numberOfSessions == 0
          ? 0
          : subscription.completedSessions /
          subscription.numberOfSessions;

  @override
  Widget build(BuildContext context) {

    final appointmentsCubit = context.read<AppointmentsCubit>() ;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppAppBar(titleKey:"تفاصيل الاشتراك",),

      body: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 20),

            /// ================= CIRCLE PROGRESS =================
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [

                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 10,
                          backgroundColor: Colors.white24,
                          color: Colors.white,
                          strokeCap: StrokeCap.round,
                        ),
                      ),

                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${subscription.completedSessions}/${subscription.numberOfSessions}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            "جلسات",
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Text(
                    subscription.packageName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    subscription.serviceName,
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: _headerStat(
                          Icons.check_circle_outline,
                          "${subscription.completedSessions}",
                          "المكتملة",
                        ),
                      ),

                      Expanded(
                        child: _headerStat(
                          Icons.pending_actions,
                          "${subscription.remainingSessions}",
                          "المتبقية",
                        ),
                      ),

                      Expanded(
                        child: _headerStat(
                          Icons.payments_outlined,
                          "${subscription.price}",
                          "ريال",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// ================= MAIN CARD =================
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  _item("الباقة", subscription.packageName),
                  _item("الخدمة", subscription.serviceName),
                  _item("العيادة", subscription.clinicName),
                  _item("الدكتور", subscription.doctorName),

                  const Divider(height: 30),

                  _item("الحالة", subscription.status),
                  _item("حالة الفاتورة", subscription.invoiceStatus),

                  const Divider(height: 30),

                  _item("السعر", "${subscription.price} ريال"),
                  _item("المتبقي", "${subscription.remainingSessions} جلسات"),

                  const Divider(height: 30),

                  _item(
                    "تاريخ البداية",
                    subscription.startDate.toPrettyArabicDateTime(),
                  ),
                  _item(
                    "تاريخ النهاية",
                    subscription.endDate.toPrettyArabicDateTime(),
                  ),
                  _item(
                    "تاريخ الإنشاء",
                    subscription.createdAt.toPrettyArabicDateTime(),
                  ),

                  if (subscription.notes != null &&
                      subscription.notes!.isNotEmpty) ...[
                    const Divider(height: 30),
                    _item("ملاحظات", subscription.notes!),
                  ],
                ],
              ),
            ),
            
            AppButton(
                onTap: (){
                  if(subscription.remainingSessions == 0){
                    showAppSnackBarError(
                        context: context,
                        message: "تم الانتهاء من جميع الجلسات"
                    );
                  }else if(subscription.status == "غير مفعل"){
                    showAppSnackBarError(
                        context: context,
                        message: "الاشتراك غير مفعل"
                    );
                  }else {
                    appointmentsCubit.actionType = "subscription" ;
                    appointmentsCubit.selectedPackageId = subscription.id ;
                    appointmentsCubit.selectedClinicId = subscription.clinicId ;
                    appointmentsCubit.selectedServiceId = subscription.serviceId ;

                    Navigator.push(
                        context,
                        AppRouteAnimation(page: DateTimeStepScreen())
                    ).then((_){
                      appointmentsCubit.selectedSlot = null;
                      appointmentsCubit.selectedPeriodId = null ;
                    });
                  }
                },
                titleKey: "احجز جلستك القادمة",
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

  Widget _headerStat(
      IconData icon,
      String value,
      String title,
      ) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}