import 'package:flutter/material.dart';
import 'package:dance_scoring/pages/HomePage/star_page.dart';

class HomePage extends StatelessWidget {
  final List<String> _images = [
    "https://picsum.photos/id/1018/300/200",
    "https://picsum.photos/id/1015/300/200",
    "https://picsum.photos/id/1059/300/200"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            height: 280.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(0.0),
                  child: Image.network(_images[index]),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              children: [
                _buildButton(context, "明星"),
                _buildButton(context, "赛事"),
                _buildButton(context, "相册"),
                _buildButton(context, "推荐"),
                _buildButton(context, "待定"),
                _buildButton(context, "待定"),
                _buildButton(context, "待定"),
                _buildButton(context, "待定"),
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String label) {
    return Container(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: CircleBorder(),
          backgroundColor: Colors.lightBlue[100],
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/$label');
        },
        child: Text(label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}