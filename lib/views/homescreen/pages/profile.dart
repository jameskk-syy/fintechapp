import 'package:flutter/material.dart';
import 'package:saccoapp/core/constants/theme.dart';
import 'package:saccoapp/core/httpInterceptor/shared_data.dart';
import 'package:saccoapp/views/homescreen/home_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "";
  String username ="";
  String phone = "";
  String nationalId = "";
  String email = "";

  @override
  void initState() {
    super.initState();
    logUserData();
  }

  Future<void> logUserData() async {
    final userData = await UserData.getUserData();
    setState(() {
      name = userData['name'] ?? '';
      username = userData['username'] ?? '';
      phone = userData['phoneNumber'] ?? '';
      nationalId = userData['nationalId'] ?? '';
      email = userData['email'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Home()),
            );
          },
        ),
        backgroundColor: greenColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Card(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Center(
                  child: Column(
                    children: const [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage("assets/user.png"),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Change your profile picture',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(thickness: 2),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Profile Information',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                _buildInfoRow(
                  Icons.person,
                  'Name',
                  name.isNotEmpty ? name : 'Loading...',
                ),
                _buildInfoRow(
                  Icons.person,
                  'Username',
                  username.isNotEmpty ? username : 'Loading...',
                ),
                const Divider(thickness: 2),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Personal Information',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                _buildInfoRow(
                  Icons.person,
                  'User ID',
                  nationalId.isNotEmpty ? nationalId : 'Loading...',
                ),
                _buildInfoRow(
                  Icons.email,
                  'E-mail',
                  email.isNotEmpty ? email : 'Loading...',
                ),
                _buildInfoRow(
                  Icons.phone,
                  'Phone Number',
                  phone.isNotEmpty ? phone : 'NA'
                ),
                _buildInfoRow(Icons.person, 'Gender', 'NA'), // Placeholder
                _buildInfoRow(
                  Icons.calendar_today,
                  'Date of Birth',
                  'NA',
                ), // Placeholder
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: greenColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: greyColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
