import 'package:flutter/material.dart';
import 'package:orventus_web/screens/PasskeyPage.dart';
import 'package:orventus_web/screens/PasswordPage.dart';
import 'package:orventus_web/screens/RecoveryPhonePage.dart';
import 'account_checkup_page.dart';

class AccountDetailsPage extends StatefulWidget {
  final String userName;
  final String email;
  final String phoneNumber;
  final void Function()? onBack;

  const AccountDetailsPage({
    super.key,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    this.onBack,
  });

  @override
  State<AccountDetailsPage> createState() => AccountDetailsPageState();
}

class AccountDetailsPageState extends State<AccountDetailsPage> with SingleTickerProviderStateMixin {
  late TabController tabController;
  String name = "";
  String gender = "";
  String email = "";
  String phone = "";
  List<String> genders = [
    "Woman",
    "Man",
    "Transgender person",
    "None of the above",
    "Remove my gender information"
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    name = widget.userName;
    email = widget.email;
    phone = widget.phoneNumber;
  }

  void showNameDialog() {
    final controller = TextEditingController(text: name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Update your name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() => name = controller.text.trim());
              Navigator.pop(ctx);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void showGenderDialog() {
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) => AlertDialog(
          title: const Text('Choose your gender'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...genders.map((g) => RadioListTile(
                      title: Text(g),
                      value: g,
                      groupValue: gender,
                      onChanged: (val) {
                        setStateDialog(() {
                          gender = g;
                        });
                      },
                    )),
                const Divider(height: 24),
                const Text(
                  "How we use your gender data",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Your gender information is used for safety features, personalization of ads and marketing, and user experience research. It won't be shared with anyone unless you opt in to Women Preferences. You can manage this information in Account settings.",
                  style: TextStyle(fontSize: 13, color: Colors.black87),
                )
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                setState(() {});
                Navigator.pop(ctx);
              },
              child: const Text('Update'),
            )
          ],
        ),
      ),
    );
  }

  void showPhoneDialog() {
    final controller = TextEditingController(text: phone);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Phone number'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "You'll use this phone number to receive important messages and recover your account.",
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Phone number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 8),
            const Text(
              "A verification code will be sent to this number",
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() => phone = controller.text.trim());
              Navigator.pop(ctx);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void showEmailDialog() {
    final controller = TextEditingController(text: email);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Email'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "You'll use this email to receive messages, sign in, and recover your account.",
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 8),
            const Text(
              "A verification code will be sent to this email",
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() => email = controller.text.trim());
              Navigator.pop(ctx);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  Widget buildTabContent(int index) {
    switch (index) {
      case 0: // Home tab
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const CircleAvatar(radius: 36, child: Icon(Icons.person, size: 40)),
            const SizedBox(height: 12),
            Center(
              child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ),
            Center(
              child: Text(email, style: const TextStyle(color: Colors.black54)),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => tabController.animateTo(1),
                    child: Column(
                      children: const [
                        CircleAvatar(radius: 22, child: Icon(Icons.person, size: 24)),
                        SizedBox(height: 6),
                        Text("Personal info", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => tabController.animateTo(3),
                    child: Column(
                      children: const [
                        CircleAvatar(radius: 22, child: Icon(Icons.lock, size: 24)),
                        SizedBox(height: 6),
                        Text("Privacy & Data", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => tabController.animateTo(2),
                    child: Column(
                      children: const [
                        CircleAvatar(radius: 22, child: Icon(Icons.security, size: 24)),
                        SizedBox(height: 6),
                        Text("Security", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text("Suggestions", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.badge),
                title: const Text("Complete your account checkup"),
                subtitle: const Text("Complete your account checkup to make Orventus work better for you and keep you secure."),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AccountCheckupPage(userName: name, email: email, phoneNumber: phone),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                  child: Text("Begin checkup"),
                ),
              ),
            ),
          ],
        );
      case 1: // Personal info tab
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const ListTile(
              leading: CircleAvatar(child: Icon(Icons.person)),
              title: Text("Personal info", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const Divider(),
            AccountArrowTile(title: "Name", subtitle: name, onTap: showNameDialog),
            AccountArrowTile(
                title: "Gender", subtitle: gender.isEmpty ? "Add your gender" : gender, onTap: showGenderDialog),
            AccountArrowTile(title: "Phone number", subtitle: phone, onTap: showPhoneDialog),
            AccountArrowTile(title: "Email", subtitle: email, onTap: showEmailDialog),
            AccountArrowTile(title: "Language", subtitle: "Update device language", onTap: () {}),
          ],
        );
      case 2: // Security tab
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const ListTile(
              leading: Icon(Icons.security),
              title: Text("Security", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const Divider(),
            AccountArrowTile(title: "Password", onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => PasswordPage()));
            }),
            AccountArrowTile(title: "Passkeys", subtitle: "Passkeys are easier and more secure than passwords.", onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const PasskeyPage()));
            }),
            AccountArrowTile(
                title: "Authenticator app",
                subtitle: "Set up your authenticator app to add an extra layer of security.",
                onTap: () {}),
            AccountArrowTile(
                title: "2-step verification",
                subtitle: "Add additional security to your account with 2-step verification.",
                onTap: () {}),
            AccountArrowTile(
                title: "Recovery phone",
                subtitle: "Add a backup phone number to access your account",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => RecoveryPhonePage(phone)));
                }),
            const SizedBox(height: 16),
            const Text("Connected social apps", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("You've allowed these social apps to sign in to your Orventus account.",
                style: TextStyle(color: Colors.black54)),
          ],
        );
      case 3: // Privacy & Data tab
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const ListTile(
              leading: Icon(Icons.lock),
              title: Text("Privacy & Data", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const Divider(),
            AccountArrowTile(
                title: "Privacy Center",
                subtitle: "Take control of your privacy and learn how we protect it.",
                onTap: () {}),
            const SizedBox(height: 24),
            const Text("Third-party apps with account access", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Once you allow access to third party apps, you’ll see them here. Learn more",
                style: TextStyle(color: Colors.black54)),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: widget.onBack),
        title: const Text("Orventus Account", style: TextStyle(color: Colors.black)),
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(child: Text("Home", style: TextStyle(color: Colors.black))),
            Tab(child: Text("Personal info", style: TextStyle(color: Colors.black))),
            Tab(child: Text("Security", style: TextStyle(color: Colors.black))),
            Tab(child: Text("Privacy & Data", style: TextStyle(color: Colors.black))),
          ],
          indicatorColor: Colors.black,
          indicatorWeight: 3,
          isScrollable: false,
        ),
      ),
      body: TabBarView(controller: tabController, children: List.generate(4, buildTabContent)),
    );
  }
}






class AccountIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const AccountIconButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(child: Icon(icon)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class AccountArrowTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const AccountArrowTile({
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!, style: const TextStyle(color: Colors.black54)) : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
      onTap: onTap,
    );
  }
}
