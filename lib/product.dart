import 'package:flutter/material.dart';

class Product extends StatelessWidget {
  const Product({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.zero) ,
              backgroundColor: MaterialStateProperty.all(Colors.white),
              overlayColor: MaterialStateProperty.all(Colors.teal.withOpacity(0.2)),
              shape: MaterialStateProperty.all(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
            ),
            onPressed: () {},
            child: Container(
              margin: const EdgeInsets.only(bottom: 15),
              decoration: const BoxDecoration(color: Colors.transparent),
              child: ListTile(
                title: Text('منتج'),
                subtitle: Text("4579837459"),
                leading: Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(child: Icon(Icons.edit_note, color: Colors.white,),),
                    )),
                titleAlignment: ListTileTitleAlignment.center,
                trailing: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      "20000L.L",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25),
                    )),
              ),
            )),
        Divider(color: Colors.grey.withOpacity(0.3), thickness: 0, height: 1,)
      ],
    );
  }
}
