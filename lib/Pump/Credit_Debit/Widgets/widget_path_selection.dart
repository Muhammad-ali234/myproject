import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

// Popup widget for path selection
class PathSelectorPopup extends StatefulWidget {
  const PathSelectorPopup({super.key});

  @override
  _PathSelectorPopupState createState() => _PathSelectorPopupState();
}

class _PathSelectorPopupState extends State<PathSelectorPopup> {
  String? selectedPath;

  Future<void> pickPath() async {
    try {
      String? path = await FilePicker.platform.getDirectoryPath();

      if (path != null) {
        setState(() {
          selectedPath = path;
        });
      }
    } catch (e) {
      print("Message error $e");
    }
  }


  void save() {
    Navigator.pop(context, selectedPath);
  }

  void cancel() {
    Navigator.pop(context, null);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Save Location'),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(selectedPath ?? 'No path selected'),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: pickPath,
            child: const Icon(Icons.folder_open),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: cancel,
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: save,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
