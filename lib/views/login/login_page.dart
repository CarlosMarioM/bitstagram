import 'package:bitstagram/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:pixelarticons/pixel.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../widgets/appbart.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const route = "/login";
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showPassword = false;
  late final TextEditingController emailController, passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: normalAppbar,
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 42),
              const Flexible(
                child: Text(
                  "Hello there, let´s bit together!",
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.clip,
                ),
              ),
              const Spacer(),
              const SizedBox(height: 24),
              Center(
                child: SizedBox(
                  width: 480,
                  child: TextFormField(
                    controller: emailController,
                    validator: validateEmail,
                    decoration: const InputDecoration(
                        label: Text(
                      "EMAIL",
                      style: TextStyle(letterSpacing: 2),
                    )),
                    cursorColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: SizedBox(
                  width: 480,
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: !showPassword,
                    cursorColor: Colors.white,
                    validator: (value) {
                      if (value?.isNotEmpty ?? false) {
                        if (value!.length >= 6) {
                          return null;
                        }
                      }
                      return "Invalid Password";
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      label: const Text(
                        "PASSWORD",
                        style: TextStyle(letterSpacing: 2),
                      ),
                      suffixIcon: IconButton(
                          onPressed: () =>
                              setState(() => showPassword = !showPassword),
                          icon: showPassword
                              ? const Icon(Pixel.eyeclosed)
                              : const Icon(Pixel.eye)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 42),
              const Spacer(),
              Center(
                child: SizedBox(
                  width: 480,
                  height: 55,
                  child: OutlinedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await userProvider.login(
                          email: emailController.text,
                          password: passwordController.text,
                          errorCallback: (message) =>
                              WidgetsBinding.instance.addPostFrameCallback(
                            (_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    message,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "You need to put your credentials",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text("Login"),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: SizedBox(
                  width: 320,
                  height: 55,
                  child: TextButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await userProvider.createUser(
                          user: User(
                            email: emailController.text,
                            password: passwordController.text,
                          ),
                          errorCallback: (message) =>
                              ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                message,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "You need to fill the data",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "Or create an account",
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return value!.isNotEmpty && !regex.hasMatch(value)
        ? 'Enter a valid email address'
        : null;
  }
}
