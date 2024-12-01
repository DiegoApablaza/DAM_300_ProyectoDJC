import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_dam/pages/navs/agregar_recetas.dart';
import 'package:proyecto_dam/pages/navs/dato_receta.dart';
import 'package:proyecto_dam/services/categoria_service.dart';
import 'package:proyecto_dam/services/receta_service.dart';

class GestionRecetas extends StatefulWidget {
  const GestionRecetas({super.key});

  @override
  _GestionRecetasState createState() => _GestionRecetasState();
}

class _GestionRecetasState extends State<GestionRecetas>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
          'Categoría: $nombreCategoria',
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        );
      },
    );
  }

  void _eliminarReceta(String recetaId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Receta'),
          content:
              const Text('¿Estás seguro de que deseas eliminar esta receta?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.red, // Color del texto
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.cancel,
                      color: Color.fromARGB(
                          255, 235, 194, 191)), // Ícono de cancelación
                  SizedBox(width: 8),
                  Text(
                    'Cancelar',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                final Servicio = RecetaService();
                Servicio.borrarReceta(recetaId);
                setState(() {});
                Navigator.of(context).pop(); // Cierra el diálogo
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Receta eliminada con éxito'),
                ));
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.green, // Color del texto
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.delete,
                      color:
                          Color.fromARGB(255, 39, 40, 39)), // Ícono de eliminar
                  SizedBox(width: 8),
                  Text(
                    'Eliminar',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _agregarReceta() async {
    var nuevaReceta = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AgregarReceta(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        title: Row(
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 32,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            const Text(
              'Mis Recetas',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 54, 36, 7),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 20,
              child: Icon(
                Icons.person,
                color: const Color(0xFFFFA500),
                size: 24,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _agregarReceta,
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 0, 0, 0),
            image: DecorationImage(
                image: AssetImage('assets/images/mesa4.jpg'),
                fit: BoxFit.fill)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Centra los botones
              children: [
                ElevatedButton(
                  onPressed: _agregarReceta,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    minimumSize:
                        const Size(200, 50), // Ancho: 200px, Alto: 50px
                  ),
                  child: const Text(
                    'Agregar Receta',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 16), // Espacio entre los botones
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: RecetaService().obtenerRecetasPorAutor(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData ||
                          snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var receta = snapshot.data!.docs[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(
                                  color: Color.fromARGB(
                                      255, 33, 33, 33), // Color del borde
                                  width: 3, // Grosor del borde
                                ),
                              ),
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      receta['Nombre'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // Mostrar el nombre de la categoría
                                    _buscarNombreCategoria(receta['Categoria']),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return DatoReceta(
                                                    idReceta: receta.id,
                                                    nombreReceta:
                                                        receta['Nombre'],
                                                    autorReceta:
                                                        receta['Autor'],
                                                    categoriaReceta:
                                                        receta['Categoria'],
                                                    instruccionesReceta:
                                                        receta['Instrucciones'],
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 199, 165, 153),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text('Ver'),
                                        ),
                                        const SizedBox(width: 8),
                                        ElevatedButton(
                                          onPressed: () {
                                            _eliminarReceta(receta.id);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 219, 135, 56),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text('Borrar'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    })),
          ],
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: _animation,
        child: FloatingActionButton(
          onPressed: _agregarReceta,
          backgroundColor: Colors.teal,
          child: const Icon(Icons.plus_one_sharp),
        ),
      ),
    );
  }
}
