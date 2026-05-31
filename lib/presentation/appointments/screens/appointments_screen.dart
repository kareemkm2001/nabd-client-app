import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/widgets/app_app_bar.dart';
import 'package:nabd_client_app/presentation/appointments/cubit/appointments_cubit.dart';
import 'package:nabd_client_app/presentation/appointments/cubit/appointments_state.dart';
import 'package:nabd_client_app/presentation/appointments/widgets/appointment_card.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(titleKey: "المواعيد", isHome: true,),
      body: BlocBuilder<AppointmentsCubit,AppointmentsState>(
          builder: (context,state){
            if(state is GetAppointmentLoading){
              return Center(child: CircularProgressIndicator(),);
            }if(state is GetAppointmentError){
              return Center(child: Text(state.errorMsg),);
            }if(state is GetAppointmentSuc){
              return ListView.builder(
                  itemCount: state.appointments.length,
                  itemBuilder: (context , index){
                    return AppointmentCard(appointment: state.appointments[index]);
                  }
              );
            }
            return SizedBox();
          }
      ),
    );
  }
}
