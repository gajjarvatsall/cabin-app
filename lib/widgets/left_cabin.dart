import 'package:cabin_app/repository/left_cabin_repository.dart';
import 'package:cabin_app/utils/app_theme.dart';
import 'package:cabin_app/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cabin_app/helper/get_storage_helper.dart';

class LeftCabin extends StatefulWidget {
  const LeftCabin({Key? key}) : super(key: key);

  @override
  State<LeftCabin> createState() => _LeftCabinState();
}

class _LeftCabinState extends State<LeftCabin> {
  final String cabinLeft = 'cabinLeft';
  final FirebaseAuth auth = FirebaseAuth.instance;
  CabinRepository obj = CabinRepository();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Left Cabins",
          style: AppTheme.titleText,
        ),
        SizedBox(
          height: AppConstants.height,
        ),
        StreamBuilder(
          stream: FirebaseFirestore.instance.collection(cabinLeft).snapshots(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 15,
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot cabins = snapshot.data!.docs[index];
                    return GestureDetector(
                      onTap: () async {
                        /* if (onTapped.isTap == false) {
                          onTapped.isTap = true;
                          onTapped.getStorage.write('isTap', true);
                          print("+++++++++++++${onTapped.isTap}");
                          if (cabin['isSelected'] == false) {
                            if (cabin['userId'] == auth.currentUser!.uid &&
                                cabin['isSelected'] == true) {
                              obj.updateCabinValue(cabin.id, false, '');
                            } else {
                              bool hasData = await obj.doesUserIdAlreadyExist(
                                  auth.currentUser!.uid);
                              if (hasData == false) {
                                obj.updateCabinValue(
                                    cabin.id, true, auth.currentUser!.uid);
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Your already in a Cabin!"),
                                  duration: Duration(seconds: 2),
                                ));
                              }
                            }
                          } else {
                            if (cabin['userId'] == auth.currentUser!.uid &&
                                cabin['isSelected'] == true) {
                              obj.updateCabinValue(cabin.id, false, '');
                            }
                          }
                        } else {
                          if (cabin['userId'] == auth.currentUser!.uid &&
                              cabin['isSelected'] == true) {
                            obj.updateCabinValue(cabin.id, false, '');
                          }
                          onTapped.getStorage.write('isTap', false);
                          onTapped.isTap = false;
                          print("-------------${onTapped.isTap}");*/
                        // }
                        bool isTapped = onTapped.getStorage.read('isTap');
                        print('isTapped - Left $isTapped');

                        if (cabins['isSelected'] == false) {
                          if (cabins['userId'] == auth.currentUser!.uid &&
                              cabins['isSelected'] == true &&
                              isTapped) {
                            obj.updateCabinValue(cabins.id, false, '');
                            onTapped.getStorage.write('isTap', false);
                          } else {
                            bool hasData = await obj
                                .doesUserIdAlreadyExist(auth.currentUser!.uid);
                            if (hasData == false &&
                                cabins['isSelected'] == false &&
                                !isTapped) {
                              obj.updateCabinValue(
                                  cabins.id, true, auth.currentUser!.uid);
                              onTapped.getStorage.write('isTap', true);
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("You are already in a Cabin !"),
                                duration: Duration(seconds: 2),
                              ));
                            }
                          }
                        } else {
                          if (cabins['userId'] == auth.currentUser!.uid &&
                              cabins['isSelected'] == true &&
                              isTapped) {
                            obj.updateCabinValue(cabins.id, false, '');
                            onTapped.getStorage.write('isTap', false);
                          }
                        }
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: cabins['isSelected'] == true
                                ? Colors.red
                                : Colors.green,
                            border: Border.all(
                              color: cabins['isSelected'] == true
                                  ? Colors.red
                                  : Colors.green,
                            )),
                        child: Center(
                          child: Text(
                            "${index + 1}",
                            style: TextStyle(
                              fontSize: 20,
                              color: cabins['isSelected'] == true
                                  ? Colors.white
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
