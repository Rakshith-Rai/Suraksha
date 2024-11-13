import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Women's Safety Guide"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            // General Safety Tips Card
            InfoCard(
              title: "General Safety Tips",
              description:
              "Discover essential tips to stay safe while commuting, at home, and in public spaces. Learn how to trust your instincts and protect yourself in any situation.",
              icon: Icons.security,
              onTap: () {
                _showDetailedTips(context, "General Safety Tips", [
                  "1. Be aware of your surroundings.",
                  "2. Avoid using headphones in unfamiliar areas.",
                  "3. Trust your instincts and leave any situation that feels off.",
                  "4. Share your location with a trusted friend or family.",
                  "5. Learn how to use safety apps on your phone."
                ]);
              },
            ),
            SizedBox(height: 16),

            // Emergency Contact Setup Card
            InfoCard(
              title: "Emergency Contacts",
              description:
              "Set up your emergency contacts who can receive alerts if you are in danger. Find out how to send alerts with your location instantly.",
              icon: Icons.contact_phone,
              onTap: () {
                _showDetailedTips(context, "Emergency Contact Setup", [
                  "1. Add trusted contacts to your phone’s emergency contact list.",
                  "2. Use safety apps that allow quick message sending with your GPS location.",
                  "3. Set up speed-dial for emergency numbers.",
                  "4. Share your live location with friends and family when in unfamiliar areas."
                ]);
              },
            ),
            SizedBox(height: 16),

            // Self-Defense Tips Card
            InfoCard(
              title: "Self-Defense Techniques",
              description:
              "Learn effective self-defense techniques that can be used in case of an emergency. Discover basic moves that everyone should know.",
              icon: Icons.fitness_center,
              onTap: () {
                _showDetailedTips(context, "Self-Defense Techniques", [
                  "1. Focus on weak points like the eyes, nose, and groin.",
                  "2. Use simple moves like palm strikes and knee kicks.",
                  "3. Carry a self-defense tool, like pepper spray or a personal alarm.",
                  "4. Take a basic self-defense class for more confidence."
                ]);
              },
            ),
            SizedBox(height: 16),

            // Ride Safety Card
            InfoCard(
              title: "Ride Safety Tips",
              description:
              "Stay safe when using public transportation or ride-hailing services like Uber. Learn what to look out for and how to ensure your safety.",
              icon: Icons.directions_car,
              onTap: () {
                _showDetailedTips(context, "Ride Safety Tips", [
                  "1. Verify the driver's identity before getting into the vehicle.",
                  "2. Share your ride details with a friend or family member.",
                  "3. Sit in the back seat and keep the doors locked.",
                  "4. Stay alert and avoid giving away personal information.",
                  "5. End the ride and call for help if something feels wrong."
                ]);
              },
            ),
            SizedBox(height: 16),

            // Digital Safety Tips Card
            InfoCard(
              title: "Digital Safety",
              description:
              "Protect your privacy and stay secure online. Learn how to safeguard your personal information, social media accounts, and devices.",
              icon: Icons.security_outlined,
              onTap: () {
                _showDetailedTips(context, "Digital Safety", [
                  "1. Use strong passwords and enable two-factor authentication.",
                  "2. Avoid sharing personal details on social media.",
                  "3. Be cautious when accepting friend requests from strangers.",
                  "4. Regularly update your device's security settings.",
                  "5. Use encrypted messaging apps to ensure privacy."
                ]);
              },
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Function to show detailed tips in a dialog
  void _showDetailedTips(BuildContext context, String title, List<String> tips) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: tips.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(tips[index]),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }
}

// Custom Card Widget for Information Display
class InfoCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const InfoCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.pinkAccent),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
