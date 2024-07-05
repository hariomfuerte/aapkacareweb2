import 'package:aapkacare/screens/appointment/appointment_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class appointment extends StatefulWidget {
  
  final uId;
  const appointment({super.key, this.uId});

  @override
  State<appointment> createState() => _appointmentState();
}

class _appointmentState extends State<appointment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        backgroundColor: Colors.blue,
        title: Text("Appointments",style: TextStyle(color: Colors.white),),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width*.7,
          child: StreamBuilder(

            stream: FirebaseFirestore.instance
                .collection('AllHospital')
                .doc(widget.uId).collection("Doctors")
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              var doctors = snapshot.data!.docs; // Accessing the first document's data
              return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: doctors.length,
              itemBuilder: (context, index) {
              var hospital = doctors[index].data();

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width*.7,

                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade200)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(   crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image(image:
                              AssetImage(
                                "assets/download.jpeg",
                              ),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      hospital['name'],
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.star, color: Colors.orange),
                                        Text(
                                          "4.5",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Text('  (55 Rating)'),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.school_outlined),
                                        Text(" ${hospital['qualification']}"),
                                      ],
                                    ),
                                    Text("Experience: ${hospital['experience']} year"),
                                    Text("Speciality: ${hospital['speciality']}"),
                                    Text('21 people recently enquired'),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)
                                    ),
                                    backgroundColor: Colors.blue),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AppointmentScreen(),));
                                },
                                child: Row(children: [
                                  Text('Book Appointment',style: TextStyle(
                                      color: Colors.white,fontWeight: FontWeight.w400
                                  ),),
                                ],),
                              ),

                            ],
                          ),
                          SizedBox(height: 16),


                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
              );}
          ),
        ),
      ),
    );
  }
}
