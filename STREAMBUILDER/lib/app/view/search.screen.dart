import 'package:flutter/material.dart';
import 'package:vicyos_music/app/common/color_extension.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isTyping = false;

  void _onTextChanged(String text) {
    setState(() {
      _isTyping = text.isNotEmpty;
    });
  }

  void _clearSearch() {
    _controller.clear();
    setState(() {
      _isTyping = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff181B2C), // Dark background
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff181B2C),
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(
            splashRadius: 20,
            onPressed: () async {
              Navigator.pop(context);
            },
            icon: Image.asset(
              "assets/img/arrow_back_ios.png",
              color: TColor.lightGray,
              height: 20,
              width: 20,
            ),
          ),
        ),
        title: TextField(
          controller: _controller,
          onChanged: _onTextChanged, // Detect text change
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: const TextStyle(color: Colors.white60),
            filled: true,
            fillColor: const Color(0xff24273A), // TextField background
            contentPadding: const EdgeInsets.only(
                left: 16, right: 48, top: 12, bottom: 12), // Adjust padding
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            suffixIcon: Padding(
              padding:
                  const EdgeInsets.only(right: 8), // Small space for the icon
              child: _isTyping
                  ? IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed: _clearSearch, // Clear text when "X" is pressed
                    )
                  : const Icon(Icons.search,
                      color: Colors.white70), // Search icon when empty
            ),
          ),
        ),
      ),
      body: const Center(
        child: Text('Screen content',
            style: TextStyle(
                color: Colors.white)), // Placeholder for screen content
      ),
    );
  }
}
