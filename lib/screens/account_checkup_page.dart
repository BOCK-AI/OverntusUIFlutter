import 'package:flutter/material.dart';

class AccountCheckupPage extends StatefulWidget {
  final String userName;
  final String email;
  final String phoneNumber;

  const AccountCheckupPage({
    Key? key,
    required this.userName,
    required this.email,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<AccountCheckupPage> createState() => _AccountCheckupPageState();
}

class _AccountCheckupPageState extends State<AccountCheckupPage> {
  bool passkeyPopup = false;
  bool verificationPopup = false;
  bool passkeyDone = false;
  bool verificationDone = false;

  void showPasskeyDialog() {
    setState(() {
      passkeyPopup = true;
    });
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Create a passkey"),
        content: Text("Use passkeys for an easier, faster and more secure sign in to your Uber account"),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                passkeyDone = true;
                passkeyPopup = false;
              });
              Navigator.pop(context);
            },
            child: Text("Create"),
          ),
        ],
      ),
    );
  }

  void showVerificationDialog() {
    setState(() {
      verificationPopup = true;
    });
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Turn on 2-step verification"),
        content: Text("Add an extra layer of security to your account with 2-step verification"),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                verificationDone = true;
                verificationPopup = false;
              });
              Navigator.pop(context);
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Uber Account"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            "Account checkup",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          SizedBox(height: 8),
          Text(
            "You have recommended account actions to improve your Uber experience and enhance your account security.",
            style: TextStyle(color: Colors.black87),
          ),
          SizedBox(height: 24),
          Card(
            child: ExpansionTile(
              initiallyExpanded: !passkeyDone,
              title: Row(
                children: [
                  Icon(Icons.key, color: Colors.blue),
                  SizedBox(width: 8),
                  Text("Passkeys"),
                  if (passkeyDone)
                    Icon(Icons.check_circle, color: Colors.green, size: 18),
                ],
              ),
              subtitle: Text("Create a passkey"),
              children: [
                ListTile(
                  title: Text("Create a passkey"),
                  subtitle: Text("Use passkeys for an easier, faster and more secure sign in to your Uber account"),
                  trailing: ElevatedButton(
                    onPressed: passkeyDone ? null : showPasskeyDialog,
                    child: Text("Create"),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Card(
            child: ExpansionTile(
              initiallyExpanded: !verificationDone,
              title: Row(
                children: [
                  Icon(Icons.verified_user, color: Colors.blue),
                  SizedBox(width: 8),
                  Text("2-step verification"),
                  if (verificationDone)
                    Icon(Icons.check_circle, color: Colors.green, size: 18),
                ],
              ),
              subtitle: Text("Turn on 2-step verification"),
              children: [
                ListTile(
                  title: Text("Turn on 2-step verification"),
                  subtitle: Text("Add an extra layer of security to your account with 2-step verification"),
                  trailing: ElevatedButton(
                    onPressed: verificationDone ? null : showVerificationDialog,
                    child: Text("Add"),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          ListTile(
            leading: Icon(Icons.phone, color: Colors.green),
            title: Text("Phone number"),
            subtitle: Text(widget.phoneNumber),
            trailing: Icon(Icons.check_circle, color: Colors.green),
          ),
          ListTile(
            leading: Icon(Icons.email, color: Colors.green),
            title: Text("Email"),
            subtitle: Text(widget.email),
            trailing: Icon(Icons.check_circle, color: Colors.green),
          ),
        ],
      ),
    );
  }
}
