
import 'package:bluetooth_print_plus/bluetooth_print_plus.dart';
import 'package:flutter/material.dart';
import '../model/student.dart';

class PrintPage extends StatefulWidget {
  final Student student;
  const PrintPage({super.key , required this.student});

  @override
  State<PrintPage> createState() => _PrintPageState();
}

class _PrintPageState extends State<PrintPage> {

  BluetoothPrintPlus bluetoothPrint = BluetoothPrintPlus();
  List<BluetoothDevice> _devices = [];
  String _devicesMsg = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => {initPrinter()});
  }

  Future<void> initPrinter() async {
    await BluetoothPrintPlus.startScan(timeout: Duration(seconds: 10));

    if (!mounted) return;
    BluetoothPrintPlus.scanResults.listen(
          (val) {
        if (!mounted) return;
        setState(() => {_devices = val});
        if (_devices.isEmpty)
          setState(() {
            _devicesMsg = "No Devices";
          });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Printer'),
        backgroundColor: Colors.redAccent,
      ),
      body: _devices.isEmpty
          ? Center(
        child: Text(_devicesMsg ?? ''),
      )
          : ListView.builder(
        itemCount: _devices.length,
        itemBuilder: (c, i) {
          return ListTile(
            leading: Icon(Icons.print),
            title: Text(_devices[i].name.toString()),
            subtitle: Text(_devices[i].address.toString()),
            onTap: () {
              _startPrint(_devices[i]);
            },
          );
        },
      ),
    );
  }
  Future<void> _startPrint(BluetoothDevice device) async {
    if (device != null && device.address != null) {
      await BluetoothPrintPlus.connect(device);




    }
  }
}
