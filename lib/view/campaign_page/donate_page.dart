import 'package:flutter/material.dart';
import '../../res/app_colors/app_colors.dart';
import 'package:get/get.dart';
import '../../view_models/payment_controller/payment_controller.dart';
import '../../widgets/custom_textfields.dart';

class DonatePage extends StatelessWidget {
  const DonatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final pc = Get.find<PaymentController>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Donate Amount', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Get.back();
              pc.amount.value.clear();
            },
            icon: Icon(Icons.arrow_back,color: Colors.black)
        ),
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.only(left: 15.0,right: 15.0,top: 5.0, bottom: 10.0),
            child: Column(
              children: [
                CustomTextFields(
                  controller: pc.amount.value,
                  hintText: 'Enter Amount',
                  obscure: false,
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    pc.startPayment(int.parse(pc.amount.value.text));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.admin,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: pc.loading.value ? const CircularProgressIndicator() : const Text('Pay Now', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                )
              ],
            )
        ),
      ),
    );
  }
}
