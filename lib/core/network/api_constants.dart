class ApiConstants {
  static const String baseUrl = "https://test.nabdwit.com/";


  // Auth
  static const String requestOTP = "api/v1/auth/request-otp";
  static const String loginOTPVerify = "api/v1/auth/login-otp-verify";
  static const String register = "api/v1/auth/register";
  static const String resendVerifyCode = "api/v1/auth/resend-verify-code/";
  static const String refreshToken = "api/v1/auth/refresh";


  // Profile
  static const String profile = "api/v1/profile" ;
  static const String updateProfile = "api/v1/profile/update" ;
  static const String subUsers = "api/v1/users" ;
  static const String notifications = "api/v1/notifications" ;
  static const String orders = "api/v1/orders" ;


  // Invoices
  static const String invoices = "api/v1/invoices";

  //Subscriptions
  static const String subscriptions = "api/v1/subscriptions";

  // Appointments
  static const String appointments = "api/v1/appointments" ;
  static const String clinics = "api/v1/appointments/dropdowns" ;
  static const String services = "api/v1/filters/clinic_information?id=" ;
  static const String clinicTime  = "api/v1/filters/clinic_availableTime" ;
  static const String slots  = "api/v1/filters/service_availableTime" ;
  static const String packagesClinic  = "api/v1/filters/clinic_packages" ;
  static const String taxInfo  = "api/v1/filters/patient-tax-info" ;
  static const String createNormalAppointment  = "api/v1/appointments/create/normal" ;

}