import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:one/modelViewer.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        // ignore: unnecessary_const
        child: ListView(
      //padding removes the white spaces on top
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
          accountName: const Text('ArnavPS'),
          accountEmail: const Text('nitrox919@gmail.com'),
          currentAccountPicture: CircleAvatar(
            child: ClipOval(
              child: Image.network(
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTw1NNSyu8coHz_FsmPcD0WlQxHJHdpbuUZ_g&usqp=CAU",
                //File : FileImage(r'C:\Users\Asus\Desktop\kratos.png'),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          decoration: const BoxDecoration(
              //the blue color is shown if the image is not loaded yet/ not loaded properly
              color: Colors.blue,
              image: DecorationImage(
                image: NetworkImage(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQx5jeSbuYjEPOd5FzLP9haXUbZLKWDaFqF2g&usqp=CAU",
                ),
                fit: BoxFit.cover,
              )),
        ),
        ListTile(
            leading: const Icon(Icons.people),
            title: const Text("model_viewer"),
            onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => model_view()),
                )),
      ],
    ));
  }
}
