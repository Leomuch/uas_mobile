import 'package:flutter/material.dart';
import 'package:sofa_score/pages/home_page.dart';
import 'package:sofa_score/util/custom_text_field.dart';
import 'package:intl/intl.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> with SingleTickerProviderStateMixin {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController tanggalLahir = TextEditingController();
  TextEditingController emailPhoneLogin = TextEditingController();
  TextEditingController emailPhoneRegis = TextEditingController();
  TextEditingController genderController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  late TabController _tabController;
  bool _isObscured = true;
  bool _showPassword = false;
  bool _agreedToTerms = false;
  bool _autoLogin = false;
  var gender = "";
  DateTime? _selectedDate;
  String? _country;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Add a listener to update the state when the tab changes
    _tabController.addListener(() {
      setState(() {}); // Call setState to trigger a rebuild
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text =
            DateFormat('d MMMM, yyyy').format(_selectedDate!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sofa Score'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              Text(
                _tabController.index == 0
                    ? 'Welcome Back'
                    : "Let's Get Started",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _tabController.index == 0
                    ? 'Please login with your account'
                    : "Please create your account",
                style: const TextStyle(
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 6),
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: "Sign In"),
                  Tab(text: "Sign Up"),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // sign in
          Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 6),
                CustomTextField(
                  controller: emailPhoneLogin,
                  label: "Email Or Phone",
                  hint: "Enter Email Or Phone",
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: password,
                  label: "Password",
                  hint: "Enter Password",
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Remember Me'),
                  trailing: Switch(
                    value: _autoLogin,
                    onChanged: (bool value) {
                      setState(() {
                        _autoLogin = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      );
                    },
                    child: const Text('Login'),
                  ),
                )
              ],
            ),
          ),
          // sign up
          Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              // physics: const NeverScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 6),
                CustomTextField(
                  controller: username,
                  label: "Username",
                  hint: "Enter Username",
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: emailPhoneRegis,
                  label: "Email Or Phone",
                  hint: "Enter Email Or Phone",
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _dateController,
                  label: "Birth Date",
                  hint: "Select Birth Date",
                  onTap: () => _selectDate(context),
                  readOnly: true,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: genderController,
                  label: "Gender",
                  hint: "Select Gender",
                  groupValue: gender,
                  onChanged: (value) {
                    setState(() {
                      gender = value!;
                      genderController.text = gender;
                    });
                  },
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  obscureText: _isObscured,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Checkbox(
                    value: _showPassword,
                    onChanged: (bool? value) {
                      setState(() {
                        _showPassword = value ?? false;
                        _isObscured = !_showPassword;
                      });
                    },
                  ),
                  title: const Text('Show Password'),
                ),
                const Text("Pilih Negara"),
                DropdownButtonFormField<String>(
                  value: _country,
                  items: <String>[
                    'Indonesia',
                    'Malaysia',
                    'Singapore',
                    'Thailand'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Text(value));
                  }).toList(),
                  hint: const Text('Select Country'),
                  onChanged: (String? newValue) {
                    setState(() {
                      _country = newValue;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('I agree to the terms and conditions'),
                  leading: Checkbox(
                    value: _agreedToTerms,
                    onChanged: (bool? value) {
                      setState(() {
                        _agreedToTerms = value ?? false;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      );
                    },
                    child: const Text('Register'),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
