import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:nabd_client_app/presentation/appointments/cubit/appointments_cubit.dart';
import 'package:nabd_client_app/presentation/appointments/cubit/appointments_state.dart';

class CustomCalendarWidget extends StatelessWidget {
  final Function(String date)? onTap;

  const CustomCalendarWidget({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppointmentsCubit>();

    return BlocBuilder<AppointmentsCubit, AppointmentsState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: TableCalendar(
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(
              const Duration(days: 90),
            ),
            focusedDay: cubit.selectedDate ?? DateTime.now(),

            rowHeight: 30,

            selectedDayPredicate: (day) {
              return isSameDay(
                cubit.selectedDate,
                day,
              );
            },

            onDaySelected: (selectedDay, focusedDay) {
              cubit.selectDate(selectedDay);

              onTap?.call(
                cubit.selectedDateString,
              );
            },

            weekendDays: const [
              DateTime.friday,
            ],

            calendarStyle: CalendarStyle(
              cellMargin: const EdgeInsets.all(2),
              defaultTextStyle: const TextStyle(
                fontSize: 13,
              ),
              weekendTextStyle: const TextStyle(
                color: Colors.red,
                fontSize: 13,
              ),
              todayTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
              selectedTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
              todayDecoration: const BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              selectedDecoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),

            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                fontSize: 12,
              ),
              weekendStyle: TextStyle(
                fontSize: 12,
                color: Colors.red,
              ),
            ),

            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              headerPadding: EdgeInsets.symmetric(
                vertical: 4,
              ),
            ),
          ),
        );
      },
    );
  }
}