// class CreditCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     try {
//       return Container(
//         width: 412,
//         height: 210,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(15),
//           image: DecorationImage(
//             image: AssetImage("assets/intro/card.png"),
//             fit: BoxFit.fill,
//           ),
//           gradient: LinearGradient(
//             colors: [Colors.black87, Colors.grey[900]!],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.3),
//               spreadRadius: 2,
//               blurRadius: 5,
//               offset: Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Stack(children: [
//           Positioned(
//             top: 40,
//             left: 30,
//             child: Text(
//               'Mr. Lalit',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 25,
//                 fontFamily: 'Poppins',
//                 fontWeight: FontWeight.w600,
//                 height: 0.06,
//               ),
//             ),
//           ),
//           Positioned(
//               top: 70,
//               left: 30,
//               child: Container(
//                 width: 60,
//                 height: 60,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage("assets/intro/user_icon.png"),
//                     fit: BoxFit.fill,
//                   ),
//                 ),
//               )),
//           Positioned(
//             top: 70,
//             left: 95,
//             child: Text(
//               'Savings account',
//               style: TextStyle(
//                 color: Colors.grey,
//                 fontSize: 15,
//                 fontFamily: 'Poppins',
//                 fontWeight: FontWeight.w500,
//                 height: 0.06,
//               ),
//             ),
//           ),
//           Positioned(
//             top: 110,
//             left: 95,
//             child: Text(
//               '1400 0101 0990 0909',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 20,
//                 fontFamily: 'Poppins',
//                 fontWeight: FontWeight.w600,
//                 height: 0.06,
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 30,
//             left: 25,
//             child: Row(
//               children: [
//                 Text(
//                   'Exp 22/12',
//                   style: TextStyle(
//                     color: Colors.grey,
//                     fontSize: 12,
//                     fontFamily: 'Poppins',
//                     fontWeight: FontWeight.w500,
//                     height: 0.06,
//                   ),
//                 ),
//                 SizedBox(width: 20),
//                 Text(
//                   'CVV 909',
//                   style: TextStyle(
//                     color: Colors.grey,
//                     fontSize: 12,
//                     fontFamily: 'Poppins',
//                     fontWeight: FontWeight.w500,
//                     height: 0.06,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ]),
//       );
//     } catch (e) {
//       return Text(
//         "Error: $e",
//         style: TextStyle(color: Colors.red),
//       );
//     }
//   }
// }