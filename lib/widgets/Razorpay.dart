import 'package:aapkacare/screens/payment_success.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_web/razorpay_web.dart';

class RazorPayIntegration {
  late final BuildContext context;
  late Razorpay _razorpay;
  final String razorPayKey = "rzp_test_nMeapCxnNSFMNk";

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController addressController;
  final TextEditingController mobileController;

  RazorPayIntegration(
    this.context, {
    required this.nameController,
    required this.emailController,
    required this.addressController,
    required this.mobileController,
  }) {
    initiateRazorPay();
  }

  initiateRazorPay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void dispose() {
    _razorpay.clear();
  }

  void openCheckout() {
    var options = {
      'key': razorPayKey,
      'amount': 100 * 100,
      "currency": "INR",
      'name': 'AapkaCare',
      'description': 'Subscription Plan',
      'send_sms_hash': true,
      'prefill': {
        'contact': '8888888888',
        'email': 'test@razorpay.com'
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Success Response: $response');
    Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentSuccess()));
    addDataToFirestore();
    // Additional success handling logic here
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Error Response: $response');
    // Additional error handling logic here
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External SDK Response: $response');
    // Additional external wallet handling logic here
  }

  Future<void> addDataToFirestore() async {
    DateTime date = DateTime.now();
    DocumentReference userDoc = FirebaseFirestore.instance.collection('Subscribers').doc(date.toIso8601String());

    await userDoc
        .set({
          'full_name': nameController.text.toLowerCase(),
          'email': emailController.text,
          'address': addressController.text.toLowerCase(),
          'mobile': mobileController.text,
          'timestamp': date,
        })
        // .then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentSuccess())))
        // ignore: invalid_return_type_for_catch_error
        .catchError((error) => print("Failed to add user: $error"));
  }
}
