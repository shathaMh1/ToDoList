import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapplication/controller/home_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('To Do App'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.dialog(
              AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: const Text('Add a todo'),
                content: SizedBox(
                  height: 100,
                  width: 400,
                  child: Column(
                    children: [
                      TextField(
                        onChanged: ((value) {
                          controller.title = value;
                        }),
                      ),
                      TextField(
                        onChanged: (value) {
                          controller.desc = value;
                        },
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      controller.createTodo();
                      Get.back();
                    },
                    child: const Text('ADD'),
                  ),
                ],
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('MyTodos').snapshots(),
          builder: ((context, snapshot) {
            if (snapshot.hasError) {
              return const Text('error');
            } else if (snapshot.hasData || snapshot.data != null) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                        'your ToDo List have ${snapshot.data?.docs.length} items'),
                  ),
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: ((context, index) {
                        return Card(
                          elevation: 4,
                          child: Dismissible(
                            onDismissed: (direction) {
                              controller.deleteTodo(
                                  snapshot.data?.docs[index]['todoTitle']);
                            },
                            key: UniqueKey(),
                            child: ListTile(
                              leading: Checkbox(
                                  value: snapshot.data?.docs[index]
                                      ['isChecked'],
                                  onChanged: ((value) {
                                    controller.checkTodo(snapshot
                                        .data?.docs[index]['todoTitle']);
                                  })),
                              title:
                                  Text(snapshot.data?.docs[index]['todoTitle']),
                              //
                              subtitle:
                                  Text(snapshot.data?.docs[index]['todoDesc']),
                              //
                              trailing: IconButton(
                                  onPressed: () {
                                    controller.deleteTodo(snapshot
                                        .data?.docs[index]['todoTitle']);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  )),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              );
            }
            return Container();
          }),
        ),
      );
    });
  }
}
