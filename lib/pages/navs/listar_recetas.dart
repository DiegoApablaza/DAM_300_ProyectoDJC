import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_dam/pages/navs/dato_receta.dart';
import 'package:proyecto_dam/services/categoria_service.dart';
import 'package:proyecto_dam/services/receta_service.dart';

class ListarRecetas extends StatefulWidget {
  const ListarRecetas({super.key});

  @override
  State<ListarRecetas> createState() => _ListarRecetasState();
}

Widget _buscarNombreCategoria(String id) {
  return StreamBuilder<DocumentSnapshot>(
    stream: CategoriaService().Categoria(id),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Text(
          'Cargando categoría...',
          style: TextStyle(fontSize: 14, color: Colors.black54),
        );
      }
      if (!snapshot.hasData || !snapshot.data!.exists) {
        return const Text(
          'Categoría no encontrada',
          style: TextStyle(fontSize: 14, color: Colors.black54),
        );
      }

      final data = snapshot.data!.data() as Map<String, dynamic>;
      final nombreCategoria = data['nombre'] ?? 'Desconocido';

      return Text(
        nombreCategoria,
        style: const TextStyle(fontSize: 14, color: Colors.black54),
      );
    },
  );
}

Widget _buscarNomFotoCategoria(String id) {
  return StreamBuilder<DocumentSnapshot>(
      stream: CategoriaService().Categoria(id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text(
            'Cargando foto....',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Text(
            'Foto no encontrada',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final nombreFoto = data['nombreFoto'] ?? 'pollo-arroz.jpg';

        return Container(
          width: 240,
          height: 240,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
              border: Border.all(color: Colors.black, width: 2.0)),
          child: ClipOval(
            child: Image.asset(
              'assets/images/${nombreFoto}',
              height: 50,
              width: 50,
              fit: BoxFit.fill,
            ),
          ),
        );
      });
}

class _ListarRecetasState extends State<ListarRecetas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/mesa5.jpg'), fit: BoxFit.cover),
          color: const Color.fromARGB(255, 36, 36, 36)),
      child: StreamBuilder(
        stream: RecetaService().Recetas(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData ||
              snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No hay recetas disponibles"));
          }
          return SizedBox(
            height: 400, // Establece un tamaño fijo
            child: CarouselSlider(
              options: CarouselOptions(height: 400),
              items: snapshot.data!.docs.map<Widget>((data) {
                return RecetaCard(
                  Recetaid: data.id,
                  nombre: data['Nombre'] ?? 'Sin nombre',
                  imagen: data['Categoria'],
                  autor: data['Autor'],
                  instrucciones: data['Instrucciones'],
                );
              }).toList(),
            ),
          );
        },
      ),
    ));
  }
}

class RecetaCard extends StatelessWidget {
  const RecetaCard(
      {required this.Recetaid,
      required this.nombre,
      required this.imagen,
      required this.autor,
      required this.instrucciones});

  final String Recetaid;
  final String nombre;
  final String imagen;
  final String autor;
  final String instrucciones;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 235, 200, 147),
          shape: BoxShape.circle),
      child: Card(
        shape: CircleBorder(),
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              _buscarNomFotoCategoria(imagen),
              Text(
                nombre,
              ),
              _buscarNombreCategoria(imagen),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text("Mostrar recetas"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return DatoReceta(
                          idReceta: Recetaid,
                          nombreReceta: nombre,
                          autorReceta: autor,
                          categoriaReceta: imagen,
                          instruccionesReceta: instrucciones,
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
