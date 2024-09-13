import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangePasswordScreen(),
    );
  }
}

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  bool _hasUppercase = false;
  bool _hasSpecialChar = false;
  bool _hasDigits = false;
  bool _hasMinLength = false;

  void _checkPassword(String password) {
    setState(() {
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      _hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
      _hasDigits = password.contains(RegExp(r'[0-9]'));
      _hasMinLength = password.length >= 8;
    });
  }

  void _resetCriteria() {
    setState(() {
      _hasUppercase = false;
      _hasSpecialChar = false;
      _hasDigits = false;
      _hasMinLength = false;
    });
  }

  Future<void> _changePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        User? user = FirebaseAuth.instance.currentUser;
        AuthCredential credential = EmailAuthProvider.credential(
          email: user!.email!,
          password: _oldPasswordController.text,
        );

        // Reauthenticate user with old password
        await user.reauthenticateWithCredential(credential);

        // Update the password
        await user.updatePassword(_newPasswordController.text);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password changed successfully'),
            backgroundColor: Colors.green,
          ),
        );

        // Clear the input fields and reset criteria
        _oldPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
        _resetCriteria();
      } on FirebaseAuthException catch (e) {
        String message;
        if (e.code == 'wrong-password') {
          message = 'The old password is incorrect.';
        } else {
          message = 'An error occurred: ${e.message}';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Widget _buildCriteriaRow(String criteria, bool isValid) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.cancel,
          color: isValid ? Colors.green : Colors.red,
        ),
        SizedBox(width: 8),
        Text(
          criteria,
          style: TextStyle(color: isValid ? Colors.green : Colors.red),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 28, 23, 47), // Custom color
        iconTheme: IconThemeData(color: Colors.white), // White back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            color: Color.fromARGB(255, 28, 23, 47), // Card background color
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _oldPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Old Password',
                        labelStyle:
                            TextStyle(color: Colors.white), // White label text
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white), // White border
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white), // White border on focus
                        ),
                      ),
                      obscureText: true,
                      style: TextStyle(color: Colors.white), // White input text
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your old password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _newPasswordController,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        labelStyle:
                            TextStyle(color: Colors.white), // White label text
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white), // White border
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white), // White border on focus
                        ),
                      ),
                      obscureText: true,
                      style: TextStyle(color: Colors.white), // White input text
                      onChanged: _checkPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a new password';
                        }
                        if (value == _oldPasswordController.text) {
                          return 'New password must be different from old password';
                        }
                        if (!_hasUppercase ||
                            !_hasSpecialChar ||
                            !_hasDigits ||
                            !_hasMinLength) {
                          return 'Password does not meet the criteria';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirm New Password',
                        labelStyle:
                            TextStyle(color: Colors.white), // White label text
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white), // White border
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white), // White border on focus
                        ),
                      ),
                      obscureText: true,
                      style: TextStyle(color: Colors.white), // White input text
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your new password';
                        } else if (value != _newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    _buildCriteriaRow(
                        'At least 1 uppercase letter', _hasUppercase),
                    _buildCriteriaRow(
                        'At least 1 special character', _hasSpecialChar),
                    _buildCriteriaRow('At least 1 number', _hasDigits),
                    _buildCriteriaRow('Minimum 8 characters', _hasMinLength),
                    SizedBox(height: 20),
                    _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _changePassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white, // Button color
                            ),
                            child: Text('Change Password',
                                style: TextStyle(
                                    color: Color.fromARGB(
                                        255, 28, 23, 47))), // Button text color
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
