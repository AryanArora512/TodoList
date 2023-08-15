import 'package:flutter/material.dart';
import 'package:todolist/db_handler.dart';
import 'package:todolist/model.dart';
import 'package:hexcolor/hexcolor.dart';

import 'add_update_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DBHelper? dbHelper;
  late Future<List<TodoModel>> datalist;

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
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Todo List App",
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(padding: EdgeInsets.only(right: 10)),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(color: HexColor("#f7f1f3")),
        child: Column(children: [
          Expanded(
              child: FutureBuilder(
            future: datalist,
            builder: (context, AsyncSnapshot<List<TodoModel>> snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.data!.length == 0) {
                return Center(
                  child: Text(
                    "No Task Found ",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: HexColor("#292b29")),
                  ),
                );
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    int todoID = snapshot.data![index].id!.toInt();
                    String todoTitle = snapshot.data![index].title!.toString();
                    String todoDesc = snapshot.data![index].desc!.toString();
                    String todoDatetime =
                        snapshot.data![index].dateandtime!.toString();
                    return Dismissible(
                      key: ValueKey<int>(todoID),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: HexColor("#e61327"),
                        child: Icon(
                          Icons.delete_forever,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (DismissDirection direction) {
                        setState(() {
                          dbHelper!.delete(todoID);
                          datalist = dbHelper!.getDataList();
                          snapshot.data!.remove(snapshot.data![index]);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: HexColor("#f9c36c"),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  spreadRadius: 1)
                            ]),
                        child: Column(children: [
                          ListTile(
                            contentPadding: EdgeInsets.all(10),
                            title: Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text(
                                todoTitle,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            subtitle: Text(
                              todoDesc,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black54),
                            ),
                          ),
                          Divider(
                            color: HexColor("#f7f1f3"),
                            thickness: 0.9,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 3, horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  todoDatetime,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.italic),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddUpdateTask(
                                            todoId: todoID,
                                            todoTitle: todoTitle,
                                            todoDesc: todoDesc,
                                            todoDt: todoDatetime,
                                            update: true,
                                          ),
                                        ));
                                  },
                                  child: Icon(
                                    Icons.edit_note,
                                    size: 28,
                                    color: HexColor("#e61327"),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ]),
                      ),
                    );
                  },
                );
              }
            },
          ))
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: HexColor("#292b29"),
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddUpdateTask(),
              ));
        },
      ),
    );
  }
}
