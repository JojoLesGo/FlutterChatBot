import 'package:flutter/material.dart';
import 'package:chat_bot/capitals_message.dart';

import 'package:dialog_flowtter/dialog_flowtter.dart';

class CapitalsChatBot extends StatefulWidget {
  const CapitalsChatBot({required Key key, required this.title}) : super(key: key);

  final String title;

  @override
  _CapitalsChatBotState createState() => _CapitalsChatBotState();
}

class _CapitalsChatBotState extends State<CapitalsChatBot> {
  final List<Capitals> messageList = <Capitals>[];
  final TextEditingController _textController = TextEditingController();

  Widget _query(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Padding(
        padding: const EdgeInsets.only(left:10.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _submit,
                decoration: const InputDecoration.collapsed(hintText: "Send a message"),
              )
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue,),
                  onPressed: () => _submit(_textController.text)),
            ),
          ],
        ),
      ),
    );
  }

  void agentResponse(query) async {
    _textController.clear();
    DialogAuthCredentials googleAuth =
    await DialogAuthCredentials.fromFile("assets/credentials.json");
    final DialogFlowtter instance = DialogFlowtter(
      credentials: googleAuth,
      sessionId: "123",
    );
    final QueryInput queryInput = QueryInput(
      text: TextInput(
        text: query,
        languageCode: 'en',
      ),
    );
    DetectIntentResponse response = await instance.detectIntent(queryInput: queryInput);
    String textResponse = response.text ?? "Chattie has nothing to say";
    Capitals message = Capitals(
      text: textResponse,
      name: "Flutter",
      type: false,
    );
    setState(() {
      messageList.insert(0, message);
    });
  }

  void _submit(String text) {
    _textController.clear();
    Capitals message = Capitals(
      text: text,
      name: "User",
      type: true,
    );
    setState(() {
      messageList.insert(0, message);
    });
    agentResponse(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Flutter Capitals", style: TextStyle(color: Colors.blue),),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(children: <Widget>[
        Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true, //To keep the latest messages at the bottom
              itemBuilder: (_, int index) => messageList[index],
              itemCount: messageList.length,
            )),
        _query(context),
      ]),
    );
  }
}
