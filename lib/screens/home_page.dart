import 'dart:developer';
import 'dart:io';

import 'package:contact_app/model/User.dart';
import 'package:contact_app/screens/EditUser.dart';
import 'package:contact_app/screens/addUser.dart';
import 'package:contact_app/services/userService.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<User> _userList = <User>[];
  List<User> _foundUsers = [];
  final _userService = UserService();

  void _runFilter(String enteredKeyword) {
    List<User> results = [];
    if (enteredKeyword.isEmpty) {
      log('keyword is empty');
      results = _userList;
    } else {
      log(enteredKeyword);

      results = _userList
          .where((user) =>
              user.name!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundUsers = results;
    });
  }

  getAllUserDetails() async {
    var users = await _userService.readAllUsers();
    _userList = <User>[];
    users.forEach((user) {
      setState(() {
        var userModel = User();
        userModel.id = user['id'];
        userModel.name = user['name'];
        userModel.contact = user['contact'];
        userModel.description = user['description'];
        userModel.image = user['image'];
        _userList.add(userModel);
      });
    });
    _foundUsers = _userList;
    log(_foundUsers[1].name!);
  }

  @override
  void initState() {
    getAllUserDetails();
    super.initState();
  }

  _deleteFormDialog(BuildContext context, userId) {
    return showDialog(
        context: context,
        builder: (param) {
          return AlertDialog(
            title: const Text(
              'Are You Sure to Delete',
              style: TextStyle(color: Colors.cyan, fontSize: 20),
            ),
            actions: [
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, // foreground
                      backgroundColor: Colors.red),
                  onPressed: () async {
                    var result = await _userService.deleteUser(userId);
                    if (result != null) {
                      Navigator.pop(context);
                      getAllUserDetails();
                    }
                  },
                  child: const Text('Delete')),
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, // foreground
                      backgroundColor: Colors.cyan),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contents Buddy"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) => _runFilter(value),
              decoration: const InputDecoration(
                  labelText: 'Search', suffixIcon: Icon(Icons.search)),
            ),
          ),
          Expanded(
            child: _foundUsers.isNotEmpty
                ? ListView.builder(
                    itemCount: _foundUsers.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          onTap: () {},
                          leading: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: ClipOval(
                                    child: Image.file(
                                      File(_foundUsers[index].image.toString()),
                                    ),
                                  ))),
                          title: Text(_foundUsers[index].name ?? ''),
                          subtitle: Text(_foundUsers[index].contact ?? ''),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EditUser(
                                                  user: _foundUsers[index],
                                                ))).then((data) {
                                      if (data != null) {
                                        getAllUserDetails();
                                      }
                                    });
                                    ;
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.teal,
                                  )),
                              IconButton(
                                  onPressed: () {
                                    _deleteFormDialog(
                                        context, _foundUsers[index].id);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ))
                            ],
                          ),
                        ),
                      );
                    })
                : const Text(
                    'No results found',
                    style: TextStyle(fontSize: 24),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddUser()))
              .then((data) {
            if (data != null) {
              getAllUserDetails();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
