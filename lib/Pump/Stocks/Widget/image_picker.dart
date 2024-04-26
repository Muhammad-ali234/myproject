// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';

// class ImagePickerScreen extends StatefulWidget {
//   final Function(String) onTextExtracted;

//   const ImagePickerScreen({super.key, required this.onTextExtracted});

//   @override
//   _ImagePickerScreenState createState() => _ImagePickerScreenState();
// }

// class _ImagePickerScreenState extends State<ImagePickerScreen> {
//   bool _isProcessing = false;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         _openCamera(context);
//       },
//       child: Column(
//         children: [
//           Stack(
//             alignment: Alignment.center,
//             children: [
//               Container(
//                 height: 50,
//                 width: 50,
//                 decoration: const BoxDecoration(
//                   color: Color.fromARGB(255, 190, 190, 190),
//                 ),
//                 child: const Icon(Icons.camera_alt),
//               ),
//               if (_isProcessing)
//                 const CircularProgressIndicator(), // Display circular progress indicator while processing
//             ],
//           ),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }

//   Future<void> _openCamera(BuildContext context) async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.camera);

//     if (pickedFile != null) {
//       setState(() {
//         _isProcessing = true;
//       });

//       final inputImage = InputImage.fromFilePath(pickedFile.path);
//       final textRecognizer = GoogleMlKit.vision.textRecognizer();
//       final RecognizedText recognizedText =
//           await textRecognizer.processImage(inputImage);

//       String extractedText = recognizedText.text;

//       // Pass the extracted text to the parent widget using the callback function
//       widget.onTextExtracted(extractedText);

//       setState(() {
//         _isProcessing = false;
//       });
//     } else {
//       // User canceled the picker
//       print('Image capture from camera canceled');
//     }
//   }
// }
