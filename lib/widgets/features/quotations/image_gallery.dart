import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solar_warehouse_system/providers/quotations.dart';
import 'package:solar_warehouse_system/helpers/image_util.dart';

class ImageGallery extends StatefulWidget {
  ImageGallery({Key key}) : super(key: key);

  @override
  _ImageGalleryState createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  bool _isLoading = false;

  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quotationsProvider = context.read<Quotations>();
    final _imageUrls = quotationsProvider.imageUrls;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton(
            onPressed: _isLoading
                ? () {}
                : () async {
                    final images = await pickImage(context);
                    setState(() {
                      _isLoading = true;
                    });
                    await quotationsProvider.uploadQuotationImages(images);
                    setState(() {
                      _isLoading = false;
                    });
                  },
            child: (!_isLoading)
                ? Text('Upload Images')
                : Text('Uploading images. Please wait...'),
          ),
        ),
        _imageUrls.isEmpty
            ? Center(
                child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('No images yet'),
              ))
            : _buildImages([
                ..._imageUrls.map((image) => _buildImage(context, image)),
              ]),
      ],
    );
  }

  _buildImage(BuildContext context, String imageUrl) {
    final quotationsProvider = context.read<Quotations>();
    return Card(
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              height: 200,
            ),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: InkWell(
              onTap: () {
                quotationsProvider.removeImagesFromEditedQuotation(imageUrl);
              },
              child: ClipOval(
                child: Container(
                  width: 25,
                  height: 25,
                  color: Colors.black,
                  child: Icon(
                    Icons.clear,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildImages(List<Widget> images) {
    return Container(
      width: 600,
      height: 300,
      child: GridView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return images[index];
        },
      ),
    );
  }
}