import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd_client_app/core/widgets/app_route_animation.dart';
import 'package:nabd_client_app/domain/models/appointment/appointment_data_model.dart';
import 'package:nabd_client_app/domain/models/appointment/appointment_model.dart';
import 'package:nabd_client_app/domain/usecases/appointment_use_case.dart';
import 'package:nabd_client_app/presentation/appointments/cubit/appointments_state.dart';
import 'package:nabd_client_app/presentation/appointments/screens/payment_view_screen.dart';

import '../../../domain/models/appointment/AppointmentClinicServisesModel.dart';
import '../../../domain/models/appointment/clinics_res_model.dart';
class AppointmentsCubit  extends Cubit<AppointmentsState>{
  final AppointmentUseCase appointmentUseCase ;

  AppointmentsCubit({required this.appointmentUseCase}):super(AppointmentInitial());


  List<AppointmentModel> appointments = [] ;
  List<ClinicResModel> clinics = [] ;
  AppointmentDataModel? appointmentDataModel ;
  ClinicServicesDataModel? clinicServicesData;


  int activeStep = 0;
  int? selectedClinicId ;
  int? selectedServiceId;

  Map<int, int> serviceVisitType = {};

  //////////////////////////////////////////////////////////////////////////////////////////////////////

  void selectClinic(int clinicId) {
    selectedClinicId = clinicId;
    print("العيداه المختاره $selectedClinicId");
    emit(ClinicSelected());
  }


  String getButtonTitle() {
    switch (activeStep) {
      case 0:
        return "اختار خدمتك";

      case 1:
        return "اختار معادك";

      case 2:
        return "تأكيد والدفع";

      default:
        return "الذهاب للدفع";
    }
  }

  void onNextPressed(BuildContext context) {
    switch (activeStep) {
      case 0:
        if (selectedClinicId == null) return;

        activeStep++;
        getClinicServicesById();
        emit(AppointmentStepChanged());
        break;

      case 1:
        activeStep++;
        emit(AppointmentStepChanged());
        break;

      case 2:
        activeStep++;
        emit(AppointmentStepChanged());
        break;

      case 3:
        Navigator.push(
            context,
            AppRouteAnimation(page: PaymentViewScreen(paymentUrl: "https://checkout.tap.company/?mode=page&themeMode=&language=en&token=eyJhbGciOiJIUzI1NiJ9.eyJpZCI6IjZhMjM0YTkyMzE2OGM1M2QyYzUwYTM4YiJ9.CYZlHfxJvAUrjzZ81IuTwIqpVLhRQJOyvA82y4EvSUw"))
        );
    }
  }

  void onBackPressed(){
    activeStep-- ;
    emit(AppointmentStepChanged());
  }


  void selectService(int id) {
    selectedServiceId = id;
    print("الخدمه $selectedServiceId");
    emit(ServiceSelectedState());
  }

  void selectVisitType(int serviceId, int type) {
    serviceVisitType[serviceId] = type;
    emit(ServiceVisitTypeChanged());
  }

  List<Map<String, dynamic>> slots = [];


  DateTime? selectedDate;


  void selectDate(DateTime date) {
    selectedDate = date;

    // هنا هتربط API بعدين
    getSlots(date);
  }

  void getSlots(DateTime date) {
    slots = [
      {
        "from_time": "09:00",
        "to_time": "09:10",
        "appointment": false
      },
      {
        "from_time": "10:00",
        "to_time": "10:10",
        "appointment": true
      },
      {
        "from_time": "11:00",
        "to_time": "11:10",
        "appointment": false
      },
    ];

    emit(SlotsLoadedState());
  }





  int? selectedPaymentMethod;

// 1 = فيزا
// 2 = تمارا
// 3 = مدفوع

  void selectPaymentMethod(int method) {
    selectedPaymentMethod = method;
    emit(PaymentMethodChangedState());
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////
  void getAppointments() async {
    emit(GetAppointmentLoading());

    final result = await appointmentUseCase.getAppointments();
    result.fold(
            (l){
          emit(GetAppointmentError(errorMsg: l.message));
        },
            (r){
              appointments = r ;
          emit(GetAppointmentSuc(appointments: r));
        }
    );
  }

  void getAppointmentById({required int id}) async {
    emit(GetAppointmentByIdLoading());

    final result = await appointmentUseCase.getAppointmentById(id: id);
    result.fold(
            (l){
          emit(GetAppointmentByIdError(errorMsg: l.message));
        },
            (r){
              appointmentDataModel = r ;
              print("تفاصيل المعاد $appointmentDataModel");
          emit(GetAppointmentByIdSuc(appointment: r));
        }
    );
  }

  void getClinics() async {
    emit(GetClinicsLoading());

    final result = await appointmentUseCase.getClinics();
    result.fold(
            (l){
          emit(GetAppointmentError(errorMsg: l.message));
        },
            (r){
              clinics = r ;
              print("العيادات : ${r[0]}");
              emit(GetClinicsSuc());
        }
    );
  }

  void getClinicServicesById() async {
    emit(GetClinicServicesByIdLoading());

    final result = await appointmentUseCase.getClinicServicesById(clinicId: selectedClinicId ?? 0);
    result.fold(
            (l){
          emit(GetClinicServicesByIdError(errorMsg: l.message));
        },
            (r){
          clinicServicesData = r ;
          print("تفاصيل المعاد $clinicServicesData");
          emit(GetClinicServicesByIdSuc());
        }
    );
  }



}