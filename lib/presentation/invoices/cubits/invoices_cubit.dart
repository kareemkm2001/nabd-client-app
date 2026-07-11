import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd_client_app/domain/models/invoice/invoice_response.dart';
import 'package:nabd_client_app/domain/usecases/invoice_use_case.dart';
import 'package:nabd_client_app/presentation/invoices/cubits/invoices_state.dart';

class InvoicesCubit  extends Cubit<InvoicesState>{

  final  InvoiceUseCase invoiceUseCase ;

  InvoicesCubit({required this.invoiceUseCase}) : super(InvoiceInitial());


  List<InvoiceModel> invoices = [] ;

  void getInvoices() async {
    emit(GetInvoicesLoading());

    final result = await invoiceUseCase.getInvoices();
    result.fold(
        (l){
          emit(GetInvoicesError(errorMsg: l.message));
        },
        (r){
          print("الداتا ${r[0]}");
          emit(GetInvoicesSuc(invoices: r));
        }
    );
  }
}