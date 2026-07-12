import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd_client_app/presentation/profile/widgets/order_card.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_text.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {

  @override
  void initState() {
    context.read<ProfileCubit>().getOrders() ;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(titleKey: "طلبات المواعيد",),
      backgroundColor: AppColors.background,
      body: BlocBuilder<ProfileCubit,ProfileState>(
          builder: (context, state){
            if(state is GetOrdersLoading){
              return Center(child: CircularProgressIndicator(),);
            }if(state is GetOrdersError){
              return Center(child: Text(state.errorMsg),);
            }if(state is GetOrdersSuc){
              if(state.orders.isEmpty){
                return Center(child: AppText(jsonKey: "لايوجد طلبات مواعيد"),);
              }
              return ListView.builder(
                  itemCount: state.orders.length,
                  itemBuilder: (context,index){
                    final order = state.orders[index];

                    return OrderCard(ordersModel: order);
                  }
              );
            }
            return SizedBox();
          }
      ),
    );
  }
}
