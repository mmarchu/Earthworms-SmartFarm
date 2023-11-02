import 'package:flutter/material.dart';

class AutoScaleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // รับขนาดหน้าจอจาก MediaQuery
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;

        // คำนวณตัวเล็กสุดที่ควรใช้
        final smallestDimension = screenWidth < screenHeight ? screenWidth : screenHeight;

        // คำนวณขนาดตาม scale factor ที่คุณต้องการ
        final textScaleFactor = smallestDimension / 320; // 320 เป็นขนาดเริ่มต้น

        return Center(
          child: Center(
            child: Column(
              children: [ 
                Text( 'Auto Scaling Text',
                  style: TextStyle(
                  fontSize: 24 * textScaleFactor, // ขนาดข้อความจะเพิ่มหรือลดตามขนาดหน้าจอ
                  ),
                ),
              ]
            ),
          ),
         
        );
      },
    );
  }
}