import 'dart:convert';
import 'dart:typed_data';
import 'package:bluetooth_print_plus/bluetooth_print_plus.dart';
import 'package:flutter/material.dart';
import '../model/student.dart';

class PrintPage extends StatefulWidget {
  final Student student;

  const PrintPage({Key? key, required this.student}) : super(key: key);

  @override
  _PrintPageState createState() => _PrintPageState();
}

class _PrintPageState extends State<PrintPage> {
  BluetoothPrintPlus bluetoothPrint = BluetoothPrintPlus();
  List<BluetoothDevice> _devices = [];
  String _deviceMessage = "No devices found";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initPrinter();
    });
  }

  Future<void> initPrinter() async {
    BluetoothPrintPlus.startScan(timeout: const Duration(seconds: 5));
    BluetoothPrintPlus.scanResults.listen((devices) {
      if (!mounted) return;

      setState(() {
        _devices = devices;
        if (_devices.isEmpty) {
          _deviceMessage = "No devices found";
        }
      });
    });
  }

  Future<void> _startPrint(BluetoothDevice device) async {
    try {
      await BluetoothPrintPlus.connect(device);
      String printData = """
        ID: ${widget.student.id}
        Name: ${widget.student.name}
        Course: ${widget.student.course}
        Mobile: ${widget.student.mobile}
        Total Fee: ${widget.student.totalFee}
        Fee Paid: ${widget.student.feePaid}
        Date: ${widget.student.date}
      """;

      Uint8List encodedData = Uint8List.fromList(utf8.encode(printData));
      await BluetoothPrintPlus.write(encodedData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Print successful')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Print failed: $e')),
      );
    } finally {
      BluetoothPrintPlus.disconnect();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Printer'),
        backgroundColor: Colors.blue,
      ),
      body: _devices.isEmpty
          ? Center(
        child: Text(_deviceMessage),
      )
          : ListView.builder(
        itemCount: _devices.length,
        itemBuilder: (context, index) {
          BluetoothDevice device = _devices[index];
          return ListTile(
            leading: const Icon(Icons.print),
            title: Text(device.name),
            subtitle: Text(device.address),
            onTap: () {
              _startPrint(device);
            },
          );
        },
      ),
    );
  }
}
