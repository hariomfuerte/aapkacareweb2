import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:aapkacare/values/screen.dart';

class HospitalMobile extends StatefulWidget {
  final List<Map<String, dynamic>> Details;
  const HospitalMobile({super.key, required this.Details});

  @override
  State<HospitalMobile> createState() => _HospitalMobileState();
}

class _HospitalMobileState extends State<HospitalMobile> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  final double maxSlide = 225.0;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 250));
  }

  void toggle() => animationController.isDismissed ? animationController.forward() : animationController.reverse();

  startLaunchURL(String url) async {
    // const url = 'https://flutter.dev';

    var urllaunchable = await canLaunchUrl(Uri.parse(url)); //canLaunch is from url_launcher package
    if (urllaunchable) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication); //launch is from url_launcher package to launch URL
    } else {
      print("URL can't be launched.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        // onTap: toggle,
        child: AnimatedBuilder(
          animation: animationController,
          builder: (context, _) {
            // double slide = maxSlide * animationController.value;
            double scale = 1 - (animationController.value * 0.28);
            return Stack(
              children: <Widget>[
                GestureDetector(
                  onTap: toggle,
                  child: BackWidget(),
                ),
                Transform(
                  transform: Matrix4.identity()
                    // ..translate(slide)
                    ..scale(scale),
                  alignment: Alignment.bottomCenter,
                  child: FrontWidget(
                    toggle: toggle,
                    ListData: widget.Details,
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

class BackWidget extends StatefulWidget {
  @override
  _BackWidgetState createState() => _BackWidgetState();
}

class _BackWidgetState extends State<BackWidget> {
  List<String> sliderImages = [
    'assets/s1.jpeg',
    'assets/s2.jpeg',
    'assets/s3.jpeg',
    'assets/s4.jpeg',
    'assets/s5.jpeg',
    'assets/s6.jpeg',
  ];

  @override
  Widget build(BuildContext context) {
    Screen s = Screen(context);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 27, 181, 253),
      body: CarouselSlider(
        items: sliderImages.map((imagePath) {
          return Container(
            width: s.width / 1.3,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
            child: Image.asset(
              imagePath,
              fit: BoxFit.fill,
            ),
          );
        }).toList(),
        options: CarouselOptions(
          height: 200 * s.customHeight, // Adjust height as needed
          enableInfiniteScroll: true, // Allows infinite scrolling
          autoPlay: true, // Automatically scroll items
          autoPlayInterval: Duration(seconds: 3), // Set auto-play interval
          autoPlayAnimationDuration: Duration(milliseconds: 800), // Animation duration
          autoPlayCurve: Curves.fastOutSlowIn, // Animation curve
          // enlargeCenterPage: true, // Enlarge the centered item
          scrollDirection: Axis.horizontal, // Set scroll direction
        ),
      ).pOnly(top: 10),
    );
  }
}

class FrontWidget extends StatefulWidget {
  final Function toggle;
  final List<Map<String, dynamic>> ListData;

  const FrontWidget({super.key, required this.toggle, required this.ListData});
  @override
  _FrontWidgetState createState() => _FrontWidgetState();
}

class _FrontWidgetState extends State<FrontWidget> {
  @override
  Widget build(BuildContext context) {
    Screen s = Screen(context);
    return Scaffold(
      // backgroundColor: Color.fromRGBO(0, 162, 239, 1),
      body: Container(
        width: s.width,
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  width: double.infinity,
                  height: s.width > 700 ? 500 * s.customWidth : 250,
                  // color: Colors.black,
                  child: Image.asset(
                    "assets/Civil.png",
                    fit: BoxFit.fill,
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.grey.shade300,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10 * s.customHeight,
                          ),

                          //  Detailed Container
                          Container(
                            height: 140,
                            padding: EdgeInsets.only(left: 10, top: 10),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(spreadRadius: 2, blurRadius: 5, color: Colors.grey.shade400)
                              ],
                              border: Border.all(
                                color: Colors.grey.shade400,
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      children: [
                                        DoctorDetailed(
                                          colors: Color(0xFF43A047),
                                          icon: Icons.location_searching_rounded,
                                          text: widget.ListData[0]['address'],
                                        ),
                                        SizedBox(
                                          height: 10 * s.customHeight,
                                        ),
                                        DoctorDetailed(
                                          colors: Colors.blue.shade500,
                                          icon: Icons.work_history_outlined,
                                          text: '24/7 Service',
                                        ),
                                        SizedBox(
                                          height: 10 * s.customHeight,
                                        ),
                                        DoctorDetailed(
                                          colors: Colors.black,
                                          icon: Icons.business,
                                          text: '10 Years in Healthcare',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      children: [
                                        InkWell(
                                          hoverColor: Colors.transparent,
                                          onTap: () {
                                            // String phoneNumber =
                                            //     data['phone'];
                                            // String url =
                                            //     'tel:$phoneNumber';
                                            // launchUrlString(url);
                                          },
                                          child: DoctorDetailed(
                                            colors: Colors.green.shade700,
                                            icon: Icons.phone,
                                            text: widget.ListData[0]['mobile'],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10 * s.customHeight,
                                        ),
                                        DoctorDetailed(
                                          colors: Colors.red.shade400,
                                          icon: Icons.mail_outline,
                                          text: 'civil@gmail.com',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ).pSymmetric(h: 20),

                          SizedBox(
                            height: 10 * s.customHeight,
                          ),

                          // 3 Detailed Container
                          Container(
                            height: 250 * s.customHeight,
                            padding: EdgeInsets.only(left: 10, top: 10),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(spreadRadius: 2, blurRadius: 5, color: Colors.grey.shade400)
                              ],
                              border: Border.all(
                                color: Colors.grey.shade400,
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 40,
                                    width: double.infinity,
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      "Hospital Department",
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Wrap(
                                        alignment: WrapAlignment.center,
                                        spacing: 30,
                                        runSpacing: 10,
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          DoctorDetailed(
                                            text: "Outpatient department (OPD)",
                                          ),
                                          DoctorDetailed(
                                            text: "Physical medicine",
                                          ),
                                          DoctorDetailed(
                                            text: "Surgical department",
                                          ),
                                          DoctorDetailed(
                                            text: "Nursing department",
                                          ),
                                          DoctorDetailed(
                                            text: "Inpatient service (IP)",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20 * s.customHeight,
                                  ),
                                ],
                              ),
                            ),
                          ).pSymmetric(h: 20),

                          SizedBox(
                            height: 20 * s.customHeight,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // photo
            Positioned(
              top: s.width > 700 ? 0 : 100,
              child: Container(
                width: s.width,
                height: s.width > 700 ? 500 * s.customWidth : 150,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color.fromARGB(203, 0, 0, 0),
                    Color.fromARGB(203, 0, 0, 0),
                    Color.fromARGB(134, 0, 0, 0),
                    Colors.transparent,
                  ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.ListData[0]['name'],
                            style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
                          ),
                          Text(
                            "Government Hospital",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ).pOnly(left: 20, bottom: 20),
                    ),
                    Expanded(
                      child: Container(
                        // color: Colors.amber,
                        height: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              FontAwesomeIcons.facebookF,
                              color: Colors.blue.shade800,
                            ),
                            20.widthBox,
                            Icon(
                              FontAwesomeIcons.squareInstagram,
                              color: Colors.pink.shade400,
                            ),
                            20.widthBox,
                            Icon(
                              FontAwesomeIcons.linkedinIn,
                              color: Colors.blue.shade900,
                            ),
                            20.widthBox,
                            Icon(
                              FontAwesomeIcons.twitter,
                              color: Colors.blue.shade400,
                            ),
                            20.widthBox,
                          ],
                        ).pOnly(bottom: 25),
                      ),
                    )
                  ],
                ),
              ),
            ),

            Positioned(
              child: GestureDetector(
                onTap: () => widget.toggle(),
                child: Container(
                  width: s.width,
                  height: s.width > 700 ? 280 : 200,
                  decoration: BoxDecoration(
                      gradient: RadialGradient(
                    colors: [
                      Color.fromARGB(13, 0, 0, 0),
                      Color.fromARGB(23, 0, 0, 0),
                    ],
                  )
                      // color: Color.fromARGB(43, 0, 0, 0),
                      ),
                  child: Center(
                      child: Icon(
                    Icons.add_photo_alternate_sharp,
                    color: Colors.white,
                    size: 40,
                  )),
                ),
              ),
            )
          ],
        ),
      ),
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
      text,
      style: GoogleFonts.montserrat(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 15),
    );
  }
}

class DoctorDetailed extends StatelessWidget {
  final Color? colors;
  final IconData? icon;
  final String text;

  const DoctorDetailed({
    Key? key,
    this.colors,
    this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      // color: Colors.amber,
      child: icon == null
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(50)),
              child: Text(
                text,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : Row(
              children: [
                if (icon != null)
                  Icon(
                    icon,
                    color: colors ?? Colors.black,
                    size: 18,
                  ),
                if (icon != null) SizedBox(width: 15),
                Expanded(
                  child: Text(
                    text,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
