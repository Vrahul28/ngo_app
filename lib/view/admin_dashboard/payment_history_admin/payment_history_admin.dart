import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/exeception/status.dart';
import '../../../res/routes_name/routes_name.dart';
import '../../../view_models/admin_controller/payment_history_controller.dart';
import '../../../widgets/custom_card_payment_history.dart';


class PaymentHistoryAdmin extends StatelessWidget {
  const PaymentHistoryAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final his= Get.find<PaymentHistoryController>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Payment History', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(RoutesName.filterPaymentHistoryPage);
            },
            icon: const Icon(Icons.filter_alt_outlined, color: Colors.black),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0,right: 15.0,top: 5.0, bottom: 10.0),
          child: Obx(
                () {
                  switch (his.rxRequestStatus.value) {
                    case Status.LOADING:
                      return SizedBox(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    case Status.ERROR:
                      return SizedBox(
                        child: Center(child: Text(his.error.toString())),
                      );
                    case Status.COMPLETED:
                      return his.history.isEmpty ? SizedBox(
                        child: Center(child: Text('No Payment History found')),
                      ): ListView.builder(
                        itemCount: his.history.length,
                        itemBuilder: (context, index) {
                          final hist= his.history[index];
                          return CustomCardPaymentHistory(
                            date: hist.paymentDate != null
                                ? his.formatDate(hist.paymentDate!)
                                : '',
                            name: hist.userName ?? '',
                            email:  hist.userEmail ?? '',
                            amount: hist.amount.toString(),
                          );
                        },
                      );
                  }

            },
          ),
        ),
      ),
    );
  }
}
