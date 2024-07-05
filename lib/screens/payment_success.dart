import 'package:aapkacare/screens/Home%20Page/Home.dart';
import 'package:aapkacare/values/screen.dart';
import 'package:aapkacare/values/values.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentSuccess extends StatefulWidget {
  const PaymentSuccess({super.key});

  @override
  State<PaymentSuccess> createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Screen s = Screen(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0 * s.customHeight),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 27, 181, 253),
          scrolledUnderElevation: 0,
          title: Row(
            children: [
              Container(
                width: 150,
                padding: EdgeInsets.all(10),
                child: Image.asset(
                  ImagePath.adsLogo,
                  fit: BoxFit.fill,
                ),
              ),
              s.width > 700
                  ? SizedBox(
                      width: 20 * s.customWidth,
                    )
                  : Container(),
              s.width > 700
                  ? Text(
                      "AAPKA CARE",
                      style: GoogleFonts.play(color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  : Container(),
            ],
          ),
          actions: [
            GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.only(right: 30),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  height: 40,
                  decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(30)),
                  child: Center(
                    child: Text(
                      "Download",
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          width: 400,
          child: Column(
            children: [
              Lottie.asset('assets/success.json', fit: BoxFit.fill),
              Text(
                "Payment Successfully",
                style: TextStyle(color: Colors.green, fontSize: 30),
              )
            ],
          ),
        ),
      ),
    );
  }
}
