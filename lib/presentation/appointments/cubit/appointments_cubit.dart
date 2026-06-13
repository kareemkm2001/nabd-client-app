import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nabd_client_app/domain/models/appointment/appointment_data_model.dart';
import 'package:nabd_client_app/domain/models/appointment/appointment_model.dart';
import 'package:nabd_client_app/domain/models/appointment/clinic_times_response.dart';
import 'package:nabd_client_app/domain/models/appointment/slot_model.dart';
import 'package:nabd_client_app/domain/usecases/appointment_use_case.dart';
import 'package:nabd_client_app/presentation/appointments/cubit/appointments_state.dart';
import '../../../domain/models/appointment/AppointmentClinicServisesModel.dart';
import '../../../domain/models/appointment/clinics_res_model.dart';
import '../../../domain/models/appointment/package_for_clinic_model.dart';
class AppointmentsCubit  extends Cubit<AppointmentsState>{
  final AppointmentUseCase appointmentUseCase ;

  AppointmentsCubit({required this.appointmentUseCase}):super(AppointmentInitial());


  List<AppointmentModel> appointments = [] ;
  List<ClinicResModel> clinics = [] ;
  AppointmentDataModel? appointmentDataModel ;

  List<ClinicTimesResponse>? clinicTimes ;
  List<SlotModel>? slots ;
  List<PackageForClinicModel>? packagesClinic ;





  String? actionType ;
  ClinicServicesDataModel? clinicServicesData;
  int activeStep = 0;
  int? selectedClinicId ;
  int? selectedServiceId;
  int? selectedPeriodId;
  int? selectedPackageId ;
  int? taxInfo ;
  double? selectedPrice ;
  int? selectedSlotId ;

  Map<int, int> serviceVisitType = {};

  //////////////////////////////////////////////////////////////////////////////////////////////////////

  void selectClinic(int clinicId) {
    selectedClinicId = clinicId;
    print("العيداه المختاره $selectedClinicId");
    emit(ClinicSelected());
  }

  void selectPeriod(int id) {
    selectedPeriodId = id;
    emit(PeriodSelectedState());

    getSlots(id);
  }

  void selectSlot(int id) {
    selectedSlotId = id;
    emit(SlotSelectedState());
  }


  void selectService({required int id , required double price}) {
    selectedServiceId = id;
    selectedPrice = price ;
    print("الخدمه $selectedServiceId");

    emit(ServiceSelectedState());
  }

  void selectVisitType(int serviceId, int type) {
    serviceVisitType[serviceId] = type;
    emit(ServiceVisitTypeChanged());
  }



  DateTime selectedDate = DateTime.now();
  String selectedDateString = '';

  void selectDate(DateTime date) {
    selectedDate = date;

    selectedDateString = DateFormat('MM/dd/yyyy').format(date);

    emit(AppointmentsDateSelected());
  }



  int? selectedPaymentMethod;

// 1 = تاب
// 2 = تمارا
// 3 = مدفوع

  void selectPaymentMethod(int method) {
    selectedPaymentMethod = method;
    print("رقم الميثود $selectedPaymentMethod");
    emit(PaymentMethodChangedState());
  }

  void resetAppointmentDataSelection() {
    selectedClinicId = null;
    selectedServiceId = null;
    selectedPeriodId = null ;
    selectedPaymentMethod = null ;
    selectedPackageId = null ;
  }

  void selectPackage({required int id , required double price}) {
    selectedPackageId = id;
    selectedPrice = price ;
    emit(PackageSelectedState());

  }

  double getTaxAmount() {
    return ((taxInfo ?? 0) / 100) * (selectedPrice ?? 0);
  }

  double getTotalPrice() {
    return (selectedPrice ?? 0) + getTaxAmount();
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

  void getClinicTimes() async {
    emit(GetClinicTimesLoading());
    final result = await appointmentUseCase.getClinicTimes(clinicId: selectedClinicId!, date: selectedDateString, reservationType: 0);

    result.fold(
        (l){
          emit(GetClinicTimesError(errorMsg: l.message));
        },
        (r){
          clinicTimes = r ;
          emit(GetClinicTimesSuc());
        }
    );
  }

  void getSlots(int id) async {
    emit(GetSlotsLoading());

    final result = await appointmentUseCase.getSlots(clinicTimesId: id, date: selectedDateString, clinicId: selectedClinicId?? 1, serviceId: selectedServiceId ?? 1);

    result.fold(
        (l){
          emit(GetSlotsError(errorMsg: l.message));
        },
        (r){
          slots = r ;
          emit(GetSlotsSuc());
        }
      );
  }

  void getClinicPackages() async {
    emit(GetClinicPackagesLoading());

    final result = await appointmentUseCase.getClinicPackagesById(selectedClinicId!);

    result.fold(
        (l){
          emit(GetClinicPackagesError(errorMsg: l.message));
        },
        (r){
          packagesClinic = r ;
          emit(GetClinicPackagesSuc());
        }
    );
  }

  void getTaxInfo() async {

    final result = await appointmentUseCase.getTaxInfo();

    result.fold(
        (l){

        },
        (r){
          taxInfo = int.tryParse(r);
          emit(GetTaxIngoLoaded());
        }
    );
  }



}