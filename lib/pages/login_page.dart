import 'package:chatear_app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chatear_app/services/auth.dart';

import 'package:chatear_app/helpers/show_alert.dart';

import 'package:chatear_app/widgets/custom_elevated_btn.dart';
import 'package:chatear_app/widgets/custom_input.dart';
import 'package:chatear_app/widgets/custom_logo.dart';
import 'package:chatear_app/widgets/labels.dart';

import 'package:chatear_app/global/constants.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Logo(title: 'Welcome,', subTitle: 'sign in to continue',),
                  _Form(),
                  const Labels(route: 'register', title: 'New Member?', buttonTxt: 'Sign Up Now!'),
                  const SizedBox(height: 5)
                ],
              ),
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  // _Form({Key? key}) : super(key: key);
  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    
    final authService = Provider.of<AuthService>(context);
    final soketService = Provider.of<SocketService>(context);


    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.mail_outline,
            placeHolder: 'Email',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(//boton azul
            icon: Icons.lock_clock_outlined,
            placeHolder: 'Password',
            textController: passCtrl,
            isPassword: true,
          ),
          ElevatedBtnBlue(btnName: 'Sign in', onPressed: authService.authenticating ? null : () async{

            FocusScope.of(context).unfocus();

            final loginOk = await authService.login(emailCtrl.text.trim(), passCtrl.text.trim());

            if (loginOk) {
              soketService.connect();
              Navigator.pushReplacementNamed(context, 'users');
            }else{
              showAlert(context, 'Invalid login', 'Check your credentials again');
            }
          })
        ],
      ),
    );
  }
}
