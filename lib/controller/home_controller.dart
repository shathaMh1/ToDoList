import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  String title = '';
  String desc = '';
  bool isChecked = false;
  List todos = [];

  createTodo() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('MyTodos').doc(title);

    Map<String, dynamic> todoList = {
      'todoTitle': title,
      'todoDesc': desc,
      'isChecked': isChecked,
    };

    documentReference
        .set(todoList)
        .whenComplete(() => print('data created successfully'));
    update();
  }

  deleteTodo(item) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('MyTodos').doc(item);

    documentReference.delete().whenComplete(() => print('Item deleted'));
    update();
  }

  checkTodo(item) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('MyTodos').doc(item);

    documentReference.update({'isChecked': true});
    update();
  }
}
