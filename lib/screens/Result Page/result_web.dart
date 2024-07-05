import 'dart:async';
import 'package:aapkacare/screens/Hospital/hospital.dart';
import 'package:aapkacare/screens/Profile%20Page/Profile.dart';
import 'package:aapkacare/screens/Result%20Page/Result.dart';
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

class ResultWeb extends StatefulWidget {
  final String experience;
  final String location;
  final List<Map<String, dynamic>> Result;
  const ResultWeb({super.key, required this.experience, required this.location, required this.Result});

  @override
  State<ResultWeb> createState() => _ResultWebState();
}

class _ResultWebState extends State<ResultWeb> {
  final String mobile = "9724******";
  RangeValues _values = RangeValues(0.0, 10000.0);
  bool isFirstVisible = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<_DropdownWidgetState> ProfessionKey = GlobalKey<_DropdownWidgetState>();
  final GlobalKey<_DropdownWidgetState> ExperienceKey = GlobalKey<_DropdownWidgetState>();

  TextEditingController _addressController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _professionController = TextEditingController();

  bool _isLoading = true;

  //drop-down filter list
  late List<Map<String, dynamic>> _filteredResults;

  Map<String, List<String>> selectedFilters = {
    "Profession": [],
    "Experience": [],
  };

  @override
  void initState() {
    super.initState();
    _startLoading();
    printSelectedFilters();
    _filteredResults = widget.Result; // Initially, show all results
  }

  void clearAllFilters() {
    ProfessionKey.currentState?.clearAll();
    ExperienceKey.currentState?.clearAll();
    setState(() {
      selectedFilters["Profession"] = [];
      selectedFilters["Experience"] = [];
      _filteredResults = _filterResults(); // Clear filters and update results
    });
  }

  void updateSelectedFilters(String filterName, List<String> selectedItems) {
    setState(() {
      selectedFilters[filterName] = selectedItems;
      printSelectedFilters();
      _filteredResults = _filterResults(); // Update the filtered results
    });
  }

  void printSelectedFilters() {
    print("Selected Filters: $selectedFilters");
  }

  List<int> _expandExperienceRanges(List<String> ranges) {
    final List<int> expandedList = [];
    for (var range in ranges) {
      final parts = range.split('-').map(int.parse).toList();
      expandedList.addAll(List.generate(parts[1] - parts[0] + 1, (i) => parts[0] + i));
    }
    return expandedList;
  }

  List<Map<String, dynamic>> _filterResults() {
    final expandedExperience = _expandExperienceRanges(selectedFilters["Experience"] ?? []);
    return widget.Result.where((result) {
      final int resultExperience = int.tryParse(result['experience']) ?? 0;
      final bool professionMatches = selectedFilters["Profession"]!.isEmpty || selectedFilters["Profession"]!.contains(result['profession']);
      final bool experienceMatches = expandedExperience.isEmpty || expandedExperience.contains(resultExperience);
      return professionMatches && experienceMatches;
    }).toList();
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 20 * s.customHeight,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20 * s.customWidth),
            child: Container(
              height: 80,
              width: s.width,
              decoration: BoxDecoration(color: Color.fromRGBO(249, 249, 249, 1), border: Border.all(color: Color.fromARGB(42, 0, 0, 0)), borderRadius: BorderRadius.circular(10)),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  width: 1480,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20 * s.customWidth, right: 5 * s.customWidth),
                        child: FaIcon(Icons.search_outlined),
                      ),
                      Container(
                        width: s.width > 1000 ? null : 100,
                        child: AutoSizeText(
                          widget.experience,
                          style: GoogleFonts.poppins(fontSize: 16, color: black),
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
                          Icons.my_location_sharp,
                          color: red,
                        ),
                      ),
                      Container(
                        width: 200,
                        constraints: BoxConstraints(maxWidth: 250),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: AutoSizeText(
                            overflow: TextOverflow.ellipsis,
                            widget.location,
                            style: GoogleFonts.aBeeZee(fontSize: 16, color: black),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 40 * s.customWidth,
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
                      widget.experience == "Doctor" || widget.experience == "Nursing"
                          ? buildCustomDropdownForm(
                              hintText: 'Your Experience',
                              items: [
                                "1 Year",
                                "2 Year",
                                "3 Year",
                                "4 Year",
                                "5 Year",
                                "6 Year",
                                "7 Year",
                                "8 Year",
                                "9 Year",
                                "10 Year",
                                "11 Year",
                                "12 Year",
                                "13 Year",
                                "14 Year",
                                "15 Year",
                                "16 Year",
                                "17 Year",
                                "18 Year",
                                "19 Year",
                                "20 Year",
                                "21 Year",
                                "22 Year",
                                "23 Year",
                                "24 Year",
                                "25 Year"
                              ],
                              onChanged: (String? value) {
                                print("object..................................$value");
                              }).w(250)
                          : Container(),
                      widget.experience == "Nursing" || widget.experience == "Doctor"
                          ? SizedBox(
                              width: 40 * s.customWidth,
                            )
                          : Container(),
                      widget.experience == "Nursing" || widget.experience == "Doctor"
                          ? SizedBox(
                              height: 30 * s.customHeight,
                              child: VerticalDivider(
                                color: Colors.grey,
                                thickness: 2,
                              ),
                            )
                          : Container(),
                      widget.experience == "Nursing" || widget.experience == "Doctor"
                          ? SizedBox(
                              width: 40 * s.customWidth,
                            )
                          : Container(),
                      widget.experience == "Nursing" || widget.experience == "Doctor"
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "\₹${_values.start.round()}",
                                      style: GoogleFonts.poppins(fontSize: 15, color: black, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      " Doctor Fees",
                                      style: GoogleFonts.poppins(color: black, fontSize: 16, fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      "\₹${_values.end.round()}",
                                      style: GoogleFonts.poppins(fontSize: 15, color: black, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ).w(300),
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
                                ).wh(300, 20),
                              ],
                            )
                          : Container(),
                      10.widthBox,
                      Expanded(child: Container()),
                      _filteredResults.isEmpty
                          ? Container()
                          : Padding(
                              padding: EdgeInsets.only(right: 20 * s.customWidth),
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
                                  padding: EdgeInsets.only(right: 20 * s.customWidth, left: 20 * s.customWidth),
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
                      Padding(
                        padding: EdgeInsets.only(right: 20 * s.customWidth),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Result(
                                  experience: widget.experience,
                                  location: widget.location,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 42 * s.customHeight,
                            padding: EdgeInsets.only(right: 20 * s.customWidth, left: 20 * s.customWidth),
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
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50 * s.customHeight,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20 * s.customWidth),
              child: Row(
                children: [
                  widget.experience == "Doctor" || widget.experience == "Nurse"
                      ? Container(
                          width: s.width > 1000 ? 250 : 150,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Filters",
                                    style: GoogleFonts.aBeeZee(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: s.width < 1024
                                            ? s.width > 600
                                                ? 19
                                                : 16
                                            : 22),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      clearAllFilters();
                                    },
                                    child: Text(
                                      "Clear All",
                                      style: GoogleFonts.aBeeZee(
                                          color: grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: s.width < 1024
                                              ? s.width > 600
                                                  ? 10
                                                  : 8
                                              : 12),
                                    ).pOnly(top: 5),
                                  ),
                                ],
                              ),
                              15.heightBox,
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(10)),
                                    child: Column(
                                      children: [
                                        DropdownWidget(
                                          key: ProfessionKey,
                                          name: "Profession",
                                          items: [
                                            "Cardiologist",
                                            "Dermatologist",
                                            "Pediatricians",
                                            "Gynecologist",
                                            "Gastroenterologist",
                                            "Pathology",
                                          ],
                                          onSelectionChanged: (selectedItems) {
                                            updateSelectedFilters("Profession", selectedItems);
                                          },
                                        ),
                                        Divider(color: Colors.black).px16(),
                                        DropdownWidget(
                                          key: ExperienceKey,
                                          name: "Experience",
                                          items: [
                                            "1 - 5",
                                            "6 - 10",
                                            "11 - 15",
                                            "16 - 20",
                                            "21 - 25"
                                          ],
                                          onSelectionChanged: (selectedItems) {
                                            updateSelectedFilters("Experience", selectedItems);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              15.heightBox
                            ],
                          ),
                        ).pOnly(right: 20)
                      : SizedBox(),
                  Expanded(
                    child: Container(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                widget.experience,
                                style: GoogleFonts.aBeeZee(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                              10.widthBox,
                              Text(
                                "Search Result (${widget.Result.length})",
                                style: GoogleFonts.aBeeZee(color: grey, fontWeight: FontWeight.bold, fontSize: 17),
                              ).pOnly(bottom: 1),

                              // Expanded(
                              //   child: Container(
                              //     color: Colors.transparent,
                              //     width: double.infinity,
                              //   ),
                              // ),
                            ],
                          ),
                          15.heightBox,
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Container(
                                width: double.infinity,
                                child: LayoutBuilder(
                                  builder: (BuildContext context, BoxConstraints constraints) {
                                    int numberOfColumns = constraints.maxWidth > 1100 ? 5 : (constraints.maxWidth >= 800 && constraints.maxWidth <= 1100 ? 4 : 3);
                                    int numberOfRows = (_filteredResults.length / numberOfColumns).ceil(); //jobData.length  = at 10
                                    if (_isLoading) {
                                      return Container(
                                        height: 500 * s.customHeight,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.blue,
                                          ),
                                        ),
                                      );
                                    } else if (_filteredResults.isEmpty) {
                                      return Container(
                                        child: isFirstVisible ? firstCodeWidget(s: s) : secondCodeWidget(s: s),
                                      );
                                    } else {
                                      return Column(
                                        children: List.generate(numberOfRows, (index) {
                                          return Row(
                                            children: List.generate(numberOfColumns, (columnIndex) {
                                              int dataIndex = index * numberOfColumns + columnIndex;
                                              if (dataIndex < _filteredResults.length) {
                                                var resultData = _filteredResults[dataIndex];

                                                return Expanded(
                                                  child: CustomJobContainer(
                                                    containerColor: resultData['containerColor'] ?? '',
                                                    onDetailsTap: () {
                                                      Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                          builder: (context) => widget.experience == "Patient"
                                                              ? SubscriptionPlan()
                                                              : widget.experience == "Hospital"
                                                                  ? Hospital(
                                                                      id: resultData['id'],
                                                                      profession: widget.experience,
                                                                    )
                                                                  : Profile(
                                                                      city: resultData['address'],
                                                                      name: resultData['name'],
                                                                      specification: resultData['experience'],
                                                                      image: resultData['image'],
                                                                    ),
                                                        ),
                                                      );
                                                    },
                                                    jobTitle: resultData['name'], // resultData['jobTitle'] ?? '',
                                                    mobile: widget.experience == "Patient" ? mobile : resultData['phone'] ?? '',
                                                    address: resultData['address'] ?? '',
                                                    experience: widget.experience == "Doctor" || widget.experience == "Nursing" ? resultData['experience'] ?? '' : '',
                                                    imageUrl: resultData['image'] ?? '',
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
                        ],
                      ),
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

  Widget firstCodeWidget({required Screen s}) {
    return Container(
      height: 500 * s.customHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Find Your ${widget.experience}",
            style: GoogleFonts.montserrat(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20 * s.customHeight),
          InkWell(
            onTap: () {
              setState(() {
                isFirstVisible = false;
              });
            },
            child: Container(
              height: 42 * s.customHeight,
              width: 200 * s.customWidth,
              padding: EdgeInsets.only(right: 20, left: 20),
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
      padding: EdgeInsets.symmetric(horizontal: 150 * s.customWidth), // replace with 150 * s.customWidth if needed
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20 * s.customHeight,
            ),
            Center(
              child: Container(
                height: 55,
                width: 75,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 27, 181, 253),
                  border: Border.all(color: const Color.fromARGB(102, 0, 0, 0)),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  FontAwesomeIcons.userDoctor,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            SizedBox(
              height: 10 * s.customHeight,
            ),
            Center(
              child: Text(
                "We're here for you, So find your ${widget.experience}",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              height: 20 * s.customHeight,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Row(
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
                  ),
                  SizedBox(
                    height: 20 * s.customHeight,
                  ),
                  Row(
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
                              return 'Please enter your mobile no.';
                            } else if (value.length != 10) {
                              return 'Mobile no. must be 10 digits';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
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
              height: 20 * s.customHeight,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
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
    required String hintText,
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
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 15.0),
          // border: OutlineInputBorder(),
        ),
        // value: dropdownValue,
        items: items.map((String item) {
          return DropdownMenuItem(
            value: item,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                item,
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

class CustomJobContainer extends StatefulWidget {
  final VoidCallback onDetailsTap;
  final String jobTitle;
  final String mobile;
  final String address;
  final String experience;
  final Color containerColor;
  final String imageUrl;

  CustomJobContainer({
    required this.onDetailsTap,
    required this.jobTitle,
    required this.containerColor,
    required this.imageUrl,
    required this.mobile,
    required this.address,
    required this.experience,
  });

  @override
  State<CustomJobContainer> createState() => _CustomJobContainerState();
}

class _CustomJobContainerState extends State<CustomJobContainer> {
  bool isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Shadow color
            offset: Offset(4, 4), // Offset in x and y direction
            blurRadius: 4, // Blur radius
            spreadRadius: 1, // Spread radius
          ),
        ],
        color: widget.containerColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color.fromARGB(40, 0, 0, 0), width: 1),
      ),
      width: 300,
      height: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 1, // Spread radius
                      blurRadius: 0, // Blur radius
                      offset: Offset(3, 3), // Offset in x and y direction
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Image.network(
                      // "https://www.citizenshospitals.com/static/uploads/8df70ccd-80e6-493a-a835-ce6ff15f633c-1690833106912.jpg",
                      widget.imageUrl,
                      // 'assets/d3.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isBookmarked = !isBookmarked;
                  });
                },
                child: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border_outlined,
                  size: 30,
                ),
              ),
            ],
          ),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      5.heightBox,
                      Text(
                        widget.jobTitle,
                        style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        widget.mobile,
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        widget.address,
                        style: GoogleFonts.montserrat(
                          // color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      Text(
                        widget.experience,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      5.heightBox,
                    ],
                  ),
                ),
              ],
            ),
          ),
          10.heightBox,
          Row(
            children: [
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: widget.onDetailsTap,
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.transparent,
                        border: Border.all(),
                      ),
                      child: Center(
                        child: Text(
                          "Details",
                          style: GoogleFonts.montserrat(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
        ],
      ).p(15),
    );
  }
}

class DropdownWidget extends StatefulWidget {
  final String name;
  final List<String> items;
  final ValueChanged<List<String>> onSelectionChanged;

  DropdownWidget({required this.items, required this.name, required this.onSelectionChanged, Key? key}) : super(key: key);

  @override
  _DropdownWidgetState createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  bool _showDropdown = true;
  List<bool> isCheckedList = [];

  @override
  void initState() {
    super.initState();
    isCheckedList = List<bool>.filled(widget.items.length, false);
  }

  void clearAll() {
    setState(() {
      isCheckedList = List<bool>.filled(widget.items.length, false);
      widget.onSelectionChanged(_getSelectedItems());
    });
  }

  List<String> _getSelectedItems() {
    List<String> selectedItems = [];
    for (int i = 0; i < widget.items.length; i++) {
      if (isCheckedList[i]) {
        selectedItems.add(widget.items[i]);
      }
    }
    return selectedItems;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _showDropdown = !_showDropdown;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.name,
                style: GoogleFonts.montserrat(fontWeight: FontWeight.w600, fontSize: 16),
              ).pOnly(left: 5),
              Icon(
                _showDropdown ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                size: 30,
              ).pOnly(top: 5),
            ],
          ).p(12),
        ),
        Visibility(
          visible: _showDropdown,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: widget.items.asMap().entries.map((entry) {
                int index = entry.key;
                String item = entry.value;
                return InkWell(
                  onTap: () {
                    setState(() {
                      isCheckedList[index] = !isCheckedList[index];
                      widget.onSelectionChanged(_getSelectedItems());
                    });
                  },
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Transform.scale(
                      scale: 0.8,
                      child: Checkbox(
                        activeColor: Colors.yellow,
                        value: isCheckedList[index],
                        onChanged: (bool? value) {
                          setState(() {
                            isCheckedList[index] = value ?? false;
                            widget.onSelectionChanged(_getSelectedItems());
                          });
                        },
                      ),
                    ),
                    title: Text(item, style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w600)),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
