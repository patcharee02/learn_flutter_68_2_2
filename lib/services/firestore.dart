// Step 6: Make a firebase service
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference persons = FirebaseFirestore.instance.collection(
    'persons',
  );


// Create a new person
  Future<void>  addPerson(String personName, String personEmail, int personAge) {
    return persons.add({
      'personName': personName,
      'personEmail': personEmail,
      'personAge': personAge,
      'createdAT': Timestamp.now(),
    });
  }


// Read all person
  Stream<QuerySnapshot> getAllPersons() {
    return persons.orderBy('createdAT', descending: true).snapshots();
  }

  //Get a single person by id
  Future<Map<String, dynamic>?> getPersonById(String personId) async {
    DocumentSnapshot doc = await persons.doc(personId).get();
    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    } else {
      return null;
    }
  }

  Future<void> updatePerson(
    String personId, 
    String personName, 
    String personEmail, 
    int personAge,
    ) {
    return persons.doc(personId).update({
      'personName': personName,
      'personEmail': personEmail,
      'personAge': personAge,
    });
  }

  // Delete a person by id
  Future<void> deletePerson(String personId) {
    return persons.doc(personId).delete();
  }
}