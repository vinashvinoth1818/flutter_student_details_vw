import 'package:demoprojecct/student_detail_model.dart';
import 'package:demoprojecct/students_details.dart';
import 'package:flutter/material.dart';


import 'database_helper.dart';
import 'main.dart';

class OptimizedStudentFormScreen extends StatefulWidget {
  const OptimizedStudentFormScreen({super.key});

  @override
  State<OptimizedStudentFormScreen> createState() => _OptimizedStudentFormScreenState();
}

class _OptimizedStudentFormScreenState extends State<OptimizedStudentFormScreen> {
  var _studentNameController = TextEditingController();
  var _studentMobileNoController = TextEditingController();
  var _studentEmailIDController = TextEditingController();

  // Edit option
  bool firstTimeFlag = false;
  int _selectedId = 0;

  // Optimized
  String buttonText = 'Save';

  @override
  Widget build(BuildContext context) {
    // Edit - Receive Data
    if (firstTimeFlag == false) {
      print('---------->once execute');

      firstTimeFlag = true;

      final studentDetail = ModalRoute.of(context)!.settings.arguments;

      if (studentDetail == null) {
        print('----------->FAB: Insert/Save:'); // save
      } else {
        print('----------->ListView: Received Data: Edit/Delete');

        studentDetail as StudentsDetailsModel;

        print('----------->Received Data');

        print(studentDetail.id);
        print(studentDetail.studentName);
        print(studentDetail.studentMobileNo);
        print(studentDetail.studentEmailId);

        _selectedId = studentDetail.id!;
        buttonText = 'Update';

        _studentNameController.text = studentDetail.studentName;
        _studentMobileNoController.text = studentDetail.studentMobileNo;
        _studentEmailIDController.text = studentDetail.studentEmailId;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Student Details Form'),
        actions: _selectedId != 0
            ? [
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem(value: 1, child: Text("Delete")),
            ],
            elevation: 2,
            onSelected: (value) {
              if (value == 1) {
                _deleteFormDialog(context);
              }
            },
          ),
        ] : null,  // Save - null
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _studentNameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      labelText: 'Student Name',
                      hintText: 'Enter Student Name'
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _studentMobileNoController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      labelText: 'Student Mobile No',
                      hintText: 'Enter Student Mobile No'
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _studentEmailIDController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      labelText: 'Student Email ID',
                      hintText: 'Enter Student Email ID'
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: (){
                    print('--------------> Button Clicked');
                    if (_selectedId == 0) {
                      print('---------------> Save');
                      _save();
                    } else {
                      print('---------------> Update');
                      _update();
                    }
                  },
                  child: Text(buttonText),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _deleteFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  print('--------------> Cancel Button Clicked');
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  print('--------------> Delete Button Clicked');
                  _delete();
                },
                child: const Text('Delete'),
              )
            ],
            title: const Text('Are you sure you want to delete this?'),
          );
        });
  }

  void _save() async{
    print('--------------> _save');
    print('--------------> Student Name: ${_studentNameController.text}');
    print('--------------> Mobile No: ${_studentMobileNoController.text}');
    print('--------------> Email ID: ${_studentEmailIDController.text}');

    Map<String, dynamic> row = {
      DatabaseHelper.colStudentName: _studentNameController.text,
      DatabaseHelper.colMobileNo: _studentMobileNoController.text,
      DatabaseHelper.colEmailID: _studentEmailIDController.text,
    };

    final result = await dbHelper.insertStudentDetails(row, DatabaseHelper.studentDetailsTable);

    debugPrint('--------> Inserted Row Id: $result');

    if (result > 0) {
      Navigator.pop(context);
      _showSuccessSnackBar(context, 'Saved');
    }

    setState(() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => StudentListScreen()));
    });
  }

  void _update() async{
    print('--------------> _update');

    // edit
    print('---------------> Selected ID: $_selectedId');

    print('--------------> Student Name: ${_studentNameController.text}');
    print('--------------> Mobile No: ${_studentMobileNoController.text}');
    print('--------------> Email ID: ${_studentEmailIDController.text}');

    Map<String, dynamic> row = {
      // edit
      DatabaseHelper.colId: _selectedId,

      DatabaseHelper.colStudentName: _studentNameController.text,
      DatabaseHelper.colMobileNo: _studentMobileNoController.text,
      DatabaseHelper.colEmailID: _studentEmailIDController.text,
    };

    final result = await dbHelper.updateStudentDetails(row, DatabaseHelper.studentDetailsTable);

    debugPrint('--------> Updated Row Id: $result');

    if (result > 0) {
      Navigator.pop(context);
      _showSuccessSnackBar(context, 'Updated');
    }

    setState(() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => StudentListScreen()));
    });
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(new SnackBar(content: new Text(message)));
  }

  void _delete() async{
    print('--------------> _delete');

    final result = await dbHelper.deleteStudentDetails(_selectedId, DatabaseHelper.studentDetailsTable);

    debugPrint('-----------------> Deleted Row Id: $result');

    if (result > 0) {
      _showSuccessSnackBar(context, 'Deleted.');
      Navigator.pop(context);
    }

    setState(() {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => StudentListScreen()));
    });
  }

}