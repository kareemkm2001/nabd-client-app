import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd_client_app/presentation/invoices/cubits/invoices_state.dart';
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
      body: BlocBuilder<InvoicesCubit,InvoicesState>(
          builder: (context, state){
            if(state is GetInvoicesLoading){
              return Center(child: LinearProgressIndicator(),);
            }if(state is GetInvoicesError){
              return Center(child: Text(state.errorMsg),);
            }if(state is GetInvoicesSuc){
              return ListView.builder(
                itemCount: state.invoices.length,
                  itemBuilder: (context,index){
                  return Text(state.invoices[index].title);
                  }
              );
            }
            return SizedBox();
          }
      ),
    );
  }
}
