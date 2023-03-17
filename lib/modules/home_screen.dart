import 'package:cabin_app/widgtes/custom_cabin.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cabins"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width / 40),
        child: Column(
          children: [
            Text(
              "Left cabin",
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: const [
                CustomCabinContainer(number: "1"),
                CustomCabinContainer(number: "2"),
                CustomCabinContainer(number: "3"),
                CustomCabinContainer(number: "4"),
                CustomCabinContainer(number: "5"),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Right cabin",
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isSelected = true;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: isSelected == true
                          ? BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.green,
                                width: 3,
                              ))
                          : BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.shade300,
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 3,
                              )),
                      child: const Center(
                        child: Text(
                          "1",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const CustomCabinContainer(number: "2"),
                const CustomCabinContainer(number: "3"),
                const CustomCabinContainer(number: "4"),
              ],
            )
          ],
        ),
      ),
    );
  }
}
