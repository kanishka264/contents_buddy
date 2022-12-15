import 'dart:developer';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../model/User.dart';
import '../services/userService.dart';
import 'package:flutter/material.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  bool circular = false;
  PickedFile? _imageFile;
  final _userNameController = TextEditingController();
  final _userContactController = TextEditingController();
  final _userDescriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool _validateName = false;
  bool _validateContact = false;
  bool _validateDescription = false;
  final _userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contents Buddy"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add New Contact',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.teal,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20.0,
              ),
              // const Center(
              //   child: CircleAvatar(
              //     backgroundColor: Colors.grey,
              //     radius: 100,
              //     child: Icon(Icons.camera),
              //   ),
              // ),
              imageProfile(),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                  controller: _userNameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter Name',
                    labelText: 'Name',
                    errorText:
                        _validateName ? 'Name Value Can\'t Be Empty' : null,
                  )),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                  keyboardType: TextInputType.number,
                  controller: _userContactController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter Contact',
                    labelText: 'Contact',
                    errorText: _validateContact
                        ? 'Contact Value Can\'t Be Empty'
                        : null,
                  )),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                  controller: _userDescriptionController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter Email',
                    labelText: 'Email',
                    errorText: _validateDescription
                        ? 'Email Value Can\'t Be Empty'
                        : null,
                  )),
              const SizedBox(
                height: 20.0,
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 15, 155, 194),
                  minimumSize: const Size.fromHeight(50),
                  // NEW
                ),
                onPressed: () async {
                  log('tapped');
                  setState(() {
                    _userNameController.text.isEmpty
                        ? _validateName = true
                        : _validateName = false;
                    _userContactController.text.isEmpty
                        ? _validateContact = true
                        : _validateContact = false;
                    _userDescriptionController.text.isEmpty
                        ? _validateDescription = true
                        : _validateDescription = false;
                  });
                  if (_validateName == false &&
                      _validateContact == false &&
                      _validateDescription == false) {
                    // print("Good Data Can Save");
                    var _user = User();
                    _user.name = _userNameController.text;
                    _user.contact = _userContactController.text;
                    _user.description = _userDescriptionController.text;
                    _user.image = _imageFile!.path.toString();
                    log(_imageFile!.path.toString());
                    var result = await _userService.SaveUser(_user);
                    Navigator.pop(context, result);
                  }
                },
                child: const Text(
                  'Save Contact',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),

              // TextButton(
              //     style: TextButton.styleFrom(
              //         primary: Colors.white,
              //         backgroundColor: Colors.teal,
              //         textStyle: const TextStyle(fontSize: 15)),
              //     onPressed: () async {
              //       setState(() {
              //         _userNameController.text.isEmpty
              //             ? _validateName = true
              //             : _validateName = false;
              //         _userContactController.text.isEmpty
              //             ? _validateContact = true
              //             : _validateContact = false;
              //         _userDescriptionController.text.isEmpty
              //             ? _validateDescription = true
              //             : _validateDescription = false;
              //       });
              //       if (_validateName == false &&
              //           _validateContact == false &&
              //           _validateDescription == false) {
              //         // print("Good Data Can Save");
              //         var _user = User();
              //         _user.name = _userNameController.text;
              //         _user.contact = _userContactController.text;
              //         _user.description = _userDescriptionController.text;
              //         var result = await _userService.SaveUser(_user);
              //         Navigator.pop(context, result);
              //       }
              //     },
              //     child: const Text('Save Details')),
              // const SizedBox(
              //   width: 10.0,
              // ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 15, 155, 194),
                  minimumSize: const Size.fromHeight(50),
                  // NEW
                ),
                onPressed: () {
                  _userNameController.text = '';
                  _userContactController.text = '';
                  _userDescriptionController.text = '';
                  log('cleared');
                },
                child: const Text(
                  'Clear',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              // TextButton(
              //     style: TextButton.styleFrom(
              //         primary: Colors.white,
              //         backgroundColor: Colors.red,
              //         shape: const BeveledRectangleBorder(
              //             borderRadius: BorderRadius.all(Radius.circular(5))),
              //         textStyle: const TextStyle(fontSize: 15)),
              //     onPressed: () {
              //       _userNameController.text = '';
              //       _userContactController.text = '';
              //       _userDescriptionController.text = '';
              //     },
              //     child: const Text('Clear Details'))
            ],
          ),
        ),
      ),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
          radius: 80.0,
          // ignore: unnecessary_null_comparison
          backgroundImage: _imageFile == null
              ? const AssetImage("assets/images/profile.gng") as ImageProvider
              : FileImage(File(_imageFile!.path)),
        ),
        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: InkWell(
            onTap: () async {
              final pickedFile =
                  await _picker.getImage(source: ImageSource.gallery);
              setState(() {
                _imageFile = pickedFile!;
              });
            },
            child: const Icon(
              Icons.camera_alt,
              color: Colors.teal,
              size: 28.0,
            ),
          ),
        ),
      ]),
    );
  }
}
