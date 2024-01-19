import 'package:flutter/material.dart';

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  String _selectedQuestion = ''; // ตัวแปรเก็บคำถามที่ถูกเลือก
  String _name = '';
  int _age = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dropdown Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            DropdownButton<String>(
              value: _selectedQuestion,
              items: <String>['', 'นามสกุล', 'อายุ'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              hint: Text('เลือกหัวข้อ'),
              onChanged: (String? value) {
                setState(() {
                  _selectedQuestion = value!;
                });
              },
            ),
            SizedBox(height: 16),
            // ตรวจสอบค่าที่ถูกเลือกและแสดงช่องกรอกที่เหมาะสม
            if (_selectedQuestion == 'นามสกุล')
              TextFormField(
                decoration: InputDecoration(labelText: 'ชื่อ'),
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
              ),
            if (_selectedQuestion == 'อายุ')
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'อายุ'),
                onChanged: (value) {
                  setState(() {
                    _age = int.tryParse(value) ?? 0;
                  });
                },
              ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // ทำตามขั้นตอนต่อไป เช่น ส่งข้อมูลไปที่เซิร์ฟเวอร์
                print('Selected Question: $_selectedQuestion');
                print('Name: $_name');
                print('Age: $_age');
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
