import 'dart:developer';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import './addUser.dart';
import '../model/User.dart';
import '../services/userService.dart';
import 'package:flutter/material.dart';

class EditUser extends StatefulWidget {
  final User user;
  const EditUser({Key? key, required this.user}) : super(key: key);

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  bool circular = false;
  PickedFile? _imageFile;
  var _userNameController = TextEditingController();
  var _userContactController = TextEditingController();
  var _userDescriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool _validateName = false;
  bool _validateContact = false;
  bool _validateDescription = false;
  var _userService = UserService();

  @override
  void initState() {
    setState(() {
      _userNameController.text = widget.user.name ?? '';
      _userContactController.text = widget.user.contact ?? '';
      _userDescriptionController.text = widget.user.description ?? '';
       _imageFile = widget.user.image as PickedFile?;

      //_imageFile = widget.user.image.toString() as PickedFile?;
    });
    super.initState();
  }

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
                'Edit Contact',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.cyan,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20.0,
              ),
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
              // Buttons
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 13, 165, 189),
                  minimumSize: const Size.fromHeight(50),
                  // NEW
                ),
                onPressed: () async {
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
                    _user.id = widget.user.id;
                    _user.name = _userNameController.text;
                    _user.contact = _userContactController.text;
                    _user.description = _userDescriptionController.text;
                    _user.image = _imageFile!.path.toString();
                    log(_imageFile!.path.toString());

                    var result = await _userService.UpdateUser(_user);
                    Navigator.pop(context, result);
                  }
                },
                child: const Text(
                  'Update Contact',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              //clear button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 8, 185, 185),
                  minimumSize: const Size.fromHeight(50),
                  // NEW
                ),
                onPressed: () {
                  _userNameController.text = '';
                  _userContactController.text = '';
                  _userDescriptionController.text = '';
                },
                child: const Text(
                  'Clear',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
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
              ? const AssetImage("images/user.png") as ImageProvider
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
