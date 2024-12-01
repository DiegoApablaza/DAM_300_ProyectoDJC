import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/comida_login.jpg'), // Asegúrate de incluir la imagen en assets
            fit: BoxFit.cover, // Ajusta la imagen para cubrir todo el fondo
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(
                  0.3), // Aplica una capa de opacidad blanca para aclarar la imagen
              BlendMode
                  .lighten, // Combina el color de opacidad con la imagen para aclararla
            ),
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo de la app
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  child: Icon(
                    MdiIcons.foodTurkey,
                    color: Colors.amber[700],
                    size: 60,
                  ),
                ),
                SizedBox(height: 20),

                Text(
                  "Bienvenido",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    shadows: [
                      Shadow(
                        color: Colors.white,
                        blurRadius: 3,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),

                // Subtítulo
                Text(
                  "Inicia sesión con cuenta Google",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    shadows: [
                      Shadow(
                        color: Colors.white,
                        blurRadius: 3,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 50),

                // Botón con borde
                InkWell(
                  onTap: () {
                    // Acción del botón
                    signInConGoogle();
                  },
                  splashColor:
                      const Color.fromARGB(255, 218, 227, 119).withOpacity(0.4),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                          245, 107, 186, 207), // Fondo azul translúcido
                      borderRadius:
                          BorderRadius.circular(60), // Borde redondeado
                      border: Border.all(
                        // Aquí se agrega el borde
                        color: const Color.fromARGB(255, 61, 40,
                            69), // Color del borde (blanco en este caso)
                        width: 2, // Ancho del borde
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: Offset(0, 3),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Iniciar sesión",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black
                                    .withOpacity(0.5), // Sombra negra
                                blurRadius: 5, // Difusión de la sombra
                                offset: Offset(2, 2), // Dirección de la sombra
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Logotipo de Google con Sombra
                Container(
                  height: 90,
                  width: 120,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/images/logoGoogle.png', // Asegúrate de agregar este archivo a tus assets
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Separador
                Divider(
                  color: Colors.white54,
                  thickness: 1,
                  endIndent: 50,
                  indent: 50,
                ),
                SizedBox(height: 20),

                // Opción de contacto
                TextButton(
                  onPressed: () {
                    // Acción alternativa
                  },
                  child: Text(
                    "¿No tienes cuenta? Registrate",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 218, 241, 134),
                      shadows: [
                        // Puedes agregar sombra aquí también si es necesario
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  signInConGoogle() async {
    GoogleSignInAccount? usuarioGoogle = await GoogleSignIn().signIn();

    GoogleSignInAuthentication? auth = await usuarioGoogle?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: auth?.accessToken, idToken: auth?.idToken);

    UserCredential usuario =
        await FirebaseAuth.instance.signInWithCredential(credential);
    print(usuario.user?.displayName);

    if (usuario.user != null) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomePage()));
    }
  }
}
