import 'package:dartz/dartz.dart';
import 'package:nabd_client_app/core/error/failures.dart';
import 'package:nabd_client_app/domain/models/invoice/invoice_response.dart';

abstract class InvoiceApi {

  Future<Either<Failure , List<InvoiceModel>>> getInvoices() ;
}