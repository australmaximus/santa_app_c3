import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  static Future crearUsuario(String email, String password, String name) async {
    UserCredential uc = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return FirebaseFirestore.instance
        .collection('usuarios')
        .doc()
        .set({'uid': uc.user!.uid, 'nombre': name, 'email': email});
  }

  Future amigosAgregar(String emailUsuario, String nombre, String email,
      String preferencia, DateTime cumple) async {
    FirebaseFirestore.instance.collection('amigos').doc().set({
      'emailUsuario': emailUsuario,
      'nombre': nombre,
      'email': email,
      'preferencia': preferencia,
      'cumple': cumple,
    });
  }

  Future amigosEditar(
      String documento, String nombre, String email, String preferencia) async {
    FirebaseFirestore.instance.collection('amigos').doc(documento).update({
      'nombre': nombre,
      'email': email,
      'preferencia': preferencia,
    });
  }

  Stream<QuerySnapshot> amigos(String documento) {
    return FirebaseFirestore.instance
        .collection('amigos')
        .where('emailUsuario', isEqualTo: documento)
        .snapshots();
  }

  Future amigosEliminar(String amigoId) {
    return FirebaseFirestore.instance
        .collection('amigos')
        .doc(amigoId)
        .delete();
  }

  static Future<String> obtenerNombreUsuario(String correo) async {
    var stream = await FirebaseFirestore.instance
        .collection('usuarios')
        .where('email', isEqualTo: correo)
        .snapshots()
        .first;
    var user = stream.docs[0];
    return user['nombre'];
  }

  /*
    IDEAS DE REGALO
  */
  Future ideaAgregar(
      String emailAmigo, String nombreRegalo, String marca, String tipo) async {
    FirebaseFirestore.instance.collection('regalos').doc().set({
      'emailAmigo': emailAmigo,
      'nombreRegalo': nombreRegalo,
      'marca': marca,
      'tipo': tipo,
    });
  }

  Future ideasEliminar(String ideaId) {
    return FirebaseFirestore.instance
        .collection('regalos')
        .doc(ideaId)
        .delete();
  }

  Stream<QuerySnapshot> ideas(String correo) {
    return FirebaseFirestore.instance
        .collection('regalos')
        .where('emailAmigo', isEqualTo: correo)
        .snapshots();
  }
}
