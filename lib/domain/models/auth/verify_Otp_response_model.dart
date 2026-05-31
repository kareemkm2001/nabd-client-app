import 'user_model.dart';

class AuthDataModel  {
  final UserModel? user;
  final String? accessToken;
  final String? refreshToken;
  final String? tokenType;
  final int? expiresIn;

  AuthDataModel ({
    this.user,
    this.accessToken,
    this.refreshToken,
    this.tokenType,
    this.expiresIn,
  });

  factory AuthDataModel .fromJson(Map<String, dynamic> json) {
    return AuthDataModel (
      user: json['profile'] != null
          ? UserModel.fromJson(json['profile'])
          : null,
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      tokenType: json['token_type'],
      expiresIn: json['expires_in'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profile': user?.toJson(),
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'token_type': tokenType,
      'expires_in': expiresIn,
    };
  }
}

class VerifyOtpResponseModel {
  final bool? success;
  final String? message;
  final AuthDataModel? data;

  const VerifyOtpResponseModel({
    this.success,
    this.message,
    this.data,
  });

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponseModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? AuthDataModel.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}