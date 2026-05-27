import 'package:dartz/dartz.dart';
import 'package:nabd_client_app/core/network/api_service.dart';
import 'package:nabd_client_app/data/api/invoice/invoice_api.dart';

import '../../core/error/failures.dart';
import '../models/invoice/invoice_response.dart';

class InvoiceUseCase {

  final InvoiceApi invoiceApi ;

  InvoiceUseCase({required this.invoiceApi});


  Future<Either<Failure , List<InvoiceModel>>> getInvoices() async {
    return await invoiceApi.getInvoices() ;
  }
}