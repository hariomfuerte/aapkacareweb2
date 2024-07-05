import 'dart:async';
import 'package:aapkacare/screens/Hospital/hospital.dart';
import 'package:aapkacare/screens/Profile%20Page/Profile.dart';
import 'package:aapkacare/screens/Result%20Page/result_web.dart';
import 'package:aapkacare/screens/SubScription-Plan/main_subscription_plan.dart';
import 'package:aapkacare/screens/SubScription-Plan/sp.dart';
import 'package:aapkacare/screens/findPatient.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aapkacare/values/screen.dart';
import 'package:aapkacare/values/values.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ResultMobile extends StatefulWidget {
  final String experience;
  final String location;
  final List<Map<String, dynamic>> Result;
  const ResultMobile({super.key, required this.experience, required this.location, required this.Result});

  @override
  State<ResultMobile> createState() => _ResultMobileState();
}

class _ResultMobileState extends State<ResultMobile> {
  final String mobile = "9724******";
  RangeValues _values = RangeValues(0.0, 10000.0);
  bool isFirstVisible = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _addressController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _professionController = TextEditingController();

  bool _isLoading = true;

  // ignore: unused_field
  String? _selectedExperience;
  List<Map<String, dynamic>> _filteredResult = [];

  @override
  void initState() {
    super.initState();
    _startLoading();
    _filteredResult = widget.Result;
  }

  void _filterResults(String? selectedExperience) {
    setState(() {
      _selectedExperience = selectedExperience;
      if (selectedExperience != null) {
        if (selectedExperience == "25+") {
          _filteredResult = widget.Result.where((job) {
            int experience = int.parse(job['experience']);
            return experience > 25;
          }).toList();
        } else {
          List<String> range = selectedExperience.split(" - ");
          int minExp = int.parse(range[0]);
          int maxExp = range.length > 1 ? int.parse(range[1]) : minExp;
          _filteredResult = widget.Result.where((job) {
            int experience = int.parse(job['experience']);
            return experience >= minExp && experience <= maxExp;
          }).toList();
        }
      } else {
        _filteredResult = widget.Result;
      }
    });
  }

  void _startLoading() {
    Timer(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> addDataToFirestore() async {
    if (_formKey.currentState!.validate()) {
      DateTime date = DateTime.now();
      DocumentReference userDoc = FirebaseFirestore.instance.collection('Search').doc(date.toIso8601String());

      await userDoc
          .set({
            'full_name': _nameController.text.trim().toLowerCase(),
            'email': _emailController.text.trim(),
            'address': _addressController.text.trim().toLowerCase(),
            'mobile': _mobileController.text,
            'profession': widget.experience == "Doctor" || widget.experience == "Nurse" ? _professionController.text.trim().toLowerCase() : "",
            'timestamp': date,
          })
          .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Data Submit Successfully'),
                ),
              ))
          // ignore: invalid_return_type_for_catch_error
          .catchError((error) => print("Failed to add user: $error"));
    }
  }

  @override
  Widget build(BuildContext context) {
    Screen s = Screen(context);
    // final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Color(0xfff4f9fe),
      // backgroundColor: white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: s.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10 * s.customHeight,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20 * s.customWidth),
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      width: s.width,
                      decoration: BoxDecoration(color: Color.fromRGBO(249, 249, 249, 1), border: Border.all(color: Color.fromARGB(42, 0, 0, 0)), borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10 * s.customHeight,
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 20 * s.customWidth, right: 5 * s.customWidth),
                                child: FaIcon(Icons.search_outlined),
                              ),
                              Expanded(
                                child: Container(
                                  width: 100,
                                  child: AutoSizeText(
                                    widget.experience, //"Driving Jobs",
                                    style: GoogleFonts.poppins(fontSize: 15, color: black),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20 * s.customWidth,
                              ),
                              SizedBox(
                                height: 30 * s.customHeight,
                                child: VerticalDivider(
                                  color: Colors.grey,
                                  thickness: 2,
                                ),
                              ),
                              SizedBox(
                                width: 40 * s.customWidth,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: Icon(
                                  Icons.bus_alert,
                                  color: red,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  // color: Colors.amber,
                                  constraints: BoxConstraints(maxWidth: 250),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: AutoSizeText(
                                      overflow: TextOverflow.ellipsis,
                                      widget.location,
                                      style: GoogleFonts.poppins(fontSize: 15, color: black),
                                    ),
                                  ),
                                ).pOnly(right: 20 * s.customWidth),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10 * s.customHeight,
                          ),
                          Row(
                            children: [
                              widget.experience == "Doctor" || widget.experience == "Nursing"
                                  ? Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.white,
                                          border: Border.all(color: Colors.grey.shade400),
                                        ),
                                        child: buildCustomDropdownForm(
                                          items: [
                                            "1 - 5",
                                            "6 - 10",
                                            "11 - 15",
                                            "16 - 20",
                                            "21 - 25",
                                            "25+"
                                          ],
                                          onChanged: _filterResults,
                                        ),
                                      ),
                                    )
                                  : Container(),
                              SizedBox(
                                width: (s.width > 700 ? 20 : 0) * s.customWidth,
                              ),
                              s.width > 700
                                  ? widget.experience == "Nursing" || widget.experience == "Doctor"
                                      ? Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "\₹${_values.start.round()}",
                                                    style: GoogleFonts.poppins(fontSize: 12, color: black, fontWeight: FontWeight.bold),
                                                  ),
                                                  Text(
                                                    " Doctor Fees",
                                                    style: GoogleFonts.poppins(color: black, fontSize: 14, fontWeight: FontWeight.w500),
                                                  ),
                                                  Text(
                                                    "\₹${_values.end.round()}",
                                                    style: GoogleFonts.poppins(fontSize: 12, color: black, fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              RangeSlider(
                                                values: _values,
                                                activeColor: Color.fromARGB(255, 27, 181, 253),
                                                onChanged: (values) {
                                                  setState(() {
                                                    _values = values;
                                                  });
                                                },
                                                min: 0.0,
                                                max: 10000.0,
                                                divisions: 100,
                                              ).h(30),
                                            ],
                                          ),
                                        )
                                      : Container()
                                  : Container(),
                            ],
                          ).pOnly(right: 20 * s.customWidth, left: 20 * s.customWidth),
                          SizedBox(
                            height: widget.experience == "Nursing" || widget.experience == "Doctor" ? 10 : 0 * s.customHeight,
                          ),
                          s.width > 700
                              ? Container()
                              : Row(
                                  children: [
                                    widget.experience == "Nursing" || widget.experience == "Doctor"
                                        ? Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      "\₹${_values.start.round()}",
                                                      style: GoogleFonts.poppins(fontSize: 12, color: black, fontWeight: FontWeight.bold),
                                                    ),
                                                    Text(
                                                      " Doctor Fees",
                                                      style: GoogleFonts.poppins(color: black, fontSize: 14, fontWeight: FontWeight.w500),
                                                    ),
                                                    Text(
                                                      "\₹${_values.end.round()}",
                                                      style: GoogleFonts.poppins(fontSize: 12, color: black, fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                RangeSlider(
                                                  values: _values,
                                                  activeColor: Color.fromARGB(255, 27, 181, 253),
                                                  onChanged: (values) {
                                                    setState(() {
                                                      _values = values;
                                                    });
                                                  },
                                                  min: 0.0,
                                                  max: 10000.0,
                                                  divisions: 100,
                                                ).h(30),
                                              ],
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ).pOnly(right: 20 * s.customWidth, left: 20 * s.customWidth),
                          SizedBox(
                            height: widget.experience == "Nursing" || widget.experience == "Doctor" ? 10 : 0 * s.customHeight,
                          ),
                          Row(
                            children: [
                              _filteredResult.isEmpty
                                  ? Container()
                                  : Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) => FindPatient(
                                                      name: "${widget.experience}",
                                                    )),
                                          );
                                        },
                                        child: Container(
                                          height: 42 * s.customHeight,
                                          decoration: BoxDecoration(color: Color.fromARGB(255, 27, 181, 253), borderRadius: BorderRadius.circular(12)),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(right: 5),
                                                child: Icon(
                                                  Icons.search_sharp,
                                                  size: 15,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              AutoSizeText(
                                                "Find ${widget.experience}",
                                                style: GoogleFonts.aBeeZee(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                              _filteredResult.isEmpty
                                  ? Container()
                                  : SizedBox(
                                      width: 20 * s.customWidth,
                                    ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => FindPatient(
                                                name: "${widget.experience}",
                                              )),
                                    );
                                  },
                                  child: Container(
                                    height: 42 * s.customHeight,
                                    decoration: BoxDecoration(color: Color.fromARGB(255, 27, 181, 253), borderRadius: BorderRadius.circular(12)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 5),
                                          child: Icon(
                                            Icons.search_sharp,
                                            size: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                        AutoSizeText(
                                          "Search",
                                          style: GoogleFonts.aBeeZee(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ).pOnly(right: 20 * s.customWidth, left: 20 * s.customWidth),
                          SizedBox(
                            height: 10 * s.customHeight,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20 * s.customHeight,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20 * s.customWidth),
                  child: Container(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              widget.experience,
                              style: GoogleFonts.aBeeZee(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            SizedBox(
                              width: 20 * s.customWidth,
                            ),
                            Text(
                              "Search Result (${_filteredResult.length})",
                              style: GoogleFonts.aBeeZee(color: grey, fontWeight: FontWeight.bold, fontSize: 14),
                            ).pOnly(bottom: 3),
                            Expanded(
                              child: Container(
                                color: Colors.transparent,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10 * s.customHeight,
                        ),
                        Expanded(
                          child: ScrollConfiguration(
                            behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Container(
                                // color: Colors.amber,
                                width: double.infinity,
                                child: LayoutBuilder(
                                  builder: (BuildContext context, BoxConstraints constraints) {
                                    int numberOfColumns = (constraints.maxWidth < 800 ? (s.width < 600 ? 2 : 3) : 4);
                                    int numberOfRows = (_filteredResult.length / numberOfColumns).ceil();
                                    if (_isLoading) {
                                      return Container(
                                        height: 500 * s.customHeight,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.blue,
                                          ),
                                        ),
                                      );
                                    } else if (_filteredResult.isEmpty) {
                                      return Container(
                                        child: isFirstVisible ? firstCodeWidget(s: s) : secondCodeWidget(s: s),
                                      );
                                    } else {
                                      return Column(
                                        children: List.generate(numberOfRows, (index) {
                                          return Row(
                                            children: List.generate(numberOfColumns, (columnIndex) {
                                              int dataIndex = index * numberOfColumns + columnIndex;
                                              if (dataIndex < _filteredResult.length) {
                                                var jobData = _filteredResult[dataIndex];

                                                return Expanded(
                                                  child: CustomJobContainer(
                                                    containerColor: jobData['containerColor'] ?? '',
                                                    onDetailsTap: () {
                                                      Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                          builder: (context) => widget.experience == "Patient"
                                                              ? SubscriptionPlan()
                                                              : widget.experience == "Hospital"
                                                                  ? Hospital(
                                                                      id: jobData['id'],
                                                                      profession: widget.experience,
                                                                    )
                                                                  : Profile(
                                                                      city: jobData['address'],
                                                                      name: jobData['name'],
                                                                      specification: jobData['experience'],
                                                                      image: jobData['image'],
                                                                    ),
                                                        ),
                                                      );
                                                    },
                                                    jobTitle: jobData['name'] ?? '',
                                                    mobile: widget.experience == "Patient" ? mobile : jobData['phone'] ?? '',
                                                    address: jobData['address'] ?? '',
                                                    experience: widget.experience == "Doctor" || widget.experience == "Nursing" ? jobData['experience'] ?? '' : '',
                                                    imageUrl: jobData['image'] ?? '',
                                                  ).pOnly(right: 20, bottom: 20),
                                                );
                                              } else {
                                                return Expanded(child: SizedBox());
                                              }
                                            }),
                                          );
                                        }),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget firstCodeWidget({required Screen s}) {
    return Container(
      height: 500 * s.customHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Can't Find Your Search ${widget.experience}",
            style: GoogleFonts.montserrat(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20, // replace with 20 * s.customHeight if needed
          ),
          InkWell(
            onTap: () {
              setState(() {
                isFirstVisible = false;
              });
            },
            child: Container(
              height: 42, // replace with 42 * s.customHeight if needed
              width: 200, // replace with 200 * s.customWidth if needed
              padding: EdgeInsets.only(right: 20, left: 20), // adjust padding as needed
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 27, 181, 253),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Icon(
                      Icons.search_sharp,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                  AutoSizeText(
                    "Find ${widget.experience}",
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget secondCodeWidget({required Screen s}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50 * s.customWidth), // replace with 150 * s.customWidth if needed
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20 * s.customHeight,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 55,
                  width: 75,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 27, 181, 253),
                    border: Border.all(color: Color.fromARGB(95, 0, 0, 0)),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    FontAwesomeIcons.userDoctor,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10 * s.customHeight,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  s.width < 700
                      ? Column(
                          children: [
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
                            SizedBox(
                              height: 10 * s.customHeight,
                            ),
                            CustomTextField(
                              controller: _emailController,
                              hintText: 'Email',
                              icon: Icon(Icons.email),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your Email';
                                } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                                  return 'Add proper email';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 20 * s.customHeight,
                            ),
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
                            SizedBox(
                              height: 20 * s.customHeight,
                            ),
                            CustomTextField(
                              controller: _mobileController,
                              hintText: 'Mobile No.',
                              icon: Icon(Icons.phone),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your mobile no.';
                                } else if (value.length != 10) {
                                  return 'Mobile no. must be 10 digits';
                                }
                                return null;
                              },
                            ),
                          ],
                        )
                      : Container(),
                  s.width > 700
                      ? Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
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
                            ),
                            SizedBox(
                              width: 20 * s.customWidth,
                            ),
                            Expanded(
                              child: CustomTextField(
                                controller: _emailController,
                                hintText: 'Email',
                                icon: Icon(Icons.email),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your Email';
                                  } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                                    return 'Add proper email';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  SizedBox(
                    height: s.width > 700 ? 20 * s.customHeight : 0,
                  ),
                  s.width > 700
                      ? Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
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
                            ),
                            SizedBox(
                              width: 20 * s.customWidth,
                            ),
                            Expanded(
                              child: CustomTextField(
                                controller: _mobileController,
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
                            ),
                          ],
                        )
                      : Container(),
                  SizedBox(
                    height: widget.experience == "Doctor" || widget.experience == "Nurse" ? 20 * s.customHeight : 0,
                  ),
                  widget.experience == "Doctor" || widget.experience == "Nurse"
                      ? CustomTextField(
                          controller: _professionController,
                          hintText: '${widget.experience} Profession',
                          icon: Icon(Icons.person_search_sharp),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter doctor profession';
                            }
                            return null;
                          },
                        )
                      : Container(),
                ],
              ),
            ).px(16),
            SizedBox(
              height: (s.width > 700 ? 20 : 30) * s.customHeight,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        // Perform submit action
                        addDataToFirestore();
                        _addressController.clear();
                        _emailController.clear();
                        _mobileController.clear();
                        _nameController.clear();
                        _professionController.clear();
                      }
                    },
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(color: Color.fromARGB(255, 27, 181, 253), borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.check_mark_circled_solid,
                            size: 22,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Submit",
                            style: GoogleFonts.poppins(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20 * s.customWidth),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _addressController.clear();
                        _emailController.clear();
                        _mobileController.clear();
                        _nameController.clear();
                        _professionController.clear();
                        isFirstVisible = true;
                      });
                    },
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(color: Color.fromRGBO(253, 28, 28, 1), borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.clear_circled_solid,
                            size: 22,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text(
                            "Cancel",
                            style: GoogleFonts.poppins(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ).px(16),
            SizedBox(
              height: 20 * s.customHeight,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCustomDropdownForm({
    required List<String> items,
    // required String dropdownValue,
    required ValueChanged<String?> onChanged,
  }) {
    return Theme(
      data: ThemeData(focusColor: Colors.lightBlue),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.work_history,
            color: green,
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.transparent,
          )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.transparent,
          )),
          filled: true,
          fillColor: Colors.transparent,
          hintText: "Experience",
          hintStyle: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
          // border: OutlineInputBorder(),
        ),
        // value: dropdownValue,
        items: items.map((String item) {
          return DropdownMenuItem(
            value: item,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "${item} Year",
                style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w500, color: Colors.black),
              ).pOnly(top: 4),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        iconSize: 30,
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black,
          // size: 30,
        ).pOnly(top: 2),
        dropdownColor: Color.fromARGB(213, 242, 242, 242),
      ),
    );
  }
}
