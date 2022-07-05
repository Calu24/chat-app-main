import 'package:chatear_app/helpers/show_alert.dart';
import 'package:chatear_app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chatear_app/services/auth.dart';
import 'package:chatear_app/widgets/custom_elevated_btn.dart';
import 'package:chatear_app/widgets/custom_input.dart';
import 'package:chatear_app/widgets/custom_logo.dart';
import 'package:chatear_app/widgets/labels.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffF2F2F2),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Logo(
                    title: 'Check in',
                    subTitle: '',
                  ),
                  _Form(),
                  const Labels(
                      route: 'Create Account',
                      title: '¿Ya tienes cuenta?',
                      buttonTxt: 'Ingrese ahora!'),
                  const Text(
                    'Términos y condiciones de uso',
                    style: TextStyle(fontWeight: FontWeight.w200),
                  )
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
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.perm_identity,
            placeHolder: 'Name',
            textController: nameCtrl,
          ),
          CustomInput(
            icon: Icons.mail_outline,
            placeHolder: 'Email',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_clock_outlined,
            placeHolder: 'Password',
            textController: passCtrl,
            isPassword: true,
          ),
          ElevatedBtnBlue(
              btnName: 'Log in',
              onPressed: authService.authenticating ? null : () async {
                final registerOk = await authService.register(nameCtrl.text, emailCtrl.text, passCtrl.text);

                if (registerOk == true) {
                  socketService.connect();
                  Navigator.pushNamed(context, 'users');
                }
                else{
                  showAlert(context, 'Invalid register', registerOk);
                }
              })
        ],
      ),
    );
  }
}
