import 'package:aapkacare/screens/SubScription-Plan/main_subscription_plan.dart';
import 'package:aapkacare/widgets/Razorpay.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:google_fonts/google_fonts.dart';

class SubscriptionPlanMobile extends StatefulWidget {
  const SubscriptionPlanMobile({super.key});

  @override
  State<SubscriptionPlanMobile> createState() => _SubscriptionPlanMobileState();
}

class _SubscriptionPlanMobileState extends State<SubscriptionPlanMobile> {
  int leftSelectedOption = 0;
  int chooseCardOption = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var razor = RazorPayIntegration(
      context,
      nameController: _nameController,
      emailController: _emailController,
      addressController: _addressController,
      mobileController: _mobileController,
    );
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.white,
        backgroundColor: Color.fromRGBO(0, 162, 239, 0.4),
        body: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 10.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      // Logo And Main Subscription Plan Heading
                      Row(
                        children: [
                          CircleAvatar(
                              radius: 30,
                              backgroundColor: Color.fromRGBO(0, 162, 239, 1),
                              child: Icon(
                                Icons.person_outline_sharp,
                                color: Colors.white,
                                size: 30,
                              )
                              //  Image.asset(height: 35.0, "assets/images/logo.png"),
                              ),
                          20.widthBox,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Subscription Plan",
                                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "Unloack instant access to all existing \nproducts and daily new releases",
                                style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400, color: Color.fromARGB(229, 117, 117, 117)),
                              ),
                            ],
                          )
                        ],
                      ),

                      10.heightBox,

                      Divider(
                        color: Colors.grey.shade400,
                      ),

                      10.heightBox,

                      // First Choose Plan Cupertino Radio Button Left side
                      Text(
                        "Choose Plan",
                        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      10.heightBox,

                      // First Pro Plan Container Left Side

                      InkWell(
                        onTap: () {
                          setState(() {
                            leftSelectedOption = 0;
                          });
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade200),
                                  color: Color.fromRGBO(248, 248, 248, 1),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Row(
                                  children: [
                                    // For Custom radio Button Container
                                    Container(
                                      height: 12,
                                      width: 12,
                                      decoration: BoxDecoration(border: Border.all(color: leftSelectedOption == 0 ? Colors.deepPurple : Colors.black, width: 1.0), shape: BoxShape.circle),
                                      child: Center(
                                        child: Container(
                                          height: 6,
                                          width: 6,
                                          decoration: BoxDecoration(color: leftSelectedOption == 0 ? Colors.deepPurple : Colors.white, shape: BoxShape.circle),
                                        ),
                                      ),
                                    ),

                                    10.widthBox,
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        mainHeading(
                                          text: "Pro Plan",
                                        ),
                                        subHeading(
                                          text: "Crafted for Individuals",
                                        ),
                                      ],
                                    ),

                                    Spacer(),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        mainHeading(
                                          text: "\₹1000.00",
                                        ),
                                        subHeading(
                                          text: "10 User / Quarterly",
                                        ),
                                      ],
                                    ).pOnly(right: 10.0),
                                  ],
                                ).px8(),
                              ),
                            ),
                          ],
                        ),
                      ),

                      10.heightBox,

                      // Second Team Plan Container Left Side

                      InkWell(
                        onTap: () {
                          setState(() {
                            leftSelectedOption = 1;
                          });
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade200),
                                  color: Color.fromRGBO(248, 248, 248, 1),
                                  // color: Colors.amber,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                // height: 230,
                                child: Column(
                                  children: [
                                    // Team Plan Main Heading Row
                                    Row(
                                      children: [
                                        // For Custom Radio Button Container
                                        Container(
                                          height: 12,
                                          width: 12,
                                          decoration: BoxDecoration(border: Border.all(color: leftSelectedOption == 1 ? Colors.deepPurple : Colors.black, width: 1.0), shape: BoxShape.circle),
                                          child: Center(
                                            child: Container(
                                              height: 6,
                                              width: 6,
                                              decoration: BoxDecoration(color: leftSelectedOption == 1 ? Colors.deepPurple : Colors.white, shape: BoxShape.circle),
                                            ),
                                          ),
                                        ).pOnly(bottom: 25),

                                        10.widthBox,

                                        // Team Plan Row
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            mainHeading(
                                              text: "Team Plan",
                                            ),
                                            subHeading(
                                              text: "Crafted for small teams or ",
                                            ),
                                            subHeading(
                                              text: "business",
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            mainHeading(
                                              text: "\₹5000.00",
                                            ),
                                            subHeading(
                                              text: "50 User / Quarterly",
                                            ),
                                          ],
                                        ).pOnly(right: 10.0),
                                      ],
                                    ).p(8),
                                    10.heightBox,

                                    // For write icon list 1
                                    doneLine(text: "50 downloads per day"),
                                    10.heightBox,

                                    // For write icon list 2
                                    doneLine(text: "Access to all products or bundles"),
                                    10.heightBox,

                                    // For write icon list 3
                                    doneLine(text: "Early access to new/beta release \nfeatures"),

                                    10.heightBox,

                                    // Team Accounts Row
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                      10.heightBox,

                      // Third Business Pro Container

                      InkWell(
                        onTap: () {
                          setState(() {
                            leftSelectedOption = 2;
                          });
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), color: Color.fromRGBO(248, 248, 248, 1), borderRadius: BorderRadius.circular(5.0)),
                                height: 60,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 12,
                                      width: 12,
                                      decoration: BoxDecoration(border: Border.all(color: leftSelectedOption == 2 ? Colors.deepPurple : Colors.black, width: 1.0), shape: BoxShape.circle),
                                      child: Center(
                                        child: Container(
                                          height: 6,
                                          width: 6,
                                          decoration: BoxDecoration(color: leftSelectedOption == 2 ? Colors.deepPurple : Colors.white, shape: BoxShape.circle),
                                        ),
                                      ),
                                    ),
                                    15.widthBox,
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        mainHeading(
                                          text: "Business Pro",
                                        ),
                                        subHeading(
                                          text: "For Big Teams",
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        mainHeading(
                                          text: "\₹10000.00",
                                        ),
                                        subHeading(
                                          text: "100 User / Quarterly",
                                        ),
                                      ],
                                    ).pOnly(right: 10.0),
                                  ],
                                ).px(8),
                              ).pOnly(right: 5.0),
                            ),
                          ],
                        ),
                      ),

                      10.heightBox,

                      // Payment Plan Cupertino Radio Button Line
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Fill Your Details",
                            style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),

                      10.heightBox,

                      // Discount Code Container
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), color: Color.fromRGBO(248, 248, 248, 1), borderRadius: BorderRadius.circular(5.0)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Form
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      children: <Widget>[
                                        CustomTextField(
                                          controller: _nameController,
                                          hintText: 'Full Name',
                                          icon: Icon(Icons.person),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter your Name';
                                            }
                                            return null;
                                          },
                                        ),
                                        10.heightBox,
                                        CustomTextField(
                                          controller: _emailController,
                                          hintText: 'Email',
                                          icon: Icon(Icons.email_outlined),
                                          keyboardType: TextInputType.number,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter your Email';
                                            } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                                              return 'add proper email';
                                            }
                                            return null;
                                          },
                                        ),
                                        10.heightBox,
                                        CustomTextField(
                                          controller: _addressController,
                                          hintText: 'Address',
                                          icon: Icon(Icons.location_on_rounded),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter your address';
                                            }
                                            return null;
                                          },
                                        ),
                                        10.heightBox,
                                        CustomTextField(
                                          controller: _mobileController,
                                          hintText: 'Mobile No.',
                                          icon: Icon(Icons.phone),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter your state';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                                  ).px24(),

                                  8.heightBox,
                                ],
                              ).p(8),
                            ).pOnly(right: 5.0),
                          ),
                        ],
                      ),

                      10.heightBox,
                      // Pay Button
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  razor.openCheckout();
                                  // razor.initiateRazorPay();
                                }
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(0, 162, 239, 1),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Center(
                                  child: Text(
                                    "PAY NOW",
                                    style: GoogleFonts.poppins(fontSize: 15.0, fontWeight: FontWeight.w500, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ).pOnly(right: 5.0),

                      20.heightBox,
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
