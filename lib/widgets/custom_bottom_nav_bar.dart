import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chatear_app/global/constants.dart';

import '../services/auth.dart';
import '../services/socket_service.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final soketService = Provider.of<SocketService>(context);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: 70,
        decoration: customShape,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavBarButton(
              onPressed: (){},
              icon: Icons.messenger_rounded
              ),
            _NavBarButton(
              onPressed: (){},
              icon: Icons.camera_alt_outlined
              ),
            _NavBarButton(
              onPressed: (){
                soketService.disconnect();
                Navigator.pushReplacementNamed(context, 'login');
                AuthService.deleteToken();
              },
              icon: Icons.exit_to_app
              ),
          ],
        ),
      ),
    );
  }
}

class _NavBarButton extends StatefulWidget {
  final IconData icon;
  final Function()? onPressed;

  const _NavBarButton({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<_NavBarButton> createState() => _NavBarButtonState();
}

class _NavBarButtonState extends State<_NavBarButton> {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: customShape,
      child: IconButton(
        color: customOrange,
        icon: Icon(widget.icon),
        onPressed: widget.onPressed,
      ),
    );
  }
}
