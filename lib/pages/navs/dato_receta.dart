import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_dam/services/categoria_service.dart';
import 'package:proyecto_dam/services/receta_service.dart';

class DatoReceta extends StatefulWidget {
  const DatoReceta(
      {super.key,
      required this.idReceta,
      required this.autorReceta,
      required this.instruccionesReceta,
      required this.nombreReceta,
      required this.categoriaReceta});
  final String nombreReceta;
  final String idReceta;
  final String instruccionesReceta;
  final String autorReceta;
  final String categoriaReceta;

  @override
  State<DatoReceta> createState() => _DatoRecetaState();
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

        return Image.asset(
          'assets/images/${nombreFoto}',
          height: 200,
        );
      });
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
          style: TextStyle(fontSize: 12, color: Colors.black54),
        );
      }

      final data = snapshot.data!.data() as Map<String, dynamic>;
      final nombreCategoria = data['nombre'] ?? 'Desconocido';

      return Text(
        'Categoría: $nombreCategoria',
        style: const TextStyle(fontSize: 12),
      );
    },
  );
}

class _DatoRecetaState extends State<DatoReceta> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: EdgeInsets.only(top: 50, left: 10, right: 10, bottom: 50),
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.brown, width: 4),
        color: const Color.fromARGB(255, 235, 225, 137),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              widget.nombreReceta,
              style: TextStyle(fontSize: 20),
            ),
          ),
          _buscarNomFotoCategoria(widget.categoriaReceta),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 15),
            child: Text(
              'Instrucciones',
              style: TextStyle(fontSize: 15),
            ),
          ),
          Text(
            widget.instruccionesReceta,
            style: TextStyle(fontSize: 12),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, left: 10),
            child: Row(
              children: [
                Icon(Icons.grass, color: Colors.green, size: 30),
                SizedBox(width: 10),
                _buscarNombreCategoria(widget.categoriaReceta)
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, left: 10),
            child: Row(
              children: [
                Icon(Icons.person, color: Colors.blue, size: 30),
                SizedBox(width: 10),
                Text(
                  'Autor: ${widget.autorReceta}',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.black,
              minimumSize: Size(double.infinity, 50),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Volver lista de recetas'),
          ),
        ],
      ),
    ));
  }
}
