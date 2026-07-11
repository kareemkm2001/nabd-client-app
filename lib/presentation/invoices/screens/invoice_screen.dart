import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/widgets/app_app_bar.dart';
import 'package:nabd_client_app/presentation/invoices/cubits/invoices_state.dart';
import 'package:nabd_client_app/presentation/invoices/widgets/invoice_item.dart';
import '../cubits/invoices_cubit.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {

  @override
  void initState(){
    super.initState();
    context.read<InvoicesCubit>().getInvoices();
  }

  @override
  Widget build(BuildContext context) {
    final invoicesCubit = context.read<InvoicesCubit>();

    return Scaffold(
      appBar: AppAppBar(titleKey: "الفواتير",),
      backgroundColor: AppColors.background,
      body: BlocBuilder<InvoicesCubit,InvoicesState>(
          builder: (context, state){
            if(state is GetInvoicesLoading){
              return Center(child: CircularProgressIndicator(),);
            }if(state is GetInvoicesError){
              return Center(child: Text(state.errorMsg),);
            }if(state is GetInvoicesSuc){
              return ListView.builder(
                itemCount: state.invoices.length,
                itemBuilder: (context,index){
                  return InvoiceCard(
                    invoiceId: state.invoices[index].invoiceId,
                    serviceName: state.invoices[index].serviceName,
                    clinicName: state.invoices[index].clinicName,
                    doctorName: state.invoices[index].doctorName,
                    invoiceType: state.invoices[index].invoiceType,
                    invoiceState: state.invoices[index].invoiceState,
                    paymentStatus: state.invoices[index].paymentStatus,
                    totalAmount: state.invoices[index].totalAmount,
                    createdAt: state.invoices[index].createdAt,
                    insurance: state.invoices[index].insurance,
                    paymentMode: state.invoices[index].paymentMode,
                    pdfLink: state.invoices[index].pdfLink,
                  );
                }
              );
            }
            return SizedBox();
          }
      ),
    );
  }
}
