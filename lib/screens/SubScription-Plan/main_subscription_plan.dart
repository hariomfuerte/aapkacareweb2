import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

Widget buildSegment(String text, bool isSelected) => Container(
      padding: EdgeInsets.all(4),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isSelected ? Colors.black : Colors.grey,
        ),
      ),
    );

class mainHeading extends StatelessWidget {
  final String text;

  const mainHeading({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
    );
  }
}

class subHeading extends StatelessWidget {
  final String text;
  const subHeading({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(fontSize: 10, color: Color.fromARGB(229, 117, 117, 117), fontWeight: FontWeight.w400),
      overflow: TextOverflow.ellipsis,
    );
  }
}

class mediumHeading extends StatelessWidget {
  final String text;
  const mediumHeading({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w400),
    );
  }
}

class doneLine extends StatelessWidget {
  final String text;
  const doneLine({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.check_circle_outlined,
          size: 16,
          color: Colors.green,
        ),
        10.widthBox,
        Text(
          text,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w400),
        )
      ],
    ).px24();
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Icon icon;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.obscureText = false,
    required this.icon,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        prefixIcon: icon,
        floatingLabelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        hintText: hintText,
        labelStyle: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black), // Change border color here
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black), // Change border color here
        ),
        errorStyle: TextStyle(color: Colors.red),
      ),
      style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 15),
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      // inputFormatters: <TextInputFormatter>[
      //   FilteringTextInputFormatter.digitsOnly,
      // ],
    );
  }
}
