import 'package:flutter/material.dart';

class DropdownFilterButton extends StatefulWidget {
  final List<String> options; // List of filter options
  final Function(String) onChanged; // Callback for when the selection changes
  final String initialHint; // Initial hint text
  final Color backgroundColor; // Background color of the dropdown
  final Color iconColor; // Icon color

  const DropdownFilterButton({
    Key? key,
    required this.options, // List of filter options
    required this.onChanged, // Required callback
    this.initialHint = 'Select...', // Default hint text
    this.backgroundColor = Colors.blue, // Default background color
    this.iconColor = Colors.white, // Default icon color
  }) : super(key: key);

  @override
  _DropdownFilterButtonState createState() => _DropdownFilterButtonState();
}

class _DropdownFilterButtonState extends State<DropdownFilterButton> {
  String? selectedFilter; // Current selected value

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Padding for aesthetics
      decoration: BoxDecoration(
        color: widget.backgroundColor, // Customizable background color
        borderRadius: BorderRadius.circular(8.0), // Rounded corners
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 2),
            blurRadius: 6.0, // Shadow for 3D effect
          ),
        ],
      ),
      child: DropdownButton<String>(
        hint: Text(
          widget.initialHint,
          style: TextStyle(color: widget.iconColor),
        ), // Hint text with customizable color
        value: selectedFilter, // Current selected value
        icon: Icon(Icons.arrow_drop_down, color: widget.iconColor), // Icon color
        dropdownColor: widget.backgroundColor, // Background color of the dropdown
        underline: Container(), // Remove the default underline
        style: TextStyle(color: widget.iconColor), // Text color
        onChanged: (String? newValue) {
          setState(() {
            selectedFilter = newValue; // Update the selected value
          });
          widget.onChanged(newValue!); // Call the provided callback function
        },
        items: widget.options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option), // Display the option
          );
        }).toList(),
      ),
    );
  }
}
