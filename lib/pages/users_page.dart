import 'package:chatear_app/global/constants.dart';
import 'package:chatear_app/services/chat_service.dart';
import 'package:chatear_app/services/users_service.dart';
import 'package:chatear_app/widgets/custom_bottom_nav_bar.dart';
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
  List<User> usersLocal = []; // variable para no buscar otra vez los usuarios

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

    return SafeArea(
      child: Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true, //hace que el appbar no moleste y deje que el comportamiento del body ocupe toda la pantalla
          bottomNavigationBar: const CustomBottomNavBar(),
          appBar: AppBar(
            toolbarHeight: 65,
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
            title: Row(
              children: [
                _leadingAvatar(user),
                const SizedBox(width: 15),
                const Text('Chats', style: TextStyle(fontWeight: FontWeight.bold),)
              ],
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            // leading: IconButton(
            //     onPressed: () {
            //       soketService.disconnect();
            //       Navigator.pushReplacementNamed(context, 'login');
            //       AuthService.deleteToken();
            //     },
            //     icon: const Icon(Icons.exit_to_app, color: Colors.black)),
          ),
          body: Container(
            padding: const EdgeInsets.only(top: 50),
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                  Color.fromRGBO(60, 64, 73, 1),
                  Color.fromRGBO(25, 28, 37, 1),
                ])),
            child: Column(
              children: [
                _searchUsers(),
                Expanded(
                  child: SmartRefresher(
                    controller: _refreshController,
                    enablePullDown: true,
                    onRefresh: _loadUsers,
                    header: WaterDropHeader(
                        complete: Icon(Icons.check, color: Colors.blue[400]),
                        waterDropColor: Colors.blue),
                    child: _listViewUsers(),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget _searchUsers() {

    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.0),
              borderSide: BorderSide(
                width: 2,
                style: BorderStyle.solid,
                color: Colors.black.withOpacity(0.09),
              ),
            );

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          boxShadow: const [
        BoxShadow(
          blurStyle: BlurStyle.inner,
          color: Color.fromRGBO(38, 45, 53, 1),
          blurRadius: 5,
          // offset: const Offset(-3, -3),
        )]),
        child: TextField(
          textCapitalization: TextCapitalization.sentences,
          cursorColor: customOrange,
          autofocus: false,
          style: const TextStyle( color: Colors.white, fontSize: 15),
          // controller: _searchController,
          onChanged: (value) async{
            users = usersLocal;

            final searchedUser = users.where((u) {
              final uLower = u.name.toLowerCase();
              final searchLower = value.toLowerCase();
              return uLower.contains(searchLower);
            }).toList();

            setState(() {
              users = searchedUser;
            });
          },
          decoration:InputDecoration(
            contentPadding: const EdgeInsets.only(top: 5, left: 20),
            hintText: 'Search',
            hintStyle: const TextStyle(color: Colors.white),
            enabledBorder: outlineInputBorder,
            focusedBorder: outlineInputBorder
          ),
        ),
      ),
    );
  }

  ListView _listViewUsers() {
    return ListView.separated(
        padding: const EdgeInsets.only(top: 0),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_, i) => _userListTile(users[i]),
        separatorBuilder: (_, i) => const Divider(),
        itemCount: users.length);
  }

  ListTile _userListTile(User user) {
    return ListTile(
      title: Text(user.name, style: const TextStyle(color: Colors.white)),
      leading: _leadingAvatar(user),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: user.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)),
      ),
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.userDestination = user;

        Navigator.pushNamed(context, 'chat');
      },
    );
  }

  Container _leadingAvatar(User? user) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.fromRGBO(60, 64, 73, 1),
        Color.fromRGBO(25, 28, 37, 1),
      ]),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            blurStyle: BlurStyle.outer,
            color: Colors.white.withOpacity(0.6),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(1, 3),
          ),
          const BoxShadow(
            color: Colors.black,
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(2, 4),
          ),
        ]
      ),
      child: CircleAvatar(
        child: Text(user?.name.substring(0, 2) ?? '-', style: const TextStyle(color: Colors.white60),),
        backgroundColor: Colors.black12,
      ),
    );
  }

  _loadUsers() async {
    users = await userService.getUsers();
    usersLocal = users;

    setState(() {});

    // await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }
}
