import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    final List<String> images =
    List<String>.from(product['images'].map((img) => img['src']));

    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
        backgroundColor: Color(0xFF006400),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Carousel des images
            CarouselSlider(
              items: images.map((img) {
                return Image.network(img, fit: BoxFit.cover);
              }).toList(),
              options: CarouselOptions(
                height: 300.0,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.8,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Prix: ${product['price']} FCFA',
                    style: TextStyle(fontSize: 20, color: Colors.green),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Description: ${product['description']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
