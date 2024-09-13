import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';
import 'package:flutter/services.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final firstnamecontroller = TextEditingController();
  final lastnamecontroller = TextEditingController();
  final collegenamecontroller = TextEditingController();
  final statecontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final confirmpasswordcontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final numbercontroller = TextEditingController();
  final gendercontroller = TextEditingController(); // Controller for gender

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _gender;
  String? _errorMessage;
  String? _successMessage;

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed to free up resources
    firstnamecontroller.dispose();
    lastnamecontroller.dispose();
    collegenamecontroller.dispose();
    statecontroller.dispose();
    passwordcontroller.dispose();
    confirmpasswordcontroller.dispose();
    emailcontroller.dispose();
    numbercontroller.dispose();
    gendercontroller.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    setState(() {
      _errorMessage = null;
      _successMessage = null;
    });

    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailcontroller.text.trim(),
          password: passwordcontroller.text.trim(),
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'first_name': firstnamecontroller.text.trim(),
          'last_name': lastnamecontroller.text.trim(),
          'email': emailcontroller.text.trim(),
          'college_name': collegenamecontroller.text.trim(),
          'state': statecontroller.text.trim(),
          'phone_number': numbercontroller.text.trim(),
          'gender': _gender,
          'user_id': userCredential.user!.uid, // Store the user ID
        });

        setState(() {
          _successMessage = 'Registration successful!';
          _clearForm();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_successMessage!),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          if (e.code == 'email-already-in-use') {
            _errorMessage = 'The account already exists for that email.';
          } else if (e.code == 'weak-password') {
            _errorMessage = 'The password provided is too weak.';
          } else {
            _errorMessage = 'An error occurred: ${e.message}';
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      } catch (e) {
        setState(() {
          _errorMessage = 'An error occurred: $e';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _clearForm() {
    firstnamecontroller.clear();
    lastnamecontroller.clear();
    collegenamecontroller.clear();
    statecontroller.clear();
    passwordcontroller.clear();
    confirmpasswordcontroller.clear();
    emailcontroller.clear();
    numbercontroller.clear();
    gendercontroller.clear();
    setState(() {
      _gender = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Registration',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 28, 23, 47), // Updated color
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Card(
          color: Color.fromARGB(255, 28, 23, 47), // Card background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 8.0,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: firstnamecontroller,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      labelStyle:
                          TextStyle(color: Colors.white), // White label text
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: TextStyle(color: Colors.white), // White input text
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: lastnamecontroller,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      labelStyle:
                          TextStyle(color: Colors.white), // White label text
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: TextStyle(color: Colors.white), // White input text
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: emailcontroller,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle:
                          TextStyle(color: Colors.white), // White label text
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: TextStyle(color: Colors.white), // White input text
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      // You can add more sophisticated email validation if needed
                      return null;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: collegenamecontroller,
                    decoration: InputDecoration(
                      labelText: 'College Name',
                      labelStyle:
                          TextStyle(color: Colors.white), // White label text
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: TextStyle(color: Colors.white), // White input text
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your college name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: statecontroller,
                    decoration: InputDecoration(
                      labelText: 'State of College',
                      labelStyle:
                          TextStyle(color: Colors.white), // White label text
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: TextStyle(color: Colors.white), // White input text
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your state of college';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: numbercontroller,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle:
                          TextStyle(color: Colors.white), // White label text
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: TextStyle(color: Colors.white), // White input text
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      final regExp = RegExp(r'^[6789]\d{9}$');
                      if (!regExp.hasMatch(value)) {
                        return 'Please enter a valid 10-digit phone number starting with 9, 8, 7, or 6';
                      }
                      // You can add more sophisticated phone number validation if needed
                      return null;
                    },
                    keyboardType: TextInputType
                        .phone, // Ensures numeric keyboard is shown
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter
                          .digitsOnly // Ensures only digits are input
                    ],
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: passwordcontroller,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle:
                          TextStyle(color: Colors.white), // White label text
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: TextStyle(color: Colors.white), // White input text
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      // You can add more password validation if needed
                      return null;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: confirmpasswordcontroller,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      labelStyle:
                          TextStyle(color: Colors.white), // White label text
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: TextStyle(color: Colors.white), // White input text
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != passwordcontroller.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.0),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      labelStyle:
                          TextStyle(color: Colors.white), // White label text
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    value: _gender,
                    onChanged: (String? value) {
                      setState(() {
                        _gender = value;
                        gendercontroller.text =
                            value ?? ''; // Update the controller
                      });
                    },
                    items: ['Male', 'Female', 'Others']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your gender';
                      }
                      return null;
                    },
                    dropdownColor: Colors.white, // Dropdown background color
                    style: TextStyle(color: Colors.blue), // White dropdown text
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Button background color
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: _registerUser,
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: Color.fromARGB(
                            255, 28, 23, 47), // Button text color
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Navigate to the login page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        },
                        child: Text(
                          'Already have an account? Sign in',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: RegistrationPage(),
  ));
}
