import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomJobContainer1 extends StatefulWidget {
  final String jobTitle;
  final String jobLocation;
  final String salaryText;
  final String imageUrl;

  CustomJobContainer1({
    required this.jobTitle,
    required this.jobLocation,
    required this.salaryText,
    required this.imageUrl,
  });

  @override
  State<CustomJobContainer1> createState() => _CustomJobContainer1State();
}

class _CustomJobContainer1State extends State<CustomJobContainer1> {
  bool isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.white, // Shadow color
          ),
        ],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      width: 270,
      height: 220,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey.shade200,
                child: ClipOval(
                    child: Image.asset(
                  fit: BoxFit.cover,
                  widget.imageUrl,
                )),
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
                      10.heightBox,
                      Text(
                        widget.jobTitle,
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      5.heightBox,
                      Expanded(
                        child: Text(
                          widget.jobLocation,
                          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade400, fontWeight: FontWeight.w500, height: 2),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ),
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
                    onTap: () {},
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(borderRadius: BorderRadius.horizontal(left: Radius.circular(50), right: Radius.circular(50)), color: Colors.transparent, border: Border.all()),
                      child: Center(
                        child: Text(
                          widget.salaryText,
                          style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 13),
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

class CustomButton1 extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const CustomButton1({Key? key, required this.text, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 150,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(50),
            right: Radius.circular(50),
          ),
          color: Colors.white,
          border: Border.all(color: Colors.black),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(width: 5),
            Icon(
              Icons.search,
              size: 18.0,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
