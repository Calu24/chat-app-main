import 'package:chatear_app/services/chat_service.dart';
import 'package:chatear_app/services/users_service.dart';
import 'package:flutter/material.dart';

import 'package:chatear_app/models/users.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:chatear_app/services/auth.dart';

import '../services/socket_service.dart';

// ignore: use_key_in_widget_constructors
class UsersPage extends StatefulWidget {
  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {

  final userService = UsersService();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<User> users = [];

  // final users = [
  //   User(online: true, email: 'sonic1@asd.com', name: 'Esteban', uid: '1'),
  //   User(online: false, email: 'sonic2@asd.com', name: 'Esty', uid: '2'),
  //   User(online: true, email: 'sonic3@asd.com', name: 'quito', uid: '3'),
  // ];

  @override
  void initState() {
    _loadUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.user;

    final soketService = Provider.of<SocketService>(context);

    return Scaffold(
        appBar: AppBar(
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: (soketService.serverStatus == ServerStatus.Online)
                  ? Icon(
                      Icons.check_circle,
                      color: Colors.blue[400],
                    )
                  : const Icon(
                      Icons.offline_bolt,
                      color: Colors.red,
                    ),
            )
          ],
          title: Text(
            user?.name ?? '-',
            style: const TextStyle(color: Colors.black45),
          ),
          elevation: 1,
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                soketService.disconnect();
                Navigator.pushReplacementNamed(context, 'login');
                AuthService.deleteToken();
              },
              icon: const Icon(Icons.exit_to_app, color: Colors.black)),
        ),
        body: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          onRefresh: _loadUsers,
          header: WaterDropHeader(
              complete: Icon(Icons.check, color: Colors.blue[400]),
              waterDropColor: Colors.blue),
          child: _listViewUsers(),
        ));
  }

  ListView _listViewUsers() {
    return ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_, i) => _userListTile(users[i]),
        separatorBuilder: (_, i) => const Divider(),
        itemCount: users.length);
  }

  ListTile _userListTile(User user) {
    return ListTile(
      title: Text(user.name),
      leading: CircleAvatar(
        child: Text(user.name.substring(0, 2)),
        backgroundColor: Colors.blue[100],
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: user.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)),
      ),
      onTap: (){
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.userDestination = user;

        Navigator.pushNamed(context, 'chat');
      },
    );
  }

  _loadUsers() async {

    users = await userService.getUsers();
    setState(() {});

    // await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }
}
