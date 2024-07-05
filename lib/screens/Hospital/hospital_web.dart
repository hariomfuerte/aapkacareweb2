import 'package:aapkacare/values/screen.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:google_fonts/google_fonts.dart';

class HospitalWeb extends StatefulWidget {
  final List<Map<String, dynamic>> Details;
  const HospitalWeb({super.key, required this.Details});

  @override
  State<HospitalWeb> createState() => _HospitalWebState();
}

class _HospitalWebState extends State<HospitalWeb> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  final double maxSlide = 225.0;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 250));
  }

  void toggle() => animationController.isDismissed ? animationController.forward() : animationController.reverse();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        // onTap: toggle,
        child: AnimatedBuilder(
          animation: animationController,
          builder: (context, _) {
            // double slide = maxSlide * animationController.value;
            double scale = 1 - (animationController.value * 0.40);
            return Stack(
              children: <Widget>[
                GestureDetector(onTap: toggle, child: BackWidget()),
                Transform(
                  transform: Matrix4.identity()
                    // ..translate(slide)
                    ..scale(scale),
                  alignment: Alignment.bottomCenter,
                  child: FrontWidget(
                    function: toggle,
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
      backgroundColor: Colors.white,
      body: CarouselSlider(
        items: sliderImages.map((imagePath) {
          return Container(
            width: s.width / 1.5,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade500)),
            child: Image.asset(
              imagePath,
              fit: BoxFit.fill,
            ),
          );
        }).toList(),
        options: CarouselOptions(
          height: 300 * s.customHeight, // Adjust height as needed
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
  final List<Map<String, dynamic>> ListData;
  final Function function;

  const FrontWidget({super.key, required this.function, required this.ListData});

  @override
  _FrontWidgetState createState() => _FrontWidgetState();
}

class _FrontWidgetState extends State<FrontWidget> {
  @override
  Widget build(BuildContext context) {
    Screen s = Screen(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Container(
              // margin: EdgeInsets.all(20),
              width: double.infinity,
              height: s.height / 1.18,
              // decoration: BoxDecoration(
              //     border: Border.all(color: Colors.grey.shade500),
              //     borderRadius: BorderRadius.circular(10),
              //     boxShadow: [
              //       BoxShadow(offset: Offset(2, 2), spreadRadius: 2, blurRadius: 5, color: Colors.grey.shade400)
              //     ],
              //     color: Colors.white),
              child: Stack(
                children: [
                  Container(
                    width: s.width,
                    height: 300,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            "assets/b2.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            color: Colors.grey.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: s.width / 1.05,
                      height: 400,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(offset: Offset(0, 2), spreadRadius: 2, blurRadius: 5, color: Colors.grey.shade400)
                        ],
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 100 * s.customHeight,
                                ),
                                Text(
                                  widget.ListData[0]['name'],
                                  style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.location_on_rounded),
                                    SizedBox(
                                      width: 10 * s.customWidth,
                                    ),
                                    Text(
                                      widget.ListData[0]['address'],
                                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.timer),
                                    SizedBox(
                                      width: 10 * s.customWidth,
                                    ),
                                    Text(
                                      "24/7 Service",
                                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.mail),
                                    SizedBox(
                                      width: 10 * s.customWidth,
                                    ),
                                    Text(
                                      "civil@gmail.com",
                                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.call),
                                    SizedBox(
                                      width: 10 * s.customWidth,
                                    ),
                                    Text(
                                      widget.ListData[0]['mobile'],
                                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.business),
                                    SizedBox(
                                      width: 10 * s.customWidth,
                                    ),
                                    Text(
                                      "5 Years in Healthcare",
                                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10 * s.customHeight,
                                ),
                              ],
                            ).pOnly(left: 50),
                          ),
                          Expanded(
                            child: Container(
                              color: Colors.transparent,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    height: 50 * s.customHeight,
                                  ),
                                  Text(
                                    "Hospital Department",
                                    style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 50 * s.customHeight,
                                  ),
                                  Text(
                                    "Outpatient department (OPD)",
                                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 20 * s.customHeight,
                                  ),
                                  Text(
                                    "Inpatient service (IP)",
                                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 20 * s.customHeight,
                                  ),
                                  Text(
                                    "Nursing department",
                                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 20 * s.customHeight,
                                  ),
                                  Text(
                                    "Surgical department",
                                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 20 * s.customHeight,
                                  ),
                                  Text(
                                    "Physical medicine",
                                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 20 * s.customHeight,
                                  ),
                                  SizedBox(
                                    height: 50 * s.customHeight,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () => widget.function(),
                                    child: Container(
                                      color: Colors.yellow,
                                      width: 200,
                                      height: 200,
                                      child: Stack(
                                        children: [
                                          Positioned.fill(
                                            child: Image.asset(
                                              "assets/b3.png",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned.fill(
                                            child: Transform.rotate(
                                              angle: 0.1,
                                              child: Image.asset(
                                                "assets/b1.png",
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Positioned.fill(
                                            child: Transform.rotate(
                                              angle: 0.2,
                                              child: Image.asset(
                                                "assets/b2.png",
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            color: Colors.black.withOpacity(0.2),
                                          ),
                                          Transform.rotate(
                                            angle: 0.1,
                                            child: Container(
                                              color: Colors.black.withOpacity(0.2),
                                            ),
                                          ),
                                          Transform.rotate(
                                            angle: 0.2,
                                            child: Container(
                                              color: Colors.black.withOpacity(0.2),
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.image,
                                                color: Colors.white,
                                                size: 60,
                                              ),
                                              Center(
                                                child: Text(
                                                  "Images",
                                                  style: GoogleFonts.poppins(color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40 * s.customHeight,
                                  ),
                                  InkWell(
                                    onTap: () => widget.function(),
                                    child: Text(
                                      "Hospital Images",
                                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.blue),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ).pOnly(left: 30),
                  ),
                  Positioned(
                    top: 100,
                    left: 80,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Color.fromRGBO(187, 233, 255, 1),
                          Color.fromRGBO(27, 181, 253, 1),
                          Color.fromRGBO(58, 193, 255, 1),
                          Color.fromRGBO(106, 208, 255, 1),
                        ], begin: Alignment.topLeft),
                      ),
                      child: Image.network(
                        "assets/Civil.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
