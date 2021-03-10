import 'package:flutter/material.dart';
import 'package:frontline/screens/headline.dart';
import 'package:frontline/widgets/drawer.dart';

class Home extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      drawer: NavDrawer(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(8.0),
                  height: 200.0,
                  width: 200.0,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent)
                  ),
                  child: Image.asset("./asset/med.jpg"),
                )
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () => print("tapped"),
                  child: Container(
                    height: 130.0,
                    width: 130.0,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.update_outlined,
                            color: Colors.cyan,
                            size: 40.0,
                          ),
                          SizedBox(height: 5.0,),
                          Text("Feed Updates",
                            style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.normal,
                                letterSpacing: 1.0
                            )
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => print("tapped"),
                  child: Container(
                    height: 130.0,
                    width: 130.0,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            color: Colors.cyan,
                            size: 40.0,
                          ),
                          SizedBox(height: 5.0,),
                          Text("Search Jobs",
                            style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 1.0
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(

              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () => print("tapped"),
                  child: Container(
                    height: 130.0,
                    width: 130.0,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shield,
                            color: Colors.cyan,
                            size: 40.0,
                          ),
                          SizedBox(height: 5.0,),
                          Text("My Safety",
                            style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.normal,
                                letterSpacing: 1.0
                            )
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Headline()));
                  },
                  child: Container(
                    height: 130.0,
                    width: 130.0,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.credit_card_outlined,
                            color: Colors.cyan,
                            size: 40.0,
                          ),
                          SizedBox(height: 5.0,),
                          Text("My News",
                            style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.normal,
                                letterSpacing: 2.0
                            )
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>{},
        backgroundColor: Colors.cyan,
        child: Icon(Icons.add_alert_rounded),
      ),
    );
  }

}

