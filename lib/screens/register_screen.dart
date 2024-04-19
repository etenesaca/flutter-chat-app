import 'package:chat/screens/screens.dart';
import 'package:chat/services/services.dart';
import 'package:chat/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/mostrar_alerta.dart';

class RegisterScreen extends StatelessWidget {
  static const routeName = 'Register';
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Logo(
                  title: 'Registro',
                ),
                _Form(),
                Labels(
                  title: '¿Ya tienes cuenta?',
                  subtitle: 'Ingresa ahora',
                  routeName: LoginScreen.routeName,
                ),
                Text('Términos y condiciones de uso',
                    style: TextStyle(fontWeight: FontWeight.w200)),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form({super.key});

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AuthService authService =
        Provider.of<AuthService>(context, listen: true);
    final SocketService socketService =
        Provider.of<SocketService>(context, listen: true);

    return Container(
      margin: const EdgeInsets.only(top: 50),
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.perm_identity,
            placeholder: 'Nombre',
            keyboardType: TextInputType.text,
            textController: nameCtrl,
          ),
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Email',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Password',
            textController: passCtrl,
            isPassword: true,
          ),
          // TODO: Crear boton
          BotonAzul(
            onPressed: authService.autenticando
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    bool RegisterOk = await authService.newUser(
                        nameCtrl.text, emailCtrl.text, passCtrl.text);
                    if (RegisterOk) {
                      socketService.connect();
                      mostrarAlerta(context, 'Usuario creado correctamente',
                          authService.usuario!.nombre);
                      Navigator.of(context)
                          .pushReplacementNamed(LoginScreen.routeName);
                    } else {
                      mostrarAlerta(
                          context, 'Ups!', authService.registerUserProblems);
                    }
                  },
            text: 'Crear cuenta',
          )
        ],
      ),
    );
  }
}
