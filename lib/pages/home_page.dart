import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:proyecto_dam/pages/login_page.dart';
import 'package:proyecto_dam/pages/navs/gestion_usuario.dart';
import 'package:proyecto_dam/pages/navs/listar_recetas.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pagSelect = 0;
  List paginas = [ListarRecetas(), GestionRecetas()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 36, 36, 36),
        leading: Icon(
          MdiIcons.foodTurkey,
          color: Colors.amber[700],
        ),
        title: Text('Galeria Culinaria'),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        actions: [
          IconButton(
            icon: Icon(Icons.logout), // Icono para el botón
            tooltip:
                'Cerrar Sesión', // Texto que aparece al mantener presionado el botón
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Cerrar Sesión'),
                  content: Text('¿Estás seguro de que deseas cerrar sesión?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Cierra el diálogo
                      },
                      child: Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Cerrar sesión
                        FirebaseAuth.instance.signOut();
                        // Redirigir a la página de inicio de sesión
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: Text('Aceptar'),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: paginas[pagSelect],
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        backgroundColor: const Color.fromARGB(255, 69, 62, 51),
        indicatorColor: Colors.orange[300],
        selectedIndex: pagSelect,
        destinations: [
          NavigationDestination(
            icon: Icon(
              MdiIcons.home,
              color: Colors.white,
            ),
            label: 'Home',
          ),
          NavigationDestination(
              icon: Icon(
                MdiIcons.receiptTextPlus,
                color: Colors.white,
              ),
              label: 'Mi Cuenta')
        ],
        onDestinationSelected: (pagina) {
          setState(() {
            pagSelect = pagina;
          });
        },
      ),
    );
  }
}
