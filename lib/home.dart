import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:fluttertoast/fluttertoast.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Razorpay _razorpay;

  @override
  void initState() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _hadlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _hadlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _hadleExternalWallet);
    super.initState();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 224, 255, 238),
      appBar: AppBar(
        leading: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black,
        ),
        backgroundColor: const Color.fromARGB(255, 68, 200, 130),
        title: const Text(
          'ʀᴀᴢᴏʀᴘᴀʏ ᴘᴀʏᴍᴇɴᴛ',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 130.0),
          child: Column(
            children: [
              Center(
                child: Container(
                  transform: null,
                  child: Container(
                    height: 360,
                    width: 280,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black,
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: Offset(4, 4),
                        ),
                        BoxShadow(
                          color: Colors.white,
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: Offset(-4, -4),
                        ),
                      ],
                    ),
                    child: Lottie.network(
                        'https://assets1.lottiefiles.com/packages/lf20_Q55c4I.json',
                        height: 160,
                        width: 160,
                        alignment: Alignment.center),
                  ),
                ),
              ),
              Container(
                transform: null,
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: GestureDetector(
                    onTap: () {
                      checkout();
                    },
                    child: Container(
                      height: 40,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: Offset(4, 4),
                          ),
                          BoxShadow(
                            color: Colors.white,
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: Offset(-4, -4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          "ᴘᴀʏᴍᴇɴᴛ",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//----------------payment-success--msg--------
  void _hadlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "SUCCESS : ${response.paymentId!}",
        toastLength: Toast.LENGTH_SHORT);
  }

  //----------------payment-failure--msg--------
  void _hadlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "FAILED : ${"${response.code} - ${response.message!}"}",
        toastLength: Toast.LENGTH_SHORT);
  }

  //----------------External-wallet--msg--------
  void _hadleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL WALLET : ${response.walletName!}",
        toastLength: Toast.LENGTH_SHORT);
  }

  void checkout() {
    var options = {
      'key': 'rzp_test_4Jw7TAlTgYhszu',
      'amount': 10,
      'name': 'Salim 123',
      'description': 'Business Deal',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '8156850106', 'email': 'lampdeep47@gmail.com'},
      'external': {
        'wallets': ['paytm']
      },
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint("Error : $e");
    }
  }
}
