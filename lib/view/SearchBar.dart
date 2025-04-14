import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}
class _CustomSearchBarState extends State<CustomSearchBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          double glowStrength = (0.3 + 0.3 * _controller.value);
          return Container(
            width: screenWidth > 400 ? 300 : screenWidth * 0.85,
            height: screenHeight * 0.07,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(screenWidth * 0.075),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(screenWidth * 0.0375),
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.grey.shade200],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Search...",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: Colors.white),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                            : null,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.020,
                          horizontal: screenWidth * 0.05,
                        ),),
                      onChanged: (value) {
                        setState(() {});
                      },),
                  ),),
                SizedBox(width: screenWidth * 0.025),
                Container(
                  width: screenWidth * 0.1375,
                  height: screenHeight * 0.1375,
                  margin: EdgeInsets.only(right: 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: screenWidth * 0.025,
                        spreadRadius: screenWidth * 0.0025,
                      ),
                    ],),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(screenWidth * 0.0625),
                    onTap: () {
                      print("Searching for: ${_searchController.text}");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(screenWidth * 0.0375),
                        color: Colors.white,
                      ),
                      child: Icon(Icons.search, color: Colors.blueAccent),
                    ),),
                ),],
            ),);
        },),
    );}
}
