import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  final TextEditingController controller = TextEditingController();

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                  transform: null,
                  child: Container(
                    height: 300,
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
              const SizedBox(
                height: 20,
              ),
              // ignore: avoid_unnecessary_containers
              Container(
                child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(
                          width: 1, color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    hintText: 'Amount',
                    prefixIcon: Icon(
                      Icons.attach_money_outlined,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                transform: null,
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
            ],
          ),
        ),
      ),
    );
  }

//----------------payment-success--msg--------
  void _hadlePaymentSuccess(PaymentSuccessResponse response) {
    // ignore: sized_box_for_whitespace
    Fluttertoast.showToast(
        msg: "SUCCESS : ${response.paymentId!}",
        toastLength: Toast.LENGTH_SHORT);
  }

  //----------------payment-failure--msg--------
  void _hadlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
      msg: "FAILED : ${"${response.code} - ${response.message!}"}",
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  //----------------External-wallet--msg--------
  void _hadleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL WALLET : ${response.walletName!}",
        toastLength: Toast.LENGTH_SHORT);
  }

  void checkout() {
    var options = {
      'key': 'your_key',
      'amount': int.parse(controller.text) * 100,
      'name': 'your_name..',
      'description': 'Business Deal',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '012345678', 'email': 'your_email'},
      'external': {
        'wallets': ['wallet']
      },
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint("Error : $e");
    }
  }

  void paymentSuccess() {}
}
