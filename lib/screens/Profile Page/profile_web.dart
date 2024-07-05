import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:aapkacare/values/screen.dart';
import 'package:aapkacare/values/values.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:velocity_x/velocity_x.dart';

class DoctorWeb extends StatefulWidget {
  final String specification;
  final String city;
  final String name;
  final String image;
  const DoctorWeb({super.key, required this.specification, required this.city, required this.name, required this.image});

  @override
  State<DoctorWeb> createState() => _DoctorWebState();
}

class _DoctorWebState extends State<DoctorWeb> {
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  List<String> specialityList = [];
  bool isLoading = true;

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
                SizedBox(
                  width: 20 * s.customWidth,
                ),
                Text(
                  "AAPKA CARE",
                  style: GoogleFonts.play(color: Colors.white, fontWeight: FontWeight.bold),
                ),
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
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Row

              Container(
                padding: EdgeInsets.only(left: 10, top: 10),
                child: Column(
                  children: [
                    Container(
                      height: s.width > 1024 ? MediaQuery.of(context).size.height / 2 : MediaQuery.of(context).size.height / 4,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                        Color.fromRGBO(27, 181, 253, 1),
                        Color.fromRGBO(58, 193, 255, 1),
                        Color.fromRGBO(106, 208, 255, 1),
                        Color.fromRGBO(187, 233, 255, 1),
                      ])),
                      child: Image.network(widget.image, fit: BoxFit.cover),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          FontAwesomeIcons.twitter,
                          size: 20,
                        ),
                        10.widthBox,
                        Icon(
                          FontAwesomeIcons.facebook,
                          size: 20,
                        ),
                        10.widthBox,
                        Icon(
                          FontAwesomeIcons.linkedin,
                          size: 20,
                        ),
                        10.widthBox,
                        Icon(
                          FontAwesomeIcons.instagram,
                          size: 20,
                        ),
                      ],
                    ).pOnly(left: 10, top: 10),
                  ],
                ),
                width: MediaQuery.of(context).size.width / 4.2,
              ),

              // Detailed Container
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 10, right: 10),
                  child: Column(
                    children: [
                      // First name Row
                      Container(
                        height: 120,
                        color: Color.fromRGBO(0, 4, 59, 1),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(top: 15, left: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customText(
                                      text: widget.name,
                                    ),
                                    8.heightBox,
                                    subText(
                                      text: 'specification',
                                    ),
                                    2.heightBox,
                                    subText(
                                      text: 'education',
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Appointment button
                            InkWell(
                              onTap: () {
                                _launchURL('https://play.google.com/store/apps/details?id=com.fuertedevelopers.aapkacare&hl=en');
                              },
                              child: Container(
                                height: 35,
                                width: 200,
                                child: Center(
                                  child: Text(
                                    "Request Appointment",
                                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.white),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(50),
                                      right: Radius.circular(50),
                                    ),
                                    color: Color.fromRGBO(5, 66, 191, 1)),
                              ),
                            ),
                          ],
                        ).px12(),
                      ),

                      // Detail Container
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              20.heightBox,
                              // Share Row or Path Location
                              Row(
                                children: [
                                  locationText(
                                    text: "Home",
                                  ),
                                  5.widthBox,
                                  Text(">>"),
                                  5.widthBox,
                                  locationText(
                                    text: 'specification',
                                  ),
                                  5.widthBox,
                                  Text(">>"),
                                  5.widthBox,
                                  locationText(
                                    text: widget.name,
                                  ),
                                  Spacer(),
                                ],
                              ),

                              40.heightBox,
                              // Opd heading
                              Row(
                                children: [
                                  Text(
                                    "Private OPD",
                                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.blue.shade900, fontWeight: FontWeight.w600),
                                  ),
                                  20.widthBox,
                                  Text(
                                    "General OPD",
                                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.blue.shade900, fontWeight: FontWeight.w600),
                                  ),
                                  Spacer(),
                                  locationText(text: "Share:"),
                                  10.widthBox,
                                  customIcon(
                                    icon: Icon(
                                      FontAwesomeIcons.whatsapp,
                                      size: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                  5.widthBox,
                                  customIcon(
                                    icon: Icon(
                                      FontAwesomeIcons.facebook,
                                      size: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                  5.widthBox,
                                  customIcon(
                                    icon: Icon(
                                      Icons.mail_outline,
                                      size: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                  5.widthBox,
                                  customIcon(
                                    icon: Icon(
                                      FontAwesomeIcons.linkedinIn,
                                      size: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              10.heightBox,

                              Divider(
                                color: Colors.grey.shade400,
                              ),
                              20.heightBox,

                              // Detail Container
                              Container(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                height: 210,
                                child: Row(
                                  children: [
                                    // 1 Container Of Doctor Detail
                                    Expanded(
                                      child: Container(
                                        child: Column(
                                          children: [
                                            DoctorDetailed(
                                              icon: Icons.calendar_today_outlined,
                                              text: 'day',
                                            ),
                                            10.heightBox,
                                            DoctorDetailed(icon: Icons.access_time_outlined, text: 'time'),
                                            10.heightBox,
                                            DoctorDetailed(
                                              icon: Icons.work_history_outlined,
                                              text: widget.specification,
                                            ),
                                            10.heightBox,
                                            DoctorDetailed(
                                              icon: Icons.language_outlined,
                                              text: 'language',
                                            ),
                                            10.heightBox,
                                            DoctorDetailed(
                                              icon: FontAwesomeIcons.moneyBill,
                                              text: 'fee',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // 2 Container Of Doctor Detail
                                    Expanded(
                                      child: Container(
                                        child: Column(
                                          children: [
                                            DoctorDetailed(icon: FontAwesomeIcons.building, text: 'hospital'),
                                            10.heightBox,
                                            InkWell(
                                              hoverColor: Colors.transparent,
                                              onTap: () {
                                                String phoneNumber = 'phone';
                                                String url = 'tel:$phoneNumber';
                                                launchUrlString(url);
                                              },
                                              child: DoctorDetailed(
                                                icon: Icons.phone,
                                                text: 'phone',
                                              ),
                                            ),
                                            10.heightBox,
                                            DoctorDetailed(
                                              icon: Icons.mail_outline,
                                              text: 'email',
                                            ),
                                            10.heightBox,
                                          ],
                                        ),
                                      ),
                                    ),

                                    // 3 Container Of Doctor Detail

                                    s.width > 1024
                                        ? Expanded(
                                            child: Container(),
                                          )
                                        : Container()
                                  ],
                                ),
                              ),

                              15.heightBox,

                              //Biography
                              Container(
                                padding: EdgeInsets.only(right: 20),
                                // height: 140,
                                // color: Colors.amber,
                                child: Column(
                                  children: [
                                    // Biography Heading
                                    Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                        "Biography",
                                        style: GoogleFonts.poppins(fontSize: 22, color: Colors.black45, fontWeight: FontWeight.w600),
                                      ),
                                    ),

                                    // Biography Description
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                        textAlign: TextAlign.justify,
                                        'Biography',
                                        style: GoogleFonts.poppins(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w500),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

class DoctorDetailed extends StatelessWidget {
  final IconData icon;
  final String text;
  const DoctorDetailed({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
          ),
          10.widthBox,
          Expanded(
            child: Text(
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              text,
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }
}

class customIcon extends StatelessWidget {
  final Icon icon;
  const customIcon({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: 35,
      decoration: BoxDecoration(color: Colors.grey.shade300, shape: BoxShape.circle),
      child: icon,
    );
  }
}

class customText extends StatelessWidget {
  final String text;
  const customText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      overflow: TextOverflow.ellipsis,
      maxLines: 3,
      text,
      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
    );
  }
}

class subText extends StatelessWidget {
  final String text;
  const subText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w400),
    );
  }
}

class locationText extends StatelessWidget {
  final String text;
  const locationText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
    );
  }
}
