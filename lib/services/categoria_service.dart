import 'package:cloud_firestore/cloud_firestore.dart';

class CategoriaService {
  Stream<QuerySnapshot> Categorias() {
    return FirebaseFirestore.instance.collection('Categoria').snapshots();
  }

  Stream<DocumentSnapshot> Categoria(String id) {
    return FirebaseFirestore.instance
        .collection('Categoria')
        .doc(id)
        .snapshots();
  }

  Future<void> agregarCategoria(String nombreFoto) {
    return FirebaseFirestore.instance
        .collection('Categoria')
        .doc()
        .set({'nombreFoto': nombreFoto});
  }

  Future<void> borrarCategoria(String id) {
    return FirebaseFirestore.instance.collection('Categoria').doc(id).delete();
  }
}
