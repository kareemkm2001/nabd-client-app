import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:nabd_client_app/presentation/appointments/cubit/appointments_cubit.dart';
import 'package:nabd_client_app/presentation/appointments/cubit/appointments_state.dart';

class DateTimeStep extends StatelessWidget {
  const DateTimeStep({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppointmentsCubit>();

    return BlocBuilder<AppointmentsCubit, AppointmentsState>(
      builder: (context, state) {
        return Column(
          children: [
            const SizedBox(height: 10),

            /// ===== CALENDAR =====
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: TableCalendar(
                  firstDay: DateTime.now(),
                  lastDay: DateTime.now().add(
                    const Duration(days: 60),
                  ),
                  focusedDay:
                  cubit.selectedDate ?? DateTime.now(),

                  selectedDayPredicate: (day) {
                    return isSameDay(cubit.selectedDate, day);
                  },

                  onDaySelected: (selectedDay, focusedDay) {
                    cubit.selectDate(selectedDay);
                  },

                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    weekendTextStyle:
                    const TextStyle(color: Colors.red),
                  ),

                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// ===== SLOTS =====
            Expanded(
              child: cubit.selectedDate == null
                  ? const Center(
                child: Text("اختار يوم لعرض المواعيد"),
              )
                  : state is GetSlotsLoading
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: cubit.slots.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final slot = cubit.slots[index];

                  final isBooked =
                      slot["appointment"] == true;

                  return AnimatedContainer(
                    duration: const Duration(
                        milliseconds: 250),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(12),
                      color: isBooked
                          ? Colors.red.shade100
                          : Colors.green.shade50,
                      border: Border.all(
                        color: isBooked
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${slot['from_time']} - ${slot['to_time']}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(
                          isBooked
                              ? Icons.close
                              : Icons.check,
                          color: isBooked
                              ? Colors.red
                              : Colors.green,
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}