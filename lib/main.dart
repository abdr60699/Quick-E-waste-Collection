import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
// Ensure this file is generated using FlutterFire CLI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  MyApp({super.key});

  void scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quick E-waste Collections',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green[700],
        fontFamily: 'Ubuntu',
      ),
      home: HomePage(
        scrollController: _scrollController,
        scrollToSection: scrollToSection,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final ScrollController scrollController;
  final Function(GlobalKey) scrollToSection;

  const HomePage({
    super.key,
    required this.scrollController,
    required this.scrollToSection,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey heroKey = GlobalKey();
  final GlobalKey collectKey = GlobalKey();
  final GlobalKey howItWorksKey = GlobalKey();
  final GlobalKey whyUsKey = GlobalKey();
  final GlobalKey contactKey = GlobalKey();
  final GlobalKey aboutKey = GlobalKey();

  // Form controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController itemController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('pickup_requests').add({
          'name': nameController.text,
          'phone': phoneController.text,
          'email': emailController.text,
          'address': addressController.text,
          'item_description': itemController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request submitted successfully!')),
        );

        // Clear the form
        nameController.clear();
        phoneController.clear();
        emailController.clear();
        addressController.clear();
        itemController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit request.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              CircleAvatar(
                child: Image.asset('asset/images/icon.png'),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                'Quick E-waste Collections',
                style: TextStyle(
                    color: Colors.white, fontSize: isMobile ? 15 : null),
              ),
            ],
          ),
          backgroundColor: Colors.green[800],
          actions: isMobile // Conditionally show actions based on screen size
              ? [
                  // Mobile View: WhatsApp Icon + PopupMenuButton
                  IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.whatsapp,
                      color: Colors.white,
                    ),
                    tooltip:
                        'Contact on WhatsApp', // Add tooltip for accessibility
                    onPressed: () => _launchUrl('https://wa.me/919500893174'),
                  ),
                  PopupMenuButton<GlobalKey>(
                    icon: const Icon(Icons.menu,
                        color: Colors.white), // Use standard menu icon
                    tooltip: 'Navigation Menu',
                    onSelected: (GlobalKey key) {
                      // Action when a menu item is selected
                      widget.scrollToSection(key);
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<GlobalKey>>[
                      PopupMenuItem<GlobalKey>(
                        value: collectKey, // Use the GlobalKey as the value
                        child: const Text('What We Collect'),
                      ),
                      PopupMenuItem<GlobalKey>(
                        value: howItWorksKey,
                        child: const Text('How It Works'),
                      ),
                      PopupMenuItem<GlobalKey>(
                        value: whyUsKey,
                        child: const Text('Why Choose Us'),
                      ),
                      PopupMenuItem<GlobalKey>(
                        value: contactKey,
                        child: const Text('Contact'),
                      ),
                    ],
                  ),
                ]
              : [
                  TextButton(
                    onPressed: () => widget.scrollToSection(collectKey),
                    child: const Text('What We Collect',
                        style: TextStyle(color: Colors.white)),
                  ),
                  TextButton(
                    onPressed: () => widget.scrollToSection(howItWorksKey),
                    child: const Text('How It Works',
                        style: TextStyle(color: Colors.white)),
                  ),
                  TextButton(
                    onPressed: () => widget.scrollToSection(whyUsKey),
                    child: const Text('Why Choose Us',
                        style: TextStyle(color: Colors.white)),
                  ),
                  TextButton(
                    onPressed: () => widget.scrollToSection(contactKey),
                    child: const Text('Contact',
                        style: TextStyle(color: Colors.white)),
                  ),
                  IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.whatsapp,
                      color: Colors.white,
                    ),
                    onPressed: () => _launchUrl('https://wa.me/919500893174'),
                  )
                ],
        ),
        body: SingleChildScrollView(
            controller: widget.scrollController,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 350,
                    key: heroKey,
                    child: Image.asset(
                      'asset/images/banner.jpg',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Old Devices, New Future. Recycle Smart',
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.green[700],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Easy and Eco-Friendly Recycling',
                        style:
                            TextStyle(color: Colors.green[700], fontSize: 20),
                      ),
                      const SizedBox(height: 20),
                  
                    ],
                  ),
                ],
              ),

              // What We Collect Section
              Container(
                key: collectKey,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'What We Collect',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: [
                        _buildCollectItem('Laptops', FontAwesomeIcons.laptop),
                        _buildCollectItem('Mobiles', FontAwesomeIcons.mobile),
                        _buildCollectItem('TVs', FontAwesomeIcons.tv),
                        _buildCollectItem('Printers', FontAwesomeIcons.print),
                        _buildCollectItem(
                            'Batteries', FontAwesomeIcons.batteryFull),
                        _buildCollectItem('Cables', FontAwesomeIcons.cableCar),
                        _buildCollectItem(
                            'Small Appliances', FontAwesomeIcons.blender),
                        _buildCollectItem('Others', Icons.settings),
                      ],
                    ),
                  ],
                ),
              ),

              Container(
                key: howItWorksKey,
                padding: const EdgeInsets.all(20),
                color: Colors.grey[100],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'How It Works',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'We’ve made e-waste recycling simple and hassle-free. Here’s how the process works:',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 30),

                    // Horizontal Stepper
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildHorizontalStep(
                            icon: FontAwesomeIcons.calendarCheck,
                            title: 'Schedule Pickup',
                            description: 'Fill our form or contact us.',
                          ),
                          _buildStepConnector(),
                          _buildHorizontalStep(
                            icon: FontAwesomeIcons.truck,
                            title: 'We Collect',
                            description: 'We pick it up on time.',
                          ),
                          _buildStepConnector(),
                          _buildHorizontalStep(
                            icon: FontAwesomeIcons.recycle,
                            title: 'Recycle Safely',
                            description: 'Secure and eco-friendly.',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Why Choose Us Section
              Container(
                key: whyUsKey,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Why Choose Us',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: [
                        _buildWhyUsCard('Custom Scheduling', Icons.person),
                        _buildWhyUsCard(
                            'Best In Market Price', FontAwesomeIcons.moneyBill),
                        _buildWhyUsCard('Eco-Friendly', FontAwesomeIcons.leaf),
                        _buildWhyUsCard(
                            'Local Service', FontAwesomeIcons.mapMarkerAlt),
                      ],
                    ),
                  ],
                ),
              ),

              // Contact Section
              Container(
                key: contactKey,
                padding: const EdgeInsets.all(20),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Schedule a Pickup',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                        'Fill out the form below and we’ll get in touch with you soon!'),
                    const SizedBox(height: 20),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: _buildTextField(
                                        nameController, 'Name')),
                                const SizedBox(width: 10),
                                Expanded(
                                    child: _buildTextField(
                                        phoneController, 'Phone')),
                                const SizedBox(width: 10),
                                Expanded(
                                    child: _buildTextField(
                                        emailController, 'Email')),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                      addressController, 'Address'),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _buildTextField(
                                      itemController, 'Item Description'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[700],
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Submit Request'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      children: [
                        Icon(FontAwesomeIcons.phone, color: Colors.green),
                        SizedBox(width: 10),
                        Text('+91 9500893174'),
                      ],
                    ),
                  ],
                ),
              ),

              // About Us Section
              Container(
                key: aboutKey,
                padding: const EdgeInsets.all(20),
                child: const Column(
                  children: [
                    Text(
                      'About Us',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'QuickE-wasteCollections is committed to helping Coimbatore dispose of electronic waste safely and responsibly. '
                      'Our mission is to make recycling accessible, secure, and eco-friendly for everyone.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    // Container(
                    //   width: 200,
                    //   height: 200,
                    //   color: Colors.grey[300], // 📷 Placeholder for company image
                    //   child: const Center(child: Text('Company Photo Here')),
                    // ),
                  ],
                ),
              ),

              // Footer
              const FooterSection(),
            ])));
  }

  Widget _buildHorizontalStep({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green[700],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 8),
        Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black)),
        const SizedBox(height: 4),
        SizedBox(
          width: 100,
          child: Text(
            description,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildStepConnector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: 40,
      height: 2,
      color: Colors.green,
    );
  }

  Widget _buildStepWithLine({
    required IconData icon,
    required String title,
    required String description,
    required bool showLine,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[700],
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            if (showLine)
              Container(
                width: 2,
                height: 50,
                color: Colors.green,
              ),
          ],
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Text(description),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      validator: (value) =>
          value == null || value.isEmpty ? 'Enter $label' : null,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildCollectItem(String label, IconData icon) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          color: Colors.grey[300], // 📷 Image placeholder
          child: Icon(icon, size: 40, color: Colors.green[800]),
        ),
        const SizedBox(height: 10),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildHowItWorksStep(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.green[700]),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildWhyUsCard(String text, IconData icon) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(icon, size: 30, color: Colors.green[700]),
          const SizedBox(height: 10),
          Text(text, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

// FOOTER SECTION
class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: Colors.green[700],
      child: const Column(
        children: [
          Text(
            '© 2025 Quick E-waste Collections.',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 10),
          Text('Privacy Policy | Terms of Service',
              style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
