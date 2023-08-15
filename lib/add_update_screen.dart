import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:todolist/db_handler.dart';
import 'package:todolist/home_screen.dart';
import 'package:todolist/model.dart';

class AddUpdateTask extends StatefulWidget {
  int? todoId;
  String? todoTitle;
  String? todoDesc;
  String? todoDt;

  bool? update;

  AddUpdateTask({
    this.todoId,
    this.todoTitle,
    this.todoDesc,
    this.todoDt,
    this.update,
  });

  @override
  State<AddUpdateTask> createState() => _AddUpdateTaskState();
}

class _AddUpdateTaskState extends State<AddUpdateTask> {
  DBHelper? dbHelper;
  late Future<List<TodoModel>> datalist;

  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async {
    datalist = dbHelper!.getDataList();
  }

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: widget.todoTitle);
    final descController = TextEditingController(text: widget.todoDesc);

    String appTitle;
    if (widget.update == true) {
      appTitle = "Update Task";
    } else {
      appTitle = "Add New Task";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appTitle,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        leading: BackButton(color: Colors.white),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
          padding: EdgeInsets.only(top: 100),
          child: SingleChildScrollView(
            child: Column(children: [
              Form(
                key: _formkey,
                child: Column(children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      controller: titleController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), hintText: "Note Title"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter some text";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 5,
                      controller: descController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Write notes here"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter some text";
                        }
                        return null;
                      },
                    ),
                  )
                ]),
              ),
              SizedBox(height: 40),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Material(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(15),
                        child: InkWell(
                          onTap: () {
                            if (_formkey.currentState!.validate()) {
                              if (widget.update == true) {
                                dbHelper!.update(TodoModel(
                                  id: widget.todoId,
                                  title: titleController.text,
                                  desc: descController.text,
                                  dateandtime: widget.todoDt,
                                ));
                              } else {
                                dbHelper!.insert(TodoModel(
                                    title: titleController.text,
                                    desc: descController.text,
                                    dateandtime: DateFormat('yMd')
                                        .add_jm()
                                        .format(DateTime.now())
                                        .toString()));
                              }

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));

                              titleController.clear();
                              descController.clear();

                              print("Data added ");
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            height: 55,
                            width: 120,
                            decoration: const BoxDecoration(
                                //   boxShadow: [
                                //   BoxShadow(
                                //     color: Colors.black12,
                                //     blurRadius: 5,
                                //     spreadRadius: 1,
                                //   ),
                                // ]
                                ),
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(15),
                        child: InkWell(
                          onTap: () {
                            titleController.clear();
                            descController.clear();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            height: 55,
                            width: 120,
                            decoration: const BoxDecoration(
                                //   boxShadow: [
                                //   BoxShadow(
                                //     color: Colors.black12,
                                //     blurRadius: 5,
                                //     spreadRadius: 1,
                                //   ),
                                // ]
                                ),
                            child: Text(
                              "Clear",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ]),
              )
            ]),
          )),
    );
  }
}
