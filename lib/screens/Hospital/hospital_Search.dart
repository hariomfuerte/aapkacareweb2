
import 'package:aapkacare/screens/Hospital/hospitalDetails.dart';
import 'package:aapkacare/values/values.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class HospitalSearch extends StatefulWidget {
  const HospitalSearch({super.key});

  @override
  State<HospitalSearch> createState() => _HospitalSearchState();
}

class _HospitalSearchState extends State<HospitalSearch> {
  TextEditingController locationController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  Map<String, List<String>> cityDetails = {

    "Delhi": ["AIIMS", "Fortis", "Apollo", "Max Healthcare", "BLK Super Speciality", "Sir Ganga Ram", "Artemis", "Medanta", "Moolchand", "Jaypee"],
    "Mumbai": ["Breach Candy", "Lilavati", "Nanavati", "Kokilaben", "Bombay", "Hiranandani", "Saifee", "Tata Memorial", "Jaslok", "Wockhardt"],
    "Bangalore": ["Manipal", "Fortis", "Columbia Asia", "Apollo", "Aster", "Narayana", "Ramaiah", "Sakra", "St. John's", "Vydehi"],
    "Hyderabad": ["Apollo", "Yashoda", "KIMS", "Care", "Sunshine", "Continental", "MaxCure", "AIG", "Global", "Usha Mullapudi"],
    "Chennai": ["Apollo", "Fortis Malar", "MIOT", "Sankara Nethralaya", "SIMS", "SRM", "Gleneagles Global", "Vijaya", "Kauvery", "Billroth"],
    "Kolkata": ["Apollo Gleneagles", "AMRI", "Fortis", "Medica", "Peerless", "Ruby", "Belle Vue", "Desun", "CMRI", "Woodlands"],
    "Pune": ["Ruby Hall", "Sahyadri", "Jehangir", "Deenanath", "Aditya Birla", "Noble", "Columbia Asia", "Jupiter", "Inamdar", "Sancheti"],
    "Ahmedabad": ["Apollo", "Sterling", "HCG", "CIMS", "Zydus", "Shalby", "SAL", "Narayana", "Civil", "Rajasthan"]
  };
  List<MapEntry<String, String>> filteredCityDetails = [];
  List<String> filteredDetails = [];
  bool showdata=false;
  bool showcity=false;
  void _filterCityNames(String query) {
    setState(() {
      filteredCityDetails = cityDetails.entries
          .where((entry) =>
          entry.key.toLowerCase().contains(query.toLowerCase()))
          .map((entry) => MapEntry(entry.key, ""))
          .toList();
    });
  }

  void _selectCityName(String cityName) async {
    setState(() {
      locationController.text = cityName;
      filteredCityDetails = [];
      searchController.text = ""; // Clear search field when city changes
    });

    print(cityName);

    try {
      // Fetch hospital details from Firestore
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('AllHospital')
          .where('city', isEqualTo: cityName)
          .get();
      print(snapshot.docs);
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          filteredDetails = snapshot.docs.map((doc) => doc.get('name').toString()).toList();
        });
      } else {
        setState(() {
          filteredDetails = [];
        });
      }

      // This will show the actual documents fetched
      print(filteredDetails);
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        filteredDetails = [];
      });
    }
  }



  void _filterDetails(String query) {
    setState(() {
      filteredDetails = cityDetails[locationController.text]!
          .where((detail) => detail.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }
  void _selectDetail(String detail) {
    setState(() {
      searchController.text = detail;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final deviceWidth = MediaQuery.of(context).size.width;
    final cardWidth = isTablet ? deviceWidth * 0.55 : deviceWidth * 0.9;

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Wrap(
          children: [
            Text(
              "AapKa Care",
              style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 30),
            isTablet?
            TextButton(
              onPressed: () {},
              child: Text('Find Doctors', style: TextStyle(color: Colors.black, fontSize: 17)),
            ):Container(),
            isTablet?   TextButton(
              onPressed: () {},
              child: Text('Video Consult', style: TextStyle(color: Colors.black, fontSize: 17)),
            ):Container(),
            isTablet?  TextButton(
              onPressed: () {},
              child: Text('Surgeries', style: TextStyle(color: Colors.black, fontSize: 17)),
            ):Container(),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              borderRadius: BorderRadius.circular(5),
             hoverColor: Colors.white,

              onTap: (){

              },
              child: Container(
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Center(
                    child: Text(
                      "Login/Signup",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              // height: MediaQuery.of(context).size.height * .88,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/bg2.jpg"),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                children: [
                  SizedBox(height: 40),
                  Text(
                    'Your Home For Health',
                    style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Find and Book',
                    style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 40),
                  Container(
                    width: cardWidth,

                    child: Card(
                      shape: OutlineInputBorder(
                        borderSide: BorderSide(width: 0, color: Colors.white),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(0),
                        child: Column(
                          children: [
                            Container(
                              height:50,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: 10),
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: TextField(
                                      controller: locationController,
                                      decoration: InputDecoration(
                                        hintText: "Location",
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(fontSize: 13, color: Colors.black,fontWeight: FontWeight.w400),
                                      ),
                                      onTap: () {
                                        _filterCityNames('');
                                        showdata=false;
                                        print(showcity);

                                        showcity=!showcity;

                                        print(showcity);
                                      },
                                      onChanged: (value) {

                                        _filterCityNames(value);
                                        showdata=false;
                                        print(showcity);

                                        showcity=!showcity;
                                      },
                                    ),
                                  ),
                                  isTablet
                                      ? Container(
                                    height: 90,
                                    width: 1,
                                    decoration: BoxDecoration(color: Colors.grey.shade400),
                                  )
                                      : Container(),
                                  isTablet
                                      ? Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Icon(
                                      Icons.search,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                  )
                                      : Container(),
                                  SizedBox(width: 10),
                                  isTablet
                                      ? Expanded(
                                    child: TextField(
                                      controller: searchController,
                                      decoration: InputDecoration(
                                        hintText: 'Search hospitals',
                                        hintStyle: TextStyle(fontSize: 13, color: Colors.black,fontWeight: FontWeight.w200),
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (value) {
                                        _filterDetails(value);
                                        showdata=!showdata;
                                        showcity=false;
                                      },
                                      onTap: (){

                                        setState(() {
                                          showdata=!showdata;
                                          showcity=false;
                                        });


                                      },
                                    ),
                                  )
                                      : Container(),
                                  isTablet
                                      ? Padding(
                                        padding: const EdgeInsets.only(right: 8.0,left: 8),
                                        child: InkWell(
                                          onTap: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => HospitalDetails(hospitalName: searchController.text.toString(),),));
                                          },
                                          child: Container(
                                                                              height: 36,
                                                                              width: 70,
                                                                              decoration: BoxDecoration(
                                          color: background,
                                          borderRadius: BorderRadius.circular(5)
                                                                              ),
                                                                              child: Center(
                                          child: Text("Search",style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500
                                          ),),
                                                                              ),
                                                                            ),
                                        ),
                                      )
                                      : Container(),
                                ],
                              ),
                            ),


                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  isTablet? Container(): Container(
                    width: cardWidth,

                    child: Card(
                      shape: OutlineInputBorder(
                        borderSide: BorderSide(width: 0, color: Colors.white),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(0),
                        child: Column(
                          children: [


                            Container(
                              height:50,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: 10,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Icon(
                                      Icons.search,
                                      color: Colors.grey.shade400,
                                      size: 20,
                                    ),
                                  )
                                  ,
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: TextField(
                                      controller: searchController,
                                      decoration: InputDecoration(
                                        hintText: 'Search doctors, clinics, hospitals, etc.',
                                        hintStyle: TextStyle(fontSize: 15, color: Colors.grey.shade400),
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (value) {
                                        _filterDetails(value);
                                      },
                                      onTap: (){

                                        setState(() {
                                          showdata=!showdata;
                                          showcity=false;
                                        });


                                      },
                                    ),
                                  )
                                ],
                              ),
                            )


                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: cardWidth,
                        child: Stack(
                          children: [
                            if (filteredCityDetails.isNotEmpty && showcity)
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Container(
                                    decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(5)),
                                    width: isTablet?cardWidth / 2:cardWidth,
                                    child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      physics: ScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: filteredCityDetails.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          title: Text(filteredCityDetails[index].key),
                                          onTap: () {
                                            _selectCityName(filteredCityDetails[index].key);
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            if (showdata && filteredDetails.isNotEmpty)
                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Container(
                                    width: isTablet?cardWidth / 2:cardWidth,
                                    decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(5)),

                                    child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      physics: ScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: filteredDetails.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          title: Text(filteredDetails[index]),
                                          onTap: () {
                                            _selectDetail(filteredDetails[index]);
                                            showdata=false;
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 20.0,
                    children: [
                      Text('Popular searches:', style: TextStyle(color: Colors.grey.shade500)),
                      Text('Dermatologist', style: TextStyle(color: Colors.grey.shade500)),
                      Text('Pediatrician', style: TextStyle(color: Colors.grey.shade500)),
                      Text('Gynecologist/Obstetrician', style: TextStyle(color: Colors.grey.shade500)),
                      Text('Others', style: TextStyle(color: Colors.grey.shade500)),
                    ],
                  ),
                  SizedBox( height:isTablet? MediaQuery.of(context).size.height * .34: MediaQuery.of(context).size.height * .14),
                  Container(
                      decoration: BoxDecoration(color: background),
                      width: double.infinity,
                      child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(children: [
                            // Additional widgets to match the bottom content
                            Wrap(
                              spacing: MediaQuery.of(context).size.width * .02,
                              children: [
                                Column(
                                  children: [
                                    Icon(
                                      Icons.local_hospital,
                                      color: Colors.white70,
                                      size: 18,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Consult with a doctor',
                                      style: TextStyle(
                                          color: Colors.white70, fontSize: 14),
                                    ),
                                  ],
                                ),
                                _buildDivider(),
                                Column(
                                  children: [
                                    Icon(
                                      Icons.local_pharmacy,
                                      color: Colors.white70,
                                      size: 18,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text('Order Medicines',
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14)),
                                  ],
                                ),
                                _buildDivider(),
                                Column(
                                  children: [
                                    Icon(
                                      Icons.receipt,
                                      color: Colors.white70,
                                      size: 18,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text('View medical records',
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14)),
                                  ],
                                ),
                                _buildDivider(),
                                Column(
                                  children: [
                                    Icon(
                                      Icons.science,
                                      color: Colors.white70,
                                      size: 18,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text('Book test',
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14)),
                                  ],
                                ),
                                _buildDivider(),
                                Column(
                                  children: [
                                    Icon(
                                      Icons.book,
                                      color: Colors.white70,
                                      size: 18,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text('Read articles',
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14)),
                                  ],
                                ),
                                _buildDivider(),
                                Column(
                                  children: [
                                    Icon(
                                      Icons.medical_services,
                                      color: Colors.white70,
                                      size: 18,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text('For healthcare providers',
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14)),
                                  ],
                                ),
                              ],
                            ),
                          ])))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 0.5,
      decoration: BoxDecoration(color: Colors.grey.shade400),
    );
  }
}
