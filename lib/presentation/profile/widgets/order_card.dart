import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nabd_client_app/domain/models/profile/orders_model.dart';

class OrderCard extends StatelessWidget {
  final OrdersModel ordersModel;

  const OrderCard({
    super.key,
    required this.ordersModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            children: [
              Expanded(
                child: Text(
                  ordersModel.service.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  ordersModel.status,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Wrap(
            spacing: 20,
            runSpacing: 12,
            children: [
              _InfoItem(
                title: "العيادة",
                value: ordersModel.clinic.name,
              ),
              _InfoItem(
                title: "الطبيب",
                value: ordersModel.clinic.doctor.fullName,
              ),
              _InfoItem(
                title: "نوع الحجز",
                value: ordersModel.isPackage,
              ),
              _InfoItem(
                title: "حالة الموعد",
                value: ordersModel.appointment.status,
              ),

              /// يظهر فقط لو موجود
              if (ordersModel.measureClinic.id != 0)
                _InfoItem(
                  title: "المقياس",
                  value: ordersModel.measureClinic.name,
                ),

              /// يظهر فقط لو موجود
              if (ordersModel.measureService.id != 0)
                _InfoItem(
                  title: "الاختبار",
                  value: ordersModel.measureService.name,
                ),
            ],
          ),

          const SizedBox(height: 16),

          const Divider(),

          Row(
            children: [
              Expanded(
                child: Text(
                  ordersModel.createdAt,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),

              Text(
                "#${ordersModel.id}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String title;
  final String value;

  const _InfoItem({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * .38,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}