import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngo_app/res/routes_name/routes_name.dart';
import '../../../res/app_colors/app_colors.dart';
import '../../../view_models/admin_controller/payment_history_controller.dart';
import '../../../widgets/custom_card_payment_history.dart';
import '../../../widgets/custom_textfields.dart';

class FilterPaymentHistory extends StatelessWidget {
  const FilterPaymentHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final his= Get.find<PaymentHistoryController>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Payment History', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.only(left: 15.0,right: 15.0,top: 5.0, bottom: 10.0),
            child: Column(
              children: [
                CustomTextFields(
                  controller: his.name.value,
                  hintText: 'Name',
                  obscure: false,
                ),
                const SizedBox(height: 16),
                TextFormField(
                    controller: his.fromDate.value,
                    decoration: InputDecoration(
                        labelText: 'From Date',
                        suffixIcon: IconButton(
                            onPressed: () {
                              his.openDatePicker(context, his.fromDate.value);
                            },
                            icon: Icon(Icons.calendar_month,color: AppColors.primary,)
                        ),
                        border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(12)
                            )
                        ),
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)), borderSide: BorderSide(color: AppColors.primary)),
                    )
                ),
                const SizedBox(height: 16),
                TextFormField(
                    controller: his.toDate.value,
                    decoration: InputDecoration(
                        labelText: 'To Date',
                        suffixIcon: IconButton(
                            onPressed: () {
                              his.openDatePicker(context, his.toDate.value);
                            },
                            icon: Icon(Icons.calendar_month,color: AppColors.primary,)
                        ),
                        border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(12)
                            )
                        ),
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)), borderSide: BorderSide(color: AppColors.primary)),
                    )
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    his.fetchPaymentHistory(his.name.value.text.trim(), his.fromDate.value.text, his.toDate.value.text);
                    Get.toNamed(RoutesName.searchResultPaymentHistoryPage);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.admin,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Search', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ),
              ],
            )
        ),
      ),
    );
  }
}
