// features/help_network/data/services/help_offer_service.dart
import '../../domain/entities/help_offer.dart';

/// Service für Help Offer Operationen
class HelpOfferService {
  final List<HelpOffer> _helpOffers = [];

  HelpOfferService() {
    _initializeMockData();
  }

  void _initializeMockData() {
    // Mock Hilfe-Angebote
    _helpOffers.addAll([
      HelpOffer.create(
        helpRequestId: '1754331441373', // ID der ersten Help Request
        helperId: 'helper1',
        helperName: 'Lisa Weber',
        message:
            'Ich kann Ihnen gerne bei den Formularen helfen. Habe Erfahrung mit Behörden.',
      ),
      HelpOffer.create(
        helpRequestId: '1754331441374', // ID der zweiten Help Request
        helperId: 'helper2',
        helperName: 'Dr. Hans Klein',
        message:
            'Ich bin Arzt und kann bei der Übersetzung medizinischer Dokumente helfen.',
      ),
    ]);
  }

  // CRUD Operationen
  Future<List<HelpOffer>> getAllHelpOffers() async {
    await Future.delayed(Duration(milliseconds: 300));
    return List.from(_helpOffers);
  }

  Future<List<HelpOffer>> getHelpOffersByRequest(String requestId) async {
    await Future.delayed(Duration(milliseconds: 200));
    return _helpOffers
        .where((offer) => offer.helpRequestId == requestId)
        .toList();
  }

  Future<List<HelpOffer>> getHelpOffersByStatus(String status) async {
    await Future.delayed(Duration(milliseconds: 200));
    return _helpOffers.where((offer) => offer.status == status).toList();
  }

  Future<List<HelpOffer>> getHelpOffersByHelper(String helperId) async {
    await Future.delayed(Duration(milliseconds: 200));
    return _helpOffers.where((offer) => offer.helperId == helperId).toList();
  }

  Future<HelpOffer?> getHelpOfferById(String id) async {
    await Future.delayed(Duration(milliseconds: 100));
    try {
      return _helpOffers.firstWhere((offer) => offer.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> createHelpOffer(HelpOffer offer) async {
    await Future.delayed(Duration(milliseconds: 200));
    _helpOffers.add(offer);
  }

  Future<void> updateHelpOffer(HelpOffer offer) async {
    await Future.delayed(Duration(milliseconds: 200));
    final index = _helpOffers.indexWhere((o) => o.id == offer.id);
    if (index != -1) {
      _helpOffers[index] = offer;
    }
  }

  Future<void> deleteHelpOffer(String id) async {
    await Future.delayed(Duration(milliseconds: 100));
    _helpOffers.removeWhere((offer) => offer.id == id);
  }

  Future<void> acceptHelpOffer(String offerId) async {
    await Future.delayed(Duration(milliseconds: 300));
    final offerIndex = _helpOffers.indexWhere((o) => o.id == offerId);

    if (offerIndex != -1) {
      final offer = _helpOffers[offerIndex];
      final updatedOffer = offer.copyWith(status: 'accepted');
      _helpOffers[offerIndex] = updatedOffer;
    }
  }

  Future<void> rejectHelpOffer(String offerId) async {
    await Future.delayed(Duration(milliseconds: 200));
    final offerIndex = _helpOffers.indexWhere((o) => o.id == offerId);
    if (offerIndex != -1) {
      final offer = _helpOffers[offerIndex];
      final updatedOffer = offer.copyWith(status: 'rejected');
      _helpOffers[offerIndex] = updatedOffer;
    }
  }

  Future<void> completeHelpOffer(String offerId) async {
    await Future.delayed(Duration(milliseconds: 200));
    final offerIndex = _helpOffers.indexWhere((o) => o.id == offerId);
    if (offerIndex != -1) {
      final offer = _helpOffers[offerIndex];
      final updatedOffer = offer.copyWith(status: 'completed');
      _helpOffers[offerIndex] = updatedOffer;
    }
  }

  Future<void> rateHelpOffer(
      String offerId, double rating, String? review) async {
    await Future.delayed(Duration(milliseconds: 200));
    final offerIndex = _helpOffers.indexWhere((o) => o.id == offerId);
    if (offerIndex != -1) {
      final offer = _helpOffers[offerIndex];
      final updatedOffer = offer.copyWith(
        rating: rating,
        review: review,
      );
      _helpOffers[offerIndex] = updatedOffer;
    }
  }

  Future<List<HelpOffer>> getTopRatedOffers({int limit = 10}) async {
    await Future.delayed(Duration(milliseconds: 300));
    final ratedOffers =
        _helpOffers.where((offer) => offer.rating != null).toList();
    ratedOffers.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
    return ratedOffers.take(limit).toList();
  }

  Future<double> getAverageRatingForHelper(String helperId) async {
    await Future.delayed(Duration(milliseconds: 200));
    final helperOffers = _helpOffers
        .where((offer) => offer.helperId == helperId && offer.rating != null)
        .toList();

    if (helperOffers.isEmpty) return 0.0;

    final totalRating =
        helperOffers.map((offer) => offer.rating ?? 0).reduce((a, b) => a + b);

    return totalRating / helperOffers.length;
  }
}
