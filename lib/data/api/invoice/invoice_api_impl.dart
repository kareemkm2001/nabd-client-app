import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nabd_client_app/core/error/failures.dart';
import 'package:nabd_client_app/core/network/api_constants.dart';
import 'package:nabd_client_app/data/api/invoice/invoice_api.dart';
import 'package:nabd_client_app/domain/models/invoice/invoice_response.dart';

import '../../../core/error/error_handler.dart';
import '../../../core/error/server_failure.dart';
import '../../../core/network/api_service.dart';

class InvoiceApiImpl  implements InvoiceApi {

  ApiService api ;

  InvoiceApiImpl({required this.api});

  @override
  Future<Either<Failure, List<InvoiceModel>>> getInvoices() async {

    try {

      final response = await api.get(ApiConstants.invoices);

      final List<dynamic> dataList = response.data['data']['data'];

      final List<InvoiceModel> invoices = dataList
          .map<InvoiceModel>((e) => InvoiceModel.fromJson(e))
          .toList();

      print("النتيجة ${invoices.length}");

      return Right(invoices);

    }on DioException catch (e){
      print("مممممممممممممممم ${e.error}");
      return Left(ErrorHandler.handle(e));
    }catch (e){
      print("،ننننننننننننن    ${e}");
      return Left(ServerFailure(e.toString()));
    }
  }

}