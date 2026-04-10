import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ironkey/app_theme.dart';
import 'package:ironkey/passaword_generator.dart';
import 'package:ironkey/password_type_enum.dart';
import 'package:ironkey/pin_password_generator.dart';
import 'package:ironkey/standard_password_generator.dart';

void main() {
  runApp(IronKeyApp());
}

class IronKeyApp extends StatelessWidget {
  const IronKeyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: IronKeyScreen(),
    );
  }
}

class IronKeyScreen extends StatefulWidget {
  const IronKeyScreen({super.key});

  @override
  State<IronKeyScreen> createState() => _IronKeyScreenState();
}

class _IronKeyScreenState extends State<IronKeyScreen> {
  final TextEditingController _passwordController = TextEditingController();

  int maxCharacters = 12;
  bool isEditable = false;

  PasswordTypeEnum passwordTypeSelected = PasswordTypeEnum.pin;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void copyPassword(String password) {
    Clipboard.setData(ClipboardData(text: password));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Senha copiada!')));
  }

  void generatePassword() {
    final PasswordGenerator generator;
      switch(passwordTypeSelected){

         case PasswordTypeEnum.pin:
         generator = PinPasswordGenerator();
         break;

         case PasswordTypeEnum.standard:
         generator = StandardPasswordGenerator();
         
         break;
         
    }

    setState(() {
           _passwordController.text = generator.generate(maxCharacters); 
         });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ColorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    ClipOval(
                      child: SizedBox(
                        width: 150,
                        height: 150,
                        child: Image.asset(
                          "assets/images/ironman.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Sua senha segura",
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      maxLength: maxCharacters,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: _passwordController.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  copyPassword(_passwordController.text);
                                },
                                icon: Icon(Icons.copy),
                              )
                            : null,
                      ),
                    ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Tipo de senha")), 

                  Row(
                    children: [
                      Expanded(
                        child:RadioListTile(
                          value: PasswordTypeEnum.pin,
                          groupValue: passwordTypeSelected,
                          title: Text("PIN"),
                          onChanged: (value){
                            setState(() {
                               passwordTypeSelected = value!;
                            });
                          },
                        )
                        ),
                      Expanded(child: RadioListTile(value: PasswordTypeEnum.standard, 
                      groupValue: passwordTypeSelected,
                      title: Text("Paqdrão"),
                       onChanged: (value){
                        setState(() {
                        passwordTypeSelected = value!;  
                        });
                       }),)
                    ],
                  )               
                  ],
                ),
              ),

              Divider(color: ColorScheme.outline),
             
             Row(children: [
              Icon(isEditable ? Icons.lock_open : Icons.lock),
              Text("Permite editar a senha?"),
              Switch(value: isEditable,
               onChanged: (value){
                isEditable = value;
               },
              )
             ],)
            ],
          ),
        ),
      ),
    );
  }
}
