import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd_client_app/presentation/profile/widgets/notification_card.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_text.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {


  @override
  void initState() {
    context.read<ProfileCubit>().getNotifications() ;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(titleKey: "الاشعارات",),
      backgroundColor: AppColors.background,
      body: BlocBuilder<ProfileCubit,ProfileState>(
          builder: (context, state){
            if(state is GetNotificationsLoading){
              return Center(child: CircularProgressIndicator(),);
            }if(state is GetNotificationsError){
              return Center(child: Text(state.errorMsg),);
            }if(state is GetNotificationsSuc){
              if(state.notifications.isEmpty){
                return Center(child: AppText(jsonKey: "لايوجد اشعارات"),);
              }
              return ListView.builder(
                  itemCount: state.notifications.length,
                  itemBuilder: (context,index){
                    final notification = state.notifications[index];

                    return NotificationCard(notification: notification);
                  }
              );
            }
            return SizedBox();
          }
      ),
    );
  }
}
