import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:student_database/db/database_helper.dart';
import 'package:student_database/model/student.dart';
import 'package:student_database/screens/student_list_screen.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({Key? key}) : super(key: key);

  @override
  State<AddStudentScreen> createState() => AddStudentScreenState();
}

class AddStudentScreenState extends State<AddStudentScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController dateController = TextEditingController();
  late String name, course, mobile, totalFee, feePaid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Center(child: Text('Student form')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // TextFormField for name
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Name',
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (text) {

                    name = text!;

                    return null;
                  },
                ),
                const SizedBox(height: 15),
                // TextFormField for course
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Course',
                    labelText: 'Course',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Please provide course';
                    }
                    course = text;
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                // TextFormField for mobile
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Mobile',
                    labelText: 'Mobile',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Please provide mobile';
                    }
                    mobile = text;
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                // TextFormField for Total Fee
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Total Fee',
                    labelText: 'Total Fee',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Please provide Total Fee';
                    }
                    totalFee = text;
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                // TextFormField for Fee Paid
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Fee Paid',
                    labelText: 'Fee Paid',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Please provide Fee Paid';
                    }
                    feePaid = text;
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                // TextFormField for date
                TextFormField(
                  controller: dateController,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.calendar_today_rounded),
                    labelText: 'Select date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        dateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
                      });
                    }
                  },
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Please select a date';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      // Create a student object
                      Student s = Student(
                        name: name,
                        course: course,
                        mobile: mobile,
                        totalFee: int.parse(totalFee),
                        feePaid: int.parse(feePaid),
                        date: dateController.text,
                      );
                      int result = await DatabaseHelper.instance.insertStudent(s);

                      if (result > 0) {
                        Fluttertoast.showToast(msg: "Record Saved", backgroundColor: Colors.green);
                      } else {
                        Fluttertoast.showToast(msg: "Record Failed", backgroundColor: Colors.red);
                      }
                    }
                  },
                  child: const Text('Save'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                      return const StudentsListScreen();
                    }));
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
