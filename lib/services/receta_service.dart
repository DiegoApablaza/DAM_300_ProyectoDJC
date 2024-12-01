import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecetaService {
  Stream<QuerySnapshot> Recetas() {
    return FirebaseFirestore.instance.collection('Recetas').snapshots();
  }

  Future<void> agregarReceta(
      String autor, String categoria, String instrucciones, String nombre) {
    return FirebaseFirestore.instance.collection('Recetas').doc().set({
      'Autor': autor,
      'Categoria': categoria,
      'Instrucciones': instrucciones,
      'Nombre': nombre
    });
  }

  Stream<QuerySnapshot> obtenerRecetasPorAutor() {
    final user = FirebaseAuth.instance.currentUser;
    if (user?.displayName != null) {
      final String autor = user!.displayName!;
      return FirebaseFirestore.instance
          .collection('Recetas')
          .where('Autor', isEqualTo: autor)
          .snapshots();
    } else {
      return const Stream.empty();
    }
  }

  Stream<DocumentSnapshot> Receta(String id) {
    return FirebaseFirestore.instance.collection('Receta').doc(id).snapshots();
  }

  //Future<String> ImagenReceta(String id) {
  //  var RecetaCategoria = Receta(id);

  //}

  Future<void> borrarReceta(String id) {
    return FirebaseFirestore.instance.collection('Recetas').doc(id).delete();
  }
}
