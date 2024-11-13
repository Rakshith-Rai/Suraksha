import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

class Rating extends StatefulWidget {
  const Rating({super.key});

  @override
  State<Rating> createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  TextEditingController _userInput = TextEditingController();

  // Ensure this API key is valid and properly set up.
  static const apiKey = "AIzaSyAj4qH55FBQgOrvLiUKbT7TQLzyc2Z0-2s";

  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

  final List<Message> _messages = [];

  Future<void> sendMessage() async {
    final message = _userInput.text;
    if (message.isEmpty) {
      return; // Don't send empty messages
    }

    // Add user message to the chat
    setState(() {
      _messages.add(Message(isUser: true, message: message, date: DateTime.now()));
    });

    _userInput.clear(); // Clear the input field after sending

    try {
      // Prepare content for API
      final content = [Content.text(message)];
      final response = await model.generateContent(content);

      // Add AI-generated message to the chat
      setState(() {
        _messages.add(Message(
            isUser: false, message: response.text ?? "No response", date: DateTime.now()));
      });
    } catch (error) {
      // Handle any errors
      setState(() {
        _messages.add(Message(
            isUser: false, message: "Error: $error", date: DateTime.now()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suraksha AI'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Container(
        color: Colors.white, // Simple white background for clean look
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Chat messages
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Messages(
                    isUser: message.isUser,
                    message: message.message,
                    date: DateFormat('HH:mm').format(message.date),
                  );
                },
              ),
            ),
            // Input and send button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 15,
                    child: TextFormField(
                      style: TextStyle(color: Colors.black),
                      controller: _userInput,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200, // Light background for the input
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        labelText: 'Enter Your Message',
                        labelStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    padding: EdgeInsets.all(12),
                    iconSize: 30,
                    color: Colors.pinkAccent,
                    onPressed: sendMessage,
                    icon: Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Message {
  final bool isUser;
  final String message;
  final DateTime date;

  Message({required this.isUser, required this.message, required this.date});
}

class Messages extends StatelessWidget {
  final bool isUser;
  final String message;
  final String date;

  const Messages({
    super.key,
    required this.isUser,
    required this.message,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(vertical: 10).copyWith(
        left: isUser ? 100 : 10,
        right: isUser ? 10 : 100,
      ),
      decoration: BoxDecoration(
        color: isUser ? Colors.lightBlueAccent.shade100 : Colors.grey.shade300,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomLeft: isUser ? Radius.circular(10) : Radius.zero,
          topRight: Radius.circular(10),
          bottomRight: isUser ? Radius.zero : Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: isUser ? Colors.white : Colors.black,
            ),
          ),
          Text(
            date,
            style: TextStyle(
              fontSize: 10,
              color: isUser ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
