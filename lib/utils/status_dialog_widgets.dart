import 'package:flutter/material.dart';

class DialogWidgets {
  static void showExceedDialog(BuildContext context, String selectedCategory) {
    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.indigo.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: BorderSide(
                color: Colors.black,
                width: 3.0,
              ),
            ),
            title: const Center(
              child: Text(
                'Capacity Exceeded',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            content: Text(
              'Task assignments for $selectedCategory are above the current team capacity.',
              style: const TextStyle(
                fontSize: 17,
              ),
            ),
            actions: <Widget>[
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error showing exceed dialog: $e');
    }
  }

  static void showNotExceedDialog(
      BuildContext context, String selectedCategory) {
    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.indigo.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: BorderSide(
                color: Colors.black,
                width: 3.0,
              ),
            ),
            title: const Center(
              child: Text(
                'Capacity On Track',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            content: Text(
              'Team workload for $selectedCategory is within the planned capacity range.',
              style: const TextStyle(
                fontSize: 17,
              ),
            ),
            actions: <Widget>[
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error showing exceed dialog: $e');
    }
  }
}
