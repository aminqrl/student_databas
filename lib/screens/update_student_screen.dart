import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:student_database/db/database_helper.dart';
import 'package:student_database/model/student.dart';

class UpdateStudentScreen extends StatefulWidget {
  final Student student;
  const UpdateStudentScreen({Key? key, required this.student}) : super(key: key);

  @override
  State<UpdateStudentScreen> createState() => UpdateStudentScreenState();
}

class UpdateStudentScreenState extends State<UpdateStudentScreen> {
  var formKey = GlobalKey<FormState>();
  final TextEditingController dateController = TextEditingController();
  late String name, course, mobile, totalFee,feePaid;
  void initStat(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(
              child:
              Text('Update Student')),
        ),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(

                          initialValue: widget.student.name,

                          decoration: InputDecoration(
                              hintText: 'Name',
                              labelText: 'Name',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)
                              )
                          ),
                          validator: ( String? text){
                            if( text == null || text.isEmpty){
                              return 'Please provide name';
                            }
                            name =text;
                            return null;
                          },
                        ),
                        const SizedBox(height: 15,),
                        TextFormField(
                          initialValue: widget.student.course,
                          decoration: InputDecoration(
                              hintText: 'Course',
                              labelText: 'Course',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)
                              )
                          ),
                          validator: ( String? text){
                            if( text == null || text.isEmpty){
                              return 'Please provide course';
                            }
                            course = text;
                            return null;
                          },
                        ),
                        const SizedBox(height: 15,),
                        TextFormField(
                          initialValue: widget.student.mobile,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: 'Mobile',
                              labelText: 'Mobile',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)
                              )
                          ),
                          validator: ( String? text){
                            if( text == null || text.isEmpty){
                              return 'Please provide mobile';
                            }
                            mobile = text;
                            return null;
                          },
                        ),
                        const SizedBox(height: 15,),
                        TextFormField(

                          keyboardType: TextInputType.number,
                          initialValue: widget.student.totalFee.toString(),
                          decoration: InputDecoration(
                              hintText: 'Total Fee',
                              labelText: 'Total Fee',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)
                              )
                          ),
                          validator: ( String? text){
                            if( text == null || text.isEmpty){
                              return 'Please provide Total Fee';
                            }
                            totalFee = text;
                            return null;
                          },
                        ),
                        const SizedBox(height: 15,),
                        TextFormField(
                          initialValue:  widget.student.date.toString(),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: 'Fee Paid',
                              labelText: 'Fee Paid',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)
                              )
                          ),
                          validator: ( String? text){
                            if( text == null || text.isEmpty){
                              return 'Please provide Fee Paid';
                            }
                            feePaid = text;
                            return null;
                          },
                        ),
                        const SizedBox(height: 15,),


                        const SizedBox(height: 15,),
                        ElevatedButton(onPressed: () async {
                          if( formKey.currentState!.validate()){
                            //Update record in DB Table
                            Student s = Student(
                              id: widget.student.id,
                              name: name,
                              course: course,
                              mobile: mobile,
                              totalFee: int.parse(totalFee),
                              feePaid: int.parse(feePaid),
                              date: dateController.text,

                            );

                            int result = await DatabaseHelper.instance.updateStudent(s);
                            if( result > 0){
                              Fluttertoast.showToast(msg: "Record Updated",backgroundColor: Colors.green);
                              Navigator.pop(context,'done');
                            }else{
                              Fluttertoast.showToast(msg: "updating Failed ",backgroundColor: Colors.red);
                            }

                          }
                        }, child: const Text('Update')),



                      ]
                  ),
                )
            )
        )
    );

  }
}


// Future<void> _startPrint(BluetoothDevice device) async {
//   await BluetoothPrintPlus.connect(device);
//   if (!mounted) return ;
//   // Preparing print data
//   List<Map<String, dynamic>> printData = [
//     {'type': 'text', 'content': "Student Details", 'align': 'center', 'linefeed': 1},
//     {'type': 'text', 'content': "Name: ${widget.student.name}", 'linefeed': 1},
//     {'type': 'text', 'content': "Course: ${widget.student.course}", 'linefeed': 1},
//     {'type': 'text', 'content': "Mobile: ${widget.student.mobile}", 'linefeed': 1},
//     {'type': 'text', 'content': "Total Fee: ${widget.student.totalFee}", 'linefeed': 1},
//     {'type': 'text', 'content': "Fee Paid: ${widget.student.feePaid}", 'linefeed': 2},
//   ];
//
//   try {
//     // Use printReceipt to send data
//
//     await BluetoothPrintPlus.print(printData);
//
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Printing successful!')),
//     );
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Printing failed: $e')),
//     );
//   } finally {
//     await BluetoothPrintPlus.disconnect();
//   }
// }