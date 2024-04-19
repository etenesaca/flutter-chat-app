import 'package:chat/models/models.dart';
import 'package:chat/screens/login_screen.dart';
import 'package:chat/screens/screens.dart';
import 'package:chat/services/services.dart';
import 'package:chat/services/usuarios_response.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsuariosScreen extends StatefulWidget {
  static const routeName = 'Usuarios';
  const UsuariosScreen({super.key});

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final ususariosService = UsuariosService();
  List<Usuario> usuarios = [];

  // final usuarios = [
  //   Usuario(uid: '1', nombre: 'María', email: 'test1@test.com', online: true),
  //   Usuario(
  //       uid: '2', nombre: 'Melissa', email: 'test2@test.com', online: false),
  //   Usuario(
  //       uid: '3', nombre: 'Fernando', email: 'test3@test.com', online: true),
  // ];

  @override
  void initState() {
    super.initState();
    _cargarUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    final AuthService authService =
        Provider.of<AuthService>(context, listen: true);
    final SocketService socketService =
        Provider.of<SocketService>(context, listen: true);

    final _screen = Scaffold(
      appBar: AppBar(
        title: Text(authService.usuario!.nombre),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              AuthService.deleteToken();
              socketService.disconnect();
              Navigator.pushReplacementNamed(context, LoginScreen.routeName);
            },
            icon: const Icon(Icons.exit_to_app)),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: socketService.serverStatus == ServerStatus.Online
                ? Icon(Icons.check_circle, color: Colors.blue[400])
                : Icon(Icons.offline_bolt, color: Colors.red),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        header: WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue[400]),
          waterDropColor: Colors.blue,
        ),
        onRefresh: _cargarUsuarios,
        child: _ListViewUsuarios(),
      ),
    );
    return _screen;
  }

  ListView _ListViewUsuarios() {
    return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (_, i) => _usuarioListTile(usuarios[i]),
        separatorBuilder: (_, i) => Divider(),
        itemCount: usuarios.length);
  }

  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
      title: Text(usuario.nombre),
      subtitle: Text(usuario.email),
      leading: CircleAvatar(
        backgroundColor: Colors.blue[200],
        child: Text(usuario.nombre.substring(0, 2)),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: usuario.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)),
      ),
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.usuarioPara = usuario;
        Navigator.pushNamed(context, ChatScreen.routeName);
      },
    );
  }

  void _cargarUsuarios() async {
    usuarios = await ususariosService.getUsuarios();
    setState(() {});
    // monitor network fetch
    // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
