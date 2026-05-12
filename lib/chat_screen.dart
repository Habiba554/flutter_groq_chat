import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_with_ai/send_message_request.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = [];
  final SendMessageRequest api = SendMessageRequest();
  Future<void> sendMessage(String text) async {
    setState(() {
      messages.add({"role": "user", "content": text});
    });

    try {
      String reply = await api.send(messages);

      setState(() {
        messages.add({"role": "assistant", "content": reply});
      });
    } catch (e) {
      setState(() {
        messages.add({
          "role": "assistant",
          "content": "Exception: $e"
        });
      });
    }
  }



  Widget buildMessage(Map<String, String> msg) {
    bool isUser = msg["role"] == "user";
    return Container(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          msg["content"] ?? "",
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chatbot")),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: messages.map(buildMessage).toList(),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey),
                            borderRadius: BorderRadius.all(Radius.circular(12.0),)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(12.0),)
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        sendMessage(_controller.text);
                        _controller.clear();
                      }
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}