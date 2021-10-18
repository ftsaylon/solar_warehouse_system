import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:solar_warehouse_system/models/quotation.dart';
import 'package:solar_warehouse_system/services/quotation_service.dart';
import 'package:solar_warehouse_system/services/uploader_service.dart';

class Quotations extends ChangeNotifier {
  final _quotationsService = GetIt.I<QuotationService>();
  final _uploaderService = GetIt.I<UploaderService>();

  List<Quotation> _quotations = [];
  List<Quotation> get quotations => [..._quotations];
  List<String> _imageUrls = [];
  List<String> get imageUrls => _imageUrls;

  void addImagesToEditedQuotation(List<String> newImageUrls) {
    _imageUrls = [..._imageUrls, ...newImageUrls];
    notifyListeners();
  }

  void setImagesToEditedQuotation(List<String> imageUrls) {
    _imageUrls = imageUrls;
    notifyListeners();
  }

  void removeImagesFromEditedQuotation(String imageUrl) {
    _imageUrls.remove(imageUrl);
    notifyListeners();
  }

  Stream<List<Quotation>> quotationsStream() {
    return _quotationsService.streamQuotations();
  }

  Future<void> fetchAndSetQuotations() async {
    final newQuotations = (_quotations.isEmpty)
        ? await _quotationsService.fetchQuotations()
        : await _quotationsService.fetchQuotations(
            documentSnapshot: _quotations.last.documentSnapshot,
          );

    _quotations.addAll(newQuotations);
    notifyListeners();
  }

  Future<void> addQuotation(Quotation quotation) async {
    final newQuotationDoc = await _quotationsService.addQuotation(quotation);

    if (newQuotationDoc != null) {
      final DateTime dateCreated =
          newQuotationDoc.get('date_created')?.toDate();
      quotation = quotation.copyWith(
        id: newQuotationDoc.id,
        documentSnapshot: newQuotationDoc,
        dateCreated: dateCreated,
        dateOfExpiration: dateCreated.add(Duration(days: 30)),
      );
      _quotations.insert(0, quotation);
      _imageUrls.clear();
      notifyListeners();
    }
  }

  Future<void> updateQuotation(Quotation quotation) async {
    final updatedQuotationDoc =
        await _quotationsService.updateQuotation(quotation);
    if (updatedQuotationDoc != null) {
      quotation = quotation.copyWith(
        documentSnapshot: updatedQuotationDoc,
      );
      final index =
          _quotations.indexWhere((element) => element.id == quotation.id);
      if (index >= 0) _quotations[index] = quotation;
      _imageUrls.clear();
      notifyListeners();
    }
  }

  Future<void> deleteQuotation(Quotation quotation) async {
    await _quotationsService.deleteQuotation(quotation);
    _quotations.removeWhere((element) => element.id == quotation.id);
    notifyListeners();
  }

  Future<void> uploadQuotationImages(
    List<Uint8List> imagesToUpload,
  ) async {
    List<String> imageUrls = [];

    for (var image in imagesToUpload) {
      imageUrls.add(
        await _uploaderService.uploadQuotationImage(image),
      );
    }
  }
}
