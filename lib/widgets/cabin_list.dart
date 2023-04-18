import 'package:cabin_app/repository/cabin_repository.dart';
import 'package:cabin_app/utils/app_theme.dart';
import 'package:cabin_app/utils/constants.dart';
import 'package:cabin_app/widgets/cabin_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class CabinList extends StatefulWidget {
  CabinList({Key? key}) : super(key: key);

  @override
  State<CabinList> createState() => _CabinListState();
}

class _CabinListState extends State<CabinList> {
  final String cabins = 'cabins';
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Divider(),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection(cabins).snapshots(),
            builder: (context, snapshot) {
              return FutureBuilder(
                future: CabinRepository.userData(),
                builder: (context, snapShot) {
                  return (snapShot.data?.isNotEmpty ?? false)
                      ? Column(
                          children: [
                            SizedBox(
                              height: 50,
                              child: Marquee(
                                blankSpace: 100,
                                text: snapShot.data ?? ' Welcome To 7span ',
                                style: AppTheme.titleText,
                              ),
                            ),
                            const Divider(),
                          ],
                        )
                      : Container();
                },
              );
            },
          ),
          SizedBox(
            height: AppConstants.height,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Left Cabin",
                style: AppTheme.titleText.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                "Right Cabin",
                style: AppTheme.titleText.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            height: AppConstants.height,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection(cabins).limit(5).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: Wrap(
                        children: snapshot.data!.docs.map((documentSnapshot) {
                          return CustomCabin(documentSnapshot: documentSnapshot);
                        }).toList(),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection(cabins).where("cabinId", isGreaterThan: 5).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Wrap(
                      children: snapshot.data!.docs.map((documentSnapshot) {
                        return CustomCabin(documentSnapshot: documentSnapshot);
                      }).toList(),
                    );
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
          SizedBox(
            height: AppConstants.height,
          ),
        ],
      ),
    );
  }
}
