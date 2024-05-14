import 'package:flutter/material.dart';

class CustomSearchWidget extends StatefulWidget {
  final Function(String) onSearch; // Callback when the user searches
  final String hintText; // Placeholder text
  final Color backgroundColor; // Background color of the search box
  final Color iconColor; // Color for the search and clear icons

  const CustomSearchWidget({
    super.key,
    required this.onSearch, // Required callback when search is triggered
    this.hintText = 'Search...', // Default hint text
    this.backgroundColor = Colors.white, // Default background color
    this.iconColor = Colors.black, // Default icon color
  });

  @override
  _CustomSearchWidgetState createState() => _CustomSearchWidgetState();
}

class _CustomSearchWidgetState extends State<CustomSearchWidget> {
  final TextEditingController _controller =
      TextEditingController(); // Controller for TextField

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: widget.iconColor, // Customizable icon color
          ),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: widget.hintText, // Customizable hint text
              border: InputBorder.none, // No border for clean look
            ),
            onChanged: (value) {
              widget.onSearch(value); // Trigger the onSearch callback
            },
          ),
          if (_controller
              .text.isNotEmpty) // Show clear button only if there's text
            IconButton(
              icon: Icon(Icons.clear, color: widget.iconColor), // Clear icon
              onPressed: () {
                _controller.clear(); // Clear the search query
                widget.onSearch(''); // Clear the search results
              },
            ),
        ],
      ),
    );
  }
}
