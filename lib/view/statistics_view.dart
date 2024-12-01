import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../res/colors.dart';
import '../res/components/custom_appbar.dart';
import '../view_model/login_view_model.dart';
import 'bill_history_view.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        body: Text('data'),
      );
    }
    return Scaffold(
      appBar: CustomAppBar(
        title: 'STATISTICS',
        action: [
          InkWell(
              onTap: () {
                loginProvider.logout(context);
              },
              child: Icon(
                Icons.logout,
                color: Colors.white,
              )),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Bill_Details')
            .where('user_id', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.docs.isEmpty) {
            print('Empty');
            return Center(
                child: Text(
              'No Bill Generated Yet',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white),
            ));
          }
          if ( snapshot.data != null) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, bottom: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BillDetailsHistory(
                                      date: snapshot.data!.docs[index]
                                          ['Reading_Date'],
                                      billMonth: snapshot.data!.docs[index]
                                          ['Bill_Month'],
                                   prevUnits: snapshot.data!.docs[index]['Previous_Units'],
                                  currUnits: snapshot.data!.docs[index]['Current_Units'],
                                  totalUnits: snapshot.data!.docs[index]['Units_Consumed'],
                                   unitsPrice: snapshot.data!.docs[index]['Units_Price'],
                                   tvFee: snapshot.data!.docs[index]['TV_Fee'],
                                currBill: snapshot.data!.docs[index]['Current_Bill'],
                                  fcSur: snapshot.data!.docs[index]['FC_SUR'],
                                  ed: snapshot.data!.docs[index]['Electricity_Duty'],
                                  cost: snapshot.data!.docs[index]['Total_Cost'],
                                //  fpa: snapshot.data!.docs[index]['Total_FPA'],
                                  GST: snapshot.data!.docs[index]['GST'],
                                  // Qtr: snapshot.data!.docs[index]['Annual_QTR'],
                                  docId: snapshot.data!.docs[index].id, Name: snapshot.data!.docs[index]['Name'],
                                    )));
                      },
                      child: Card(
                        color: Colours.kGreenColor,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(
                            'Bill Month: ${snapshot.data!.docs[index]['Bill_Month']}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          subtitle: Text(
                            'Total Bill: ${snapshot.data!.docs[index]['Current_Bill']}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          trailing: Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}

