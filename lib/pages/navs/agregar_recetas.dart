import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:proyecto_dam/services/auth_service.dart';
import 'package:proyecto_dam/services/categoria_service.dart';
import 'package:proyecto_dam/services/receta_service.dart';

class AgregarReceta extends StatefulWidget {
  const AgregarReceta({
    super.key,
  });

  @override
  State<AgregarReceta> createState() => _AgregarRecetaState();
}

class _AgregarRecetaState extends State<AgregarReceta> {
  // Controladores y clave para el formulario
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nombreCtrl = TextEditingController();
  final TextEditingController ingredientesCtrl = TextEditingController();
  final TextEditingController porcionesCtrl = TextEditingController();
  final TextEditingController instruccionesCtrl = TextEditingController();
  final TextEditingController autorCtrl = TextEditingController();

  String? categoriaSeleccionada;
  String? categoriaError;
  String? nombreDisplay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 36, 36, 36),
        flexibleSpace: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  MdiIcons.foodTurkey,
                  color: Colors.amber[700],
                ),
                const SizedBox(width: 8), // Espacio entre imagen y texto
                const Text(
                  'Agregar Receta',
                  style: TextStyle(
                    fontSize: 24, // Letras más grandes
                    fontWeight: FontWeight.bold, // Negrita
                    color: Colors.black, // Color del texto
                    fontFamily: 'Roboto', // Tipografía
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Fondo con la imagen
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fondoagregarreceta.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Capa semitransparente para el efecto de opacidad en el fondo
          Container(
            color: Colors.white.withOpacity(0.7), // Ajusta la opacidad aquí
          ),
          // Contenido del formulario
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey, // Asignamos la clave al formulario
              child: ListView(
                children: [
                  _buildLabeledTextField(
                    label: 'Nombre',
                    icon: Icons.text_fields,
                    controller: nombreCtrl,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El nombre es obligatorio';
                      }
                      return null; // Validación exitosa
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildLabeledTextField(
                    label: 'Instrucciones',
                    icon: Icons.create,
                    controller: instruccionesCtrl,
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Las instrucciones son obligatorias';
                      }
                      return null; // Validación exitosa
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Categoría',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildDropdownCategoria(validator: (valorCategoria) {
                    if (valorCategoria == null || valorCategoria.isEmpty) {
                      return 'Categoria es obligatoria';
                    }
                    return null;
                  }),
                  const SizedBox(height: 24),
                  FutureBuilder(
                      future: AuthService().currentUser(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData || snapshot.data == null) {
                          return Text('No hay nombre de usuario disponible');
                        } else {
                          return ElevatedButton(
                            onPressed: () {
                              // Validar el formulario
                              if (_formKey.currentState?.validate() ?? false) {
                                final recetaService = RecetaService();
                                recetaService.agregarReceta(
                                    snapshot.data!.displayName ?? 'Anonimo',
                                    categoriaSeleccionada.toString(),
                                    instruccionesCtrl.text.trim(),
                                    nombreCtrl.text.trim());
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Formulario válido')),
                                );
                                Navigator.pop(context);
                              } else {
                                // Si el formulario no es válido, mostrar un mensaje de error
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Formulario no válido')),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 85, 33, 1),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const SizedBox(
                              width: 80, // Ancho fijo
                              height: 50, // Alto fijo
                              child: Center(
                                child: Text(
                                  'Guardar',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 228, 227, 239),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Método para crear campos de texto con etiquetas e íconos
  Widget _buildLabeledTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator, // Agregar el validador
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(8),
              child: Icon(icon, color: const Color.fromARGB(255, 209, 135, 61)),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          maxLines: maxLines,
          keyboardType: keyboardType,
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  // Dropdown de categorías (solo diseño)

  Widget _buildDropdownCategoria({
    required String? Function(String?) validator,
  }) {
    return StreamBuilder<QuerySnapshot>(
      stream: CategoriaService().Categorias(),
      builder: (context, AsyncSnapshot snapshot) {
        List<DropdownMenuItem<String>> menuItems = [];
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData) {
          return const Text('No hay categorías disponibles');
        } else {
          final categorias = snapshot.data.docs;
          for (var categoria in categorias) {
            menuItems.add(
              DropdownMenuItem<String>(
                value: categoria.id,
                child: Text(
                  categoria['nombre'],
                ),
              ),
            );
          }
        }
        return DropdownButtonFormField<String>(
          decoration: InputDecoration(
            fillColor: Colors.white,
            labelText: 'Seleccione Categoria',
            errorText: categoriaError,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
          ),
          items: menuItems,
          onChanged: (valorCategoria) {
            setState(() {
              categoriaSeleccionada = valorCategoria;
              print(categoriaSeleccionada);
            });
          },
          value: categoriaSeleccionada,
          isExpanded: false,
          validator: validator,
        );
      },
    );
  }
}
