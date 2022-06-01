import 'package:chatear_app/models/messages_response.dart';
import 'package:chatear_app/services/auth.dart';
import 'package:chatear_app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:chatear_app/widgets/chat_message.dart';
import 'package:provider/provider.dart';

import '../services/chat_service.dart';

// ignore: use_key_in_widget_constructors
class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}
class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin{

  final _textController = TextEditingController();
  final _focusNode      = FocusNode();
  final List<ChatMessage> _messages = [];

  bool _isWriting = false;

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;


  @override
  void initState() {
    chatService   = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService   = Provider.of<AuthService>(context, listen: false);

    socketService.socket.on('message-personal', _listenMessage);

    _loadChatHistory(chatService.userDestination.uid);

    super.initState();
  }

  void _loadChatHistory(String userId) async{

    List<Message> chat = await chatService.getChat(userId);

    final history = chat.map((m) => ChatMessage(
      text: m.message,
      uid: m.from, 
      animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 0))..forward()
    ));

    setState(() {
      _messages.insertAll(0, history);
    });

  }


  void _listenMessage(dynamic payload){
    ChatMessage message = ChatMessage(
      text: payload['message'],
      uid: payload['from'],
      animationController: AnimationController(vsync: this, duration: const  Duration(milliseconds: 300)));

    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  }



  @override
  Widget build(BuildContext context) {

    final userDestination = chatService.userDestination;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        title: Column(
          children: [
            CircleAvatar(
              child: Text(userDestination.name.substring(0,2), style: const TextStyle(fontSize: 12)),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            const SizedBox(height: 3),
            Text(userDestination.name,
                style: const TextStyle(color: Colors.black87, fontSize: 12))
          ],
        ),
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (_, i) => _messages[i]),
          ),
          const Divider(height: 1),
          Container(
            color: Colors.white,
            child: _inputChat(),
          )
        ],
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
        child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(children: [Flexible(child: TextField(
        textCapitalization: TextCapitalization.sentences,
        controller: _textController,
        decoration: const InputDecoration.collapsed(hintText: 'Send message'),
        focusNode: _focusNode,
        onSubmitted: (_){},
        onChanged: (String text){
          setState(() {
            if (text.trim().isNotEmpty) {
              _isWriting = true;
            }else{
              _isWriting = false;
            }
          });
        },
      )),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        child: CupertinoButton(
          child: const Text('Send'),
          onPressed: _isWriting ? ()=> _handleSubmit(_textController.text.trim()) : null ,
        ),
      )
      ],),
    ));
  }

  _handleSubmit(String text) {
    _textController.clear();
    _focusNode.requestFocus();
    final newMessages = ChatMessage(text: text, uid: authService.user?.uid ?? '', animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 200)));
    newMessages.animationController.forward(); // Para que la animación se active
    _messages.insert(0, newMessages);

    setState(() {
      _isWriting = false;
    });

    socketService.emit('message-personal',{
      'from': authService.user?.uid,
      'to': chatService.userDestination.uid,
      'message': text
    });
  }

  @override
  void dispose() {
    
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }

    socketService.socket.off('message-personal');

    super.dispose();
  }
}
