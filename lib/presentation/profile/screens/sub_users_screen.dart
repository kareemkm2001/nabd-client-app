import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd_client_app/core/widgets/app_text.dart';
import 'package:nabd_client_app/presentation/profile/cubit/profile_cubit.dart';
import 'package:nabd_client_app/presentation/profile/cubit/profile_state.dart';
import 'package:nabd_client_app/presentation/profile/widgets/sub_user_card.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_app_bar.dart';

class SubUsersScreen extends StatefulWidget {
  const SubUsersScreen({super.key});

  @override
  State<SubUsersScreen> createState() => _SubUsersScreenState();
}

class _SubUsersScreenState extends State<SubUsersScreen> {

  @override
  void initState() {
    context.read<ProfileCubit>().getSubUsers();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(titleKey: "التابعين",),
      backgroundColor: AppColors.background,
      body: BlocBuilder<ProfileCubit,ProfileState>(
          builder: (context, state){
            if(state is GetSubUsersLoading){
              return Center(child: CircularProgressIndicator(),);
            }if(state is GetSubUsersError){
              return Center(child: Text(state.errorMsg),);
            }if(state is GetSubUsersSuc){
              if(state.subUsers.isEmpty){
                return Center(child: AppText(jsonKey: "لايوجد تابعين"),);
              }
              return ListView.builder(
                  itemCount: state.subUsers.length,
                  itemBuilder: (context,index){
                    final user = state.subUsers[index];

                    return SubUserCard(
                      id: user.id,
                      fullName: user.fullName,
                      fullNameEn: user.fullNameEn,
                      mobile: user.mobile,
                      telephone: user.telephone,
                      email: user.email,
                      gender: user.gender,
                      socialSituation: user.socialSituation,
                      age: user.age,
                      nationality: user.nationality,
                      status: user.status,
                      smsStatus: user.smsStatus,
                      proofNum: user.proofNum,
                      createdAt: user.createdAtFormatted,
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
