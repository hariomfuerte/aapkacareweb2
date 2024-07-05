// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:aapkacare/screens/SubScription-Plan/main_subscription_plan.dart';
import 'package:aapkacare/values/screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

class FindPatient extends StatefulWidget {
  final String name;
  const FindPatient({super.key, required this.name});

  @override
  State<FindPatient> createState() => _FindPatientState();
}

class _FindPatientState extends State<FindPatient> {
  int leftSelectedOption = 0;
  int chooseCardOption = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _addressController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _pincodeController = TextEditingController();
  TextEditingController _professionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Screen s = Screen(context);
    return Scaffold(
      // backgroundColor: const Color.fromRGBO(233, 233, 233, 1),
      backgroundColor: Color.fromRGBO(0, 162, 239, 0.4),
      body: Align(
        alignment: Alignment.center,
        child: Container(
          // height: 550,
          width: 450,
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(s.isMobile ? 0 : 15.0),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.heightBox,
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Color.fromRGBO(0, 162, 239, 1),
                    child: Icon(
                      Icons.person_search_outlined,
                      size: 30,
                      color: Colors.white,
                    ),
                    // child: Image.asset(height: 35.0, "assets/images/logo.png"),
                  ),
                  20.widthBox,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Find ${widget.name}",
                        style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Unlock instant access to all ${widget.name}",
                        style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w400, color: Color.fromARGB(229, 117, 117, 117)),
                      ),
                    ],
                  )
                ],
              ),
              10.heightBox,
              Divider(
                color: Colors.grey.shade300,
              ),
              10.heightBox,

              // Payment Plan Cupertino Radio Button Line
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Fill Details",
                    style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ],
              ),

              10.heightBox,

              // Form
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
                                  controller: _addressController,
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
                                  controller: _pincodeController,
                                  hintText: 'Email',
                                  icon: Icon(Icons.email),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your Email';
                                    } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                                      return 'add proper email';
                                    }
                                    return "null";
                                  },
                                ),
                                10.heightBox,
                                CustomTextField(
                                  controller: _cityController,
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
                                  controller: _stateController,
                                  hintText: 'Mobile No.',
                                  icon: Icon(Icons.phone),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your state';
                                    } else if (value.length != 10) {
                                      return 'Mobile no. must be 10 digits';
                                    }
                                    return null;
                                  },
                                ),
                                10.heightBox,
                                CustomTextField(
                                  controller: _professionController,
                                  hintText: 'Doctor Profession',
                                  icon: Icon(Icons.person_search_sharp),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter doctor profession';
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
                    ),
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
                        if (_formKey.currentState!.validate()) {}
                      },
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(0, 162, 239, 1),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Center(
                          child: Text(
                            "Find",
                            style: GoogleFonts.poppins(fontSize: 15.0, fontWeight: FontWeight.w500, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ).py(s.isMobile ? 0 : 32),
      ),
    );
  }
}
