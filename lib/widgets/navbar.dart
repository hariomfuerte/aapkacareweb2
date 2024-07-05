import 'package:aapkacare/screens/Home%20Page/Home.dart';
import 'package:aapkacare/screens/Hospital/hospital_Search.dart';
import 'package:aapkacare/values/screen.dart';
import 'package:aapkacare/values/values.dart';
import 'package:aapkacare/widgets/imageLink.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_size_text/auto_size_text.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  startLaunchURL(String url) async {
    var urllaunchable = await canLaunchUrl(Uri.parse(url));
    if (urllaunchable) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication); //launch is from url_launcher package to launch URL
    } else {
      print("URL can't be launched.");
    }
  }

  @override
  Widget build(BuildContext context) {
    Screen s = Screen(context);
    final textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
          // color: Color(0xfff8f8f8),
          color: Color.fromARGB(255, 27, 181, 253)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20 * s.customWidth),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                      );
                    },
                    child: const Logo()),
              ],
            ),
            if (s.isDesktop) _buildItems(textTheme, context),
            if (s.isDesktop)
              Flexible(
                  child: GestureDetector(
                      onTap: () {
                        startLaunchURL("https://play.google.com/store/apps/details?id=com.fuertedevelopers.aapkacare&hl=en_IN&gl=US");
                      },
                      child: ImageLinks())),
          ],
        ),
      ),
    );
  }

  Row _buildItems(TextTheme textTheme, BuildContext context) {
    Screen s = Screen(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
            onTap: () {
              startLaunchURL("https://play.google.com/store/apps/details?id=com.fuertedevelopers.aapkacare&hl=en&gl=US");
            },
            child: AutoSizeText(
              'Doctor',
              style: textTheme.bodyLarge!.apply(color: Colors.white),
            )),
        SizedBox(width: 30.0 * s.customWidth),
        GestureDetector(
            onTap: () {
              startLaunchURL("https://play.google.com/store/apps/details?id=com.fuertedevelopers.aapkacare&hl=en&gl=US");
            },
            child: AutoSizeText(
              'Nursing',
              style: textTheme.bodyLarge!.apply(color: Colors.white),
              // style: TextStyle(color: Colors.white),
            )),
        SizedBox(width: 30.0 * s.customWidth),
        InkWell(
            onTap: () {
           Navigator.push(context, MaterialPageRoute(builder: (context) => HospitalSearch(),));
            },
            child: AutoSizeText(
              'Hospital',
              style: textTheme.bodyLarge!.apply(color: Colors.white),
            )),
        SizedBox(width: 30.0 * s.customWidth),
        GestureDetector(
            onTap: () {
              startLaunchURL("https://play.google.com/store/apps/details?id=com.fuertedevelopers.aapkacare&hl=en&gl=US");
            },
            child: Text(
              'Patient',
              style: textTheme.bodyLarge!.apply(color: Colors.white),
            )),
        SizedBox(width: 30.0 * s.customWidth),
        GestureDetector(
            onTap: () {
              startLaunchURL("https://play.google.com/store/apps/details?id=com.fuertedevelopers.aapkacare&hl=en&gl=US");
            },
            child: AutoSizeText(
              'Login',
              style: textTheme.bodyLarge!.apply(color: Colors.white),
            )),
        SizedBox(width: 30.0 * s.customWidth),
      ],
    );
  }
}

class Logo extends StatelessWidget {
  const Logo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          // color: Colors.black,
          child: Image.asset(
            ImagePath.adsLogo,
            // color: Colors.black,
          ),
        ),
      ],
    );
  }
}
