import 'package:nabd_client_app/domain/models/invoice/invoice_response.dart';

class InvoicesState {}

class InvoiceInitial  extends InvoicesState {}

class GetInvoicesSuc extends InvoicesState {
  final List<InvoiceModel> invoices ;

  GetInvoicesSuc({required this.invoices});
}

class GetInvoicesLoading extends InvoicesState {}

class GetInvoicesError extends InvoicesState {
  final String errorMsg ;

  GetInvoicesError({required this.errorMsg});
}