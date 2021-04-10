import 'package:flutter/material.dart';

import 'auth/utils.dart';

class AuthenticationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Выберите метод авторизации'),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        color: Colors.transparent,
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.center,
        child: getChatItemsWidget2(),

        // TextButton(
        //   style: TextButton.styleFrom(
        //     primary: Colors.orange, // foreground
        //   ),
        //   onPressed: () {},
        //   child: Text('TextButton with custom foreground'),
        // ),
      ),
    );
  }

  final providers = [ProvidersTypes.google, ProvidersTypes.facebook, ProvidersTypes.email];

  Widget getChatItemsWidget2() {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      itemCount: providers.length,
      itemBuilder: (BuildContext context, int index) {
        var provider = providers[index];
        return providersDefinitions()[provider]!;
        // return new ButtonDescription(
        //     "fb-logo.png", "sign in with Facebook", "Facebook", () => {print("Facebook auth")},
        //     color: const Color.fromRGBO(59, 87, 157, 1.0), labelColor: Colors.white);
        // return InkWell(
        //     onTap: () {
        //       print(chatItem);
        //     },
        //     child: Container(
        //         height: 50,
        //         // color: Colors.white,
        //         child: Row(
        //           children: [
        //             Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 Expanded(
        //                     child: Text(chatItem,
        //                         style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.left)),
        //               ],
        //             ),
        //           ],
        //         )
        //         // child: Center(child: Text(chatItem.name)),
        //         ));
      },
      // separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}
