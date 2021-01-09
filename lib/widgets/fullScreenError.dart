import 'package:flutter/material.dart';

class FullScreenErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            Text('Something went wrong'),
          ],
        ),
      ),
    );
  }
}
