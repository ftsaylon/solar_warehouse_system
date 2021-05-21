import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solar_warehouse_system/providers/quotations.dart';
import 'package:solar_warehouse_system/helpers/image_util.dart';

class ImagePicker extends StatefulWidget {
  ImagePicker({Key key}) : super(key: key);

  @override
  _ImagePickerState createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePicker> {
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
                    final imageUrls =
                        await quotationsProvider.uploadQuotationImages(images);
                    setState(() {
                      _isLoading = false;
                    });
                    quotationsProvider.addImagesToEditedQuotation(imageUrls);
                  },
            child: (!_isLoading)
                ? Text('Upload Images')
                : Text('Uploading images. Please wait...'),
          ),
        ),
        _imageUrls.isEmpty
            ? Center(child: Text('No images yet'))
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
      child: Scrollbar(
        isAlwaysShown: true,
        controller: _scrollController,
        child: GridView.builder(
          controller: _scrollController,
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: images.length,
          itemBuilder: (context, index) {
            return images[index];
          },
        ),
      ),
    );
  }
}
