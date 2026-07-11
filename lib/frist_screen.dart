import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';

// Step 3: check internet connection
import 'package:connectivity_plus/connectivity_plus.dart';
// Step 4: Show toast message
import 'package:fluttertoast/fluttertoast.dart';

// Step 7: Firbase CRUD operation
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learn_flutter_68_2_2/services/firestore.dart';

class FristScreen extends StatefulWidget {
  const FristScreen({super.key});

  @override
  State<FristScreen> createState() => _FristScreenState();
}

class _FristScreenState extends State<FristScreen> {
@override
  // อะไรที่อยากจะให้ทำตอนเริ่มต้นก็ใส่ใว้ในนี้
  void initState() {
    super.initState();

    // step 3: check internet connection
    checkInternetConnection();
  }

  Future<void> checkInternetConnection() async {
    final List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();

    if (!mounted) {
      return;
    }

    final String message = getConnectivityMessage(connectivityResult);
    _showToast(context, message);

    if (message == "No network available.") {
      _showAlertDialog(
        context,
        "No Network",
        "Please check your internet connection.",
      );
    }
  }
  //   // เมื่อครบ 3 วิ ให้ไปหน้า SecondScreen
  //   Timer(const Duration(seconds: 3),
  //   () => Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => const SecondScreen()),
  //   )
  // );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.cyanAccent],
            begin: FractionalOffset(0, 0),
            end: FractionalOffset(0.5, 0.6),
            tileMode: TileMode.mirror,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(child: Image.asset('android/assets/images/app_screen.png')),
            const SizedBox(height: 20),
            const SpinKitFadingCircle(color: Colors.white, size: 50.0),
          ],
        ),
      ),
    );
  }
}

// class SecondScreen extends StatelessWidget {
//   const SecondScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Second Screen')),
//       body: const Center(
//         child: Text(
//           'Welcome to the Second Screen!',
//           style: TextStyle(
//             fontSize: 24,
//             color: Colors.amberAccent,
//             fontWeight: FontWeight.w500,
//             fontFamily: 'Alike',
//           ),
//         ),
//       ),
//     );
//   }
// }

String getConnectivityMessage(List<ConnectivityResult> connectivityResult) {
  if (connectivityResult.contains(ConnectivityResult.mobile)) {
    return "Mobile network available.";
  } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
    return "Wi-Fi network available.";
  } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
    return "Ethernet connection available.";
  } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
    return "VPN network active.";
  } else if (connectivityResult.contains(ConnectivityResult.bluetooth)) {
    return "Bluetooth network available.";
  } else if (connectivityResult.contains(ConnectivityResult.satellite)) {
    return "Satellite network available.";
  } else if (connectivityResult.contains(ConnectivityResult.other)) {
    return "Other network available.";
  }

  return "No network available.";
}

// step 4: Show toast message
void _timer(BuildContext context) {
  // เมื่อครบ 3 วิ ให้ไปหน้า SecondScreen
  Timer(
    const Duration(seconds: 3),
    () {
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SecondScreen()),
        );
      }
    },
  );
}

// step 4: Show toast message
void _showToast(BuildContext context, String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.lightGreenAccent,
    textColor: Colors.black,
    fontSize: 24,
  );
  _timer(context);
}

void _showAlertDialog(BuildContext context, String title, String msg) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title, 
          style: TextStyle(
            fontSize: 24,
            color: Colors.redAccent,
            fontWeight: FontWeight.w500,
            fontFamily: 'Alike',
          ),
        ),
        content: Text(msg),
        actions: <Widget>[
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Colors.black54),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "OK",
              style: TextStyle(
                fontSize: 20,
                color: Colors.blue,
                fontWeight: FontWeight.w500,
                fontFamily: 'Alike',
              ),
            )
          )
        ]

      );
    },
  );
}

// Step 7: Firbase CRUD operation
class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  //make an instance of FirestoreService
  final FirestoreService firestoreService = FirestoreService();

  //text editing controllers for the text fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  // Open a dialog to add a new person
  void openPersonBox(String? personId) async {
    if (personId != null) {
      // Update case
      final personData = await firestoreService.getPersonById(personId);
      nameController.text = personData?['personName'] ?? '';
      emailController.text = personData?['personEmail'] ?? '';
      ageController.text = personData?['personAge']?.toString() ?? '';
    } else {
      // Create case
      nameController.clear();
      emailController.clear();
      ageController.clear();
    }

    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: (){
              Navigator.of( context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed:(){
              final String name = nameController.text;
              final String email = emailController.text;
              final int age = int.tryParse(ageController.text) ?? 0;

              if (personId != null) {
                // Update person
                firestoreService.updatePerson(personId, name, email, age);
              } else {
                // Add new person
                firestoreService.addPerson(name, email, age);
              }

              nameController.clear();
              emailController.clear();
              ageController.clear();

              Navigator.of(context).pop();
            },
            child: Text(personId != null ? 'Update' : 'Add')
          ),
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Persons List'),
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openPersonBox(null),
        child: const Icon(Icons.add),
      ),
      body : StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getPersons(),
        builder: (context, snapshot) {
          // if we data, get the list of persons
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final personsList = snapshot.data!.docs;

          if (personsList.isEmpty) {
            return const Center(
              child: Text('No persons found.'),
            );
          }

          return ListView.builder(
            itemCount: personsList.length,
            itemBuilder: (context, index) {
              //Get the persons ducument
              DocumentSnapshot personDoc = personsList[index];
              String personId = personDoc.id;

              //get person From the document
              Map<String, dynamic> personData = personDoc.data() as Map<String, dynamic>;

              String nameText = personData['personName'] ?? '';
              String emailText = personData['personEmail'] ?? '';
              int ageText = personData['personAge'] ?? 0;

              return ListTile(
                title: Text(nameText),
                subtitle: Text('$emailText, Age: $ageText'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => openPersonBox(personId),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => firestoreService.deletePerson(personId),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
