import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../appointment/appointment.dart';

class HospitalDetails extends StatefulWidget {
  final String hospitalName;

  const HospitalDetails({super.key, required this.hospitalName});

  @override
  State<HospitalDetails> createState() => _HospitalDetailsState();
}

class _HospitalDetailsState extends State<HospitalDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        backgroundColor: Colors.blue,
        title: Text('Hospital Details',style: TextStyle(color: Colors.white)),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: MediaQuery.of(context).size.width*.7,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('AllHospital')
                .where('name', isEqualTo: widget.hospitalName)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              var hospital = snapshot.data!.docs.first.data(); // Accessing the first document's data

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
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
                               "assets/s4.jpeg",
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
                                        Icon(Icons.location_on),
                                        Flexible(child: Text(hospital['address'],overflow: TextOverflow.ellipsis)),
                                      ],
                                    ),
                                    Text("  Health Care Package"),
                                    SizedBox(height: 16),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {

                                          },

                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5)
                                            ),
                                          ),
                                          child: Row(children: [
                                           Icon(Icons.phone,color: Colors.white,),
                                            Text(" 9123456789",style: TextStyle(
                                                color: Colors.white,fontWeight: FontWeight.w400
                                            )),
                                          ],),

                                        ),
                                        SizedBox(width: 8),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5)
                                              ),
                                              backgroundColor: Colors.blue),
                                          onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => appointment(uId: hospital['uId']),));
                                          },
                                          child: Row(children: [
                                           Text('Book Appointment',style: TextStyle(
                                             color: Colors.white,fontWeight: FontWeight.w400
                                           ),),
                                          ],),
                                        ),
                                        SizedBox(width: 8),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5)
                                            ),
                                          ),
                                          onPressed: () {},
                                          child: Row(children: [
                                             FaIcon(FontAwesomeIcons.whatsapp,color: Colors.green,),
                                             Text('  Chat',style: TextStyle(

                                                 color: Colors.black,fontWeight: FontWeight.w400
                                             )),
                                          ],),

                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    Text('21 people recently enquired'),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.favorite_border),
                                onPressed: () {},
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
          ),
        ),
      ),
    );
  }
}
