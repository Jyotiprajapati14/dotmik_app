import 'package:dotmik_app/utils/appColors.dart';
import 'package:flutter/material.dart';

class ChattingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.red,
          elevation: 4,
          leading: GestureDetector(
            onTap: () {},
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Image.asset(
                  'assets/intro/back.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          title: Center(
            child: Row(
              children: [
                Text(
                  'Customer Executive',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                    height: 0,
                    letterSpacing: 0.48,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {},
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Image.asset(
                    'assets/intro/bell.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: ChatBody(),
      ),
    );
  }
}

class ChatBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(8.0),
            children: [
              ChatMessage(
                text: 'Hello!',
                isSentByMe: false,
                userProfileImageUrl: 'assets/intro/image 128.png',
              ),
              ChatMessage(
                text: 'Hi there!',
                isSentByMe: true,
                userProfileImageUrl: 'assets/intro/image 128.png',
              ),
              // Add more messages as needed
            ],
          ),
        ),
        ChatInput(),
      ],
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isSentByMe;
  final String userProfileImageUrl;

  const ChatMessage({
    Key? key,
    required this.text,
    required this.isSentByMe,
    required this.userProfileImageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        isSentByMe
            ? SizedBox()
            : CircleAvatar(backgroundImage: AssetImage(userProfileImageUrl)),
        Container(
          margin: EdgeInsets.symmetric(vertical: 4.0),
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: isSentByMe
                ? Color.fromARGB(255, 224, 133, 126)
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isSentByMe ? Colors.white : Colors.black,
            ),
          ),
        ),
        isSentByMe
            ? CircleAvatar(backgroundImage: AssetImage(userProfileImageUrl))
            : SizedBox(),
      ],
    );
  }
}

class ChatInput extends StatefulWidget {
  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.grey[200],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.image),
                    onPressed: () {
                      // Implement logic to select and send image
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 15.0),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.keyboard_voice),
                    onPressed: () {
                      // Implement logic to record and send voice note
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 8.0),
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(30.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(30.0),
              onTap: () {
                // Send message logic
                String message = _controller.text;
                // Implement logic to send the message
                _controller.clear();
              },
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.send,
                  color: AppColors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
