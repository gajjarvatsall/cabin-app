import 'package:cabin_app/models/cabin_model.dart';
import 'package:cabin_app/repository/right_cabin_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RightCabin extends StatefulWidget {
  const RightCabin({Key? key}) : super(key: key);

  @override
  State<RightCabin> createState() => _RightCabinState();
}

class _RightCabinState extends State<RightCabin> {
  Future<List<CabinModel>>? futureCabin;

  RCabin obj = RCabin();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureCabin = obj.allCabins();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text(
            "Right cabin",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          FutureBuilder<List<CabinModel>>(
            future: futureCabin,
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                return Flexible(
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 15,
                    children: List.generate(snapshot.data!.length, (index) {
                      return GestureDetector(
                        onTap: () async {
                          setState(() {
                            snapshot.data![index].isSelected =
                                !snapshot.data![index].isSelected;
                          });
                          if (snapshot.data![index].isSelected == true) {
                            try {
                              final post = await FirebaseFirestore.instance
                                  .collection('cabin_beta')
                                  .where('cabinName',
                                      isEqualTo:
                                          snapshot.data![index].cabinName)
                                  .limit(1)
                                  .get()
                                  .then((QuerySnapshot snapshot) {
                                //Here we get the document reference and return to the post variable.
                                return snapshot.docs[0].reference;
                              });

                              var batch = FirebaseFirestore.instance.batch();
                              //Updates the field value, using post as document reference
                              batch.update(post, {
                                'isSelected': snapshot.data![index].isSelected
                              });
                              batch.commit();
                            } catch (e) {
                              print(e);
                            }
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: snapshot.data![index].isSelected == true
                                  ? Colors.red
                                  : Colors.green,
                              border: Border.all(
                                color: snapshot.data![index].isSelected == true
                                    ? Colors.green
                                    : Colors.black38,
                              )),
                          child: Center(
                            child: Text(
                              "${index + 1}",
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                );
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
      ),
    );
  }
}
