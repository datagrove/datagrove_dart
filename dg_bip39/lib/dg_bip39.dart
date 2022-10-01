// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

library dg_bip39;

import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:dg_modal/dg_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:convert/convert.dart';
import 'package:ecdsa/ecdsa.dart';
import 'package:elliptic/elliptic.dart';
part 'identity.dart';

// class User with ChangeNotifier {
//   bool login = false;
//   bool signup = false;
//   String name = "jim";
//   int age = 10;

//   loginx() {
//     login = true;
//     notifyListeners();
//   }

//   signupx() {
//     signup = true;
//     notifyListeners();
//   }
// }

showAddIdentity(BuildContext context) async {
  await showModal(context, LoginPage());
}

// awkward if we change the identity, won't that remove the stack and start over?
showCreateIdentity(BuildContext context) async {
  // d
  await showModal(context, SignupPage());
}

class Login extends StatelessWidget {
  final Widget child;
  const Login({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final a = Provider.of<User>(context);
    if (a.active != null) {
      return child;
    } else
      return LoginPage();
  }
}

/*
 CupertinoPageScaffold(
          child: Center(
              child: CupertinoButton(
                  child: Text("signup"),
                  onPressed: () {
                    Provider.of<User>(context, listen: false).loginx();
                  })));
    return CupertinoPageScaffold(
        child: Center(
            child: CupertinoButton(
                child: Text("login"),
                onPressed: () {
                  Provider.of<User>(context, listen: false).signupx();
                })));
*/

// making signup a modal allows it to be called from anywhere, e.g. a settings page.

// move to localization
const String advice =
    """With this secret identity you can recover your data even if you lose your device. We suggest you write it down with pencil on paper.\n\nNO ONE at Datagrove can retrieve a lost passphrase for you!!""";

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  var mnemonic = bip39.generateMnemonic();
  late TextEditingController controller;
  final data = secureString(16);
  bool valid = false;
  bool obscure = true;
  bool store = true;
  bool signup = false;

  checkName() {
    setState(() {
      valid = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dg = Provider.of<User>(context);
    return ModalScaffold(
        //action: const Text("I wrote it down"),
        title: const Text("Create Account"),
        valid: valid,
        child: Center(
            child: Container(
                constraints: const BoxConstraints(minWidth: 100, maxWidth: 600),
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Column(children: [
                      Row(children: [
                        Expanded(
                            child: CupertinoTextFormFieldRow(
                                controller: controller,
                                prefix: const Text("Name"),
                                onFieldSubmitted: (String s) {
                                  checkName();
                                },
                                autofocus: true,
                                placeholder: "Screen name")),
                        CupertinoButton(
                            onPressed: () {
                              checkName();
                            },
                            child: const Text("Check"))
                      ]),
                      // put name here
                      if (valid)
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Your identity is",
                              style: TextStyle(fontSize: 18)),
                        ),
                      if (valid)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SelectableText(mnemonic,
                              style: const TextStyle(
                                  color: CupertinoColors.activeGreen)),
                        ),
                      if (valid)
                        const Padding(
                            padding: EdgeInsets.all(8.0), child: Text(advice)),
                      if (valid)
                        CupertinoButton(
                            onPressed: () {
                              Provider.of<User>(context)
                                  .activate(Identity.create(controller.text));
                            },
                            child: const Text("I wrote it down"))
                    ])))));
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var mnemonic = bip39.generateMnemonic();
  late TextEditingController controller;
  final data = secureString(16);
  bool valid = false;
  bool obscure = true;
  bool store = true;
  bool signup = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.extraLightBackgroundGray,
        navigationBar: CupertinoNavigationBar(middle: Text("Login")),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
                constraints: const BoxConstraints(minWidth: 100, maxWidth: 600),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CupertinoButton(
                        child: const Text("Create account"),
                        onPressed: () async {
                          // dgf.isLogin = true;
                          // context.url = "/0";
                          setState(() {
                            signup = true;
                          });
                        },
                      ),
                      Qr(data: data),
                      Text("Login with Phone"),
                      SizedBox(
                        width: 300,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "Scan QR code with this app on your phone to log in instantly",
                            style: TextStyle(color: CupertinoColors.systemGrey),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("BIP 39 passphrase"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CupertinoTextField(
                          textAlign: TextAlign.left,
                          maxLines: 3,
                          placeholder: "BIP39 passphrase",
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1024)
                          ],
                          onChanged: (String s) {
                            if (bip39.validateMnemonic(s)) {
                              // widget.dgf.isLogin =rue;
                              // context.url = "/0?";
                              Provider.of<User>(context, listen: false)
                                  .activate(Identity.create("untitled"));
                            } else {
                              print("nope $s");
                            }
                          },
                        ),
                      ),
                    ])),
          ),
        ));
  }
}

class Qr extends StatelessWidget {
  final String data;
  const Qr({super.key, required this.data});
  @override
  Widget build(Object context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: CupertinoColors.white,
            border: Border.all(
              color: CupertinoColors.white,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BarcodeWidget(
              width: 200, height: 200, barcode: Barcode.qrCode(), data: data),
        ),
      ),
    );
  }
}
/*
class AddAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container()),
        CupertinoButton(
          child: const Text("Create account"),
          onPressed: () async {
            // dgf.isLogin = true;
            // context.url = "/0";
          },
        ),
      ],
    );
  }
}

class ShowQr extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = "";
    //dg.identity.privateKey.publicKey.toHex();
    return ModalScaffold(
        action: const Text(""),
        title: const Text("Link phone"),
        valid: false,
        child: Column(children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
                "Use a previously authorized phone to authorize this device\n\nYou can find the linking functions in the Settings tab ⚙️"),
          ),
          Center(
            child: Material(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BarcodeWidget(
                      width: 200,
                      height: 200,
                      barcode: Barcode.qrCode(),
                      data: data),
                )),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
                "Note that if you later revoke the device you used to link, this device will be revoked as well. If that is not what you want, then tap cancel and use your BIP39 passphrase to authorize this device."),
          )
        ])
        //dg.style.desktopLink,
        );
  }
}




class SliverQr extends StatelessWidget {
  final String data;
  const SliverQr(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Center(
      child: Material(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BarcodeWidget(
                width: 200, height: 200, barcode: Barcode.qrCode(), data: data),
          )),
    ));
  }
}
*/

// base32 only uses 2-7, can we use 0 in clever way? issue is that whatever we do we need to explain why you can't use a url to user, and the less likely the trap, the more painful when they fall in.

// urls look like host/{group-app-sponsor}/{publication id or query}?parameters
// note is exactly one publication; to query more, we query on publication reference in that publication.

// maybe this should cross to the isolate? it will be hard to keep cache
// up to date here. could be laggy to contact isolate every time though.

class Linkup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
/*
class SignupScreen extends StatefulWidget {
  var mnemonic = bip39.generateMnemonic();
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool valid = false;

  @override
  initState() {
    super.initState();
    print("is ${widget.mnemonic} ${bip39.validateMnemonic(widget.mnemonic)}");
  }

  checkName() {
    setState(() {
      valid = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pr = Provider.of<IdentityManager>(context);
    return ModalScaffold(
        //action: const Text("I wrote it down"),
        title: const Text("Create Account"),
        valid: valid,
        child: Center(
            child: Container(
                constraints: const BoxConstraints(minWidth: 100, maxWidth: 600),
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Column(children: [
                      Row(children: [
                        Expanded(
                            child: CupertinoTextFormFieldRow(
                                prefix: const Text("Name"),
                                autofocus: true,
                                placeholder: "Screen name")),
                        CupertinoButton(
                            onPressed: () {
                              checkName();
                            },
                            child: const Text("Check"))
                      ]),
                      // put name here
                      if (valid)
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Your identity is",
                              style: TextStyle(fontSize: 18)),
                        ),
                      if (valid)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SelectableText(widget.mnemonic,
                              style: const TextStyle(
                                  color: CupertinoColors.activeGreen)),
                        ),
                      if (valid)
                        const Padding(
                            padding: EdgeInsets.all(8.0), child: Text(advice)),
                      if (valid)
                        CupertinoButton(
                            onPressed: () {
                              pr.activate(Identity.create());
                              Navigator.of(context).pop();
                            },
                            child: const Text("I wrote it down"))
                    ])))));
  }
}
*/