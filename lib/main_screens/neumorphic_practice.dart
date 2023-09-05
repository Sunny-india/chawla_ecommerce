// import 'package:flutter_neumorphic/flutter_neumorphic.dart';
//
// class PageThree extends StatefulWidget {
//   const PageThree({Key? key}) : super(key: key);
//
//   @override
//   State<PageThree> createState() => _PageThreeState();
// }
//
// class _PageThreeState extends State<PageThree> {
//   bool buttonPressed = true;
//   bool switchValue = true;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: NeumorphicColors.background,
//       // appBar: const CupertinoNavigationBar(
//       //   middle: Text('Chawla Plastics Page Three'),
//       // ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             NeumorphicButton(
//               style: NeumorphicStyle(
//                   depth: buttonPressed ? 10 : 0,
//                   //shape: NeumorphicShape.flat,
//                   boxShape:
//                       NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
//                   color:
//                       buttonPressed ? Colors.pinkAccent : Colors.orangeAccent),
//               onPressed: () {
//                 setState(() {
//                   buttonPressed = !buttonPressed;
//                   print(buttonPressed);
//                 });
//               },
//               child: Text(
//                 'Press',
//                 style: TextStyle(
//                     color: buttonPressed ? Colors.white : Colors.brown,
//                     fontSize: buttonPressed ? 20 : 15),
//               ),
//             ),
//             const SizedBox(height: 20),
//             NeumorphicSwitch(
//               style: NeumorphicSwitchStyle(
//                 trackBorder: NeumorphicBorder(
//                   color: Colors.green,
//                   width: switchValue ? 0 : 1.3,
//                 ),
//                 trackDepth: switchValue ? 0 : 10,
//                 // inactiveThumbColor: Colors.red,
//                 activeThumbColor: Colors.green,
//                 thumbDepth: 1,
//                 // disableDepth: true,
//                 activeTrackColor: Colors.green.shade200,
//                 // inactiveTrackColor: Colors.red.shade200,
//               ),
//               value: switchValue,
//               // isEnabled: true,
//               onChanged: (value) {
//                 setState(() {
//                   switchValue = value;
//                   print(switchValue);
//                 });
//               },
//             ),
//             const SizedBox(height: 20),
//             NeumorphicText(
//               'Hello',
//               textStyle: NeumorphicTextStyle(fontSize: switchValue ? 35 : 25),
//               style: NeumorphicStyle(
//                 depth: 20,
//                 color: switchValue ? Colors.cyan : Colors.red,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(buttonPressed ? 'Pressed' : 'Not Pressed'),
//             const SizedBox(height: 20),
//             const Card(
//               margin: EdgeInsets.symmetric(horizontal: 80),
//               // color: NeumorphicColors.background,
//               elevation: 5,
//               child: ListTile(
//                   title: Text('Name'), subtitle: Text('Mobile Number')),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }
