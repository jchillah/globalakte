// features/help_network/data/services/help_statistics_service.dart
import '../../domain/entities/help_offer.dart';
import '../../domain/entities/help_request.dart';

/// Service für Help Statistics Operationen
class HelpStatisticsService {
  final List<HelpRequest> _helpRequests;
  final List<HelpOffer> _helpOffers;

  HelpStatisticsService(this._helpRequests, this._helpOffers);

  // Statistik Operationen
  Future<Map<String, dynamic>> getNetworkStatistics() async {
    await Future.delayed(Duration(milliseconds: 500));

    final totalRequests = _helpRequests.length;
    final openRequests = _helpRequests.where((r) => r.status == 'open').length;
    final completedRequests =
        _helpRequests.where((r) => r.status == 'completed').length;
    final activeHelpers =
        _helpOffers.where((o) => o.status == 'accepted').length;

    final categories = _getCategoryStatistics();
    final topHelpers = await getTopHelpers();

    return {
      'totalRequests': totalRequests,
      'openRequests': openRequests,
      'completedRequests': completedRequests,
      'activeHelpers': activeHelpers,
      'categories': categories,
      'topHelpers': topHelpers,
    };
  }

  Future<List<Map<String, dynamic>>> getTopHelpers({int limit = 10}) async {
    await Future.delayed(Duration(milliseconds: 300));

    final helperStats = <String, Map<String, dynamic>>{};

    for (final offer in _helpOffers) {
      if (!helperStats.containsKey(offer.helperId)) {
        helperStats[offer.helperId] = {
          'helperId': offer.helperId,
          'helperName': offer.helperName,
          'acceptedOffers': 0,
          'totalOffers': 0,
          'averageRating': 0.0,
          'ratings': <double>[],
        };
      }

      final stats = helperStats[offer.helperId]!;
      stats['totalOffers'] = (stats['totalOffers'] as int) + 1;

      if (offer.status == 'accepted') {
        stats['acceptedOffers'] = (stats['acceptedOffers'] as int) + 1;
      }

      if (offer.rating != null) {
        (stats['ratings'] as List<double>).add(offer.rating!);
      }
    }

    // Berechne Durchschnittsbewertungen
    for (final stats in helperStats.values) {
      final ratings = stats['ratings'] as List<double>;
      if (ratings.isNotEmpty) {
        stats['averageRating'] =
            ratings.reduce((a, b) => a + b) / ratings.length;
      }
      stats.remove('ratings');
    }

    final sortedHelpers = helperStats.values.toList();
    sortedHelpers.sort((a, b) =>
        (b['acceptedOffers'] as int).compareTo(a['acceptedOffers'] as int));

    return sortedHelpers.take(limit).toList();
  }

  Future<Map<String, dynamic>> getCategoryStatistics() async {
    await Future.delayed(Duration(milliseconds: 200));
    return _getCategoryStatistics();
  }

  Future<Map<String, dynamic>> getUserHelpStats(String userId) async {
    await Future.delayed(Duration(milliseconds: 300));

    final userRequests =
        _helpRequests.where((r) => r.requesterId == userId).toList();
    final userOffers = _helpOffers.where((o) => o.helperId == userId).toList();

    final totalRequests = userRequests.length;
    final completedRequests =
        userRequests.where((r) => r.status == 'completed').length;
    final totalOffers = userOffers.length;
    final acceptedOffers =
        userOffers.where((o) => o.status == 'accepted').length;

    double averageRating = 0.0;
    final ratedOffers = userOffers.where((o) => o.rating != null).toList();
    if (ratedOffers.isNotEmpty) {
      final totalRating =
          ratedOffers.map((o) => o.rating!).reduce((a, b) => a + b);
      averageRating = totalRating / ratedOffers.length;
    }

    return {
      'totalRequests': totalRequests,
      'completedRequests': completedRequests,
      'totalOffers': totalOffers,
      'acceptedOffers': acceptedOffers,
      'averageRating': averageRating,
      'completionRate':
          totalRequests > 0 ? (completedRequests / totalRequests) * 100 : 0.0,
      'acceptanceRate':
          totalOffers > 0 ? (acceptedOffers / totalOffers) * 100 : 0.0,
    };
  }

  Future<Map<String, dynamic>> getRequestTrends() async {
    await Future.delayed(Duration(milliseconds: 400));

    final now = DateTime.now();
    final lastWeek = now.subtract(Duration(days: 7));
    final lastMonth = now.subtract(Duration(days: 30));

    final requestsLastWeek =
        _helpRequests.where((r) => r.createdAt.isAfter(lastWeek)).length;

    final requestsLastMonth =
        _helpRequests.where((r) => r.createdAt.isAfter(lastMonth)).length;

    final urgentRequests = _helpRequests.where((r) => r.isUrgent).length;

    return {
      'requestsLastWeek': requestsLastWeek,
      'requestsLastMonth': requestsLastMonth,
      'urgentRequests': urgentRequests,
      'totalRequests': _helpRequests.length,
    };
  }

  Future<List<Map<String, dynamic>>> getHelperPerformance() async {
    await Future.delayed(Duration(milliseconds: 300));

    final helperStats = <String, Map<String, dynamic>>{};

    for (final offer in _helpOffers) {
      if (!helperStats.containsKey(offer.helperId)) {
        helperStats[offer.helperId] = {
          'helperId': offer.helperId,
          'helperName': offer.helperName,
          'totalOffers': 0,
          'acceptedOffers': 0,
          'completedOffers': 0,
          'averageRating': 0.0,
          'totalRating': 0.0,
          'ratingCount': 0,
        };
      }

      final stats = helperStats[offer.helperId]!;
      stats['totalOffers'] = (stats['totalOffers'] as int) + 1;

      if (offer.status == 'accepted') {
        stats['acceptedOffers'] = (stats['acceptedOffers'] as int) + 1;
      }

      if (offer.status == 'completed') {
        stats['completedOffers'] = (stats['completedOffers'] as int) + 1;
      }

      if (offer.rating != null) {
        stats['totalRating'] = (stats['totalRating'] as double) + offer.rating!;
        stats['ratingCount'] = (stats['ratingCount'] as int) + 1;
      }
    }

    // Berechne Durchschnittsbewertungen
    for (final stats in helperStats.values) {
      final ratingCount = stats['ratingCount'] as int;
      if (ratingCount > 0) {
        stats['averageRating'] = (stats['totalRating'] as double) / ratingCount;
      }
      stats.remove('totalRating');
      stats.remove('ratingCount');
    }

    final sortedHelpers = helperStats.values.toList();
    sortedHelpers.sort((a, b) =>
        (b['averageRating'] as double).compareTo(a['averageRating'] as double));

    return sortedHelpers;
  }

  Map<String, dynamic> _getCategoryStatistics() {
    final categoryStats = <String, Map<String, dynamic>>{};

    for (final request in _helpRequests) {
      if (!categoryStats.containsKey(request.category)) {
        categoryStats[request.category] = {
          'category': request.category,
          'totalRequests': 0,
          'openRequests': 0,
          'completedRequests': 0,
          'urgentRequests': 0,
        };
      }

      final stats = categoryStats[request.category]!;
      stats['totalRequests'] = (stats['totalRequests'] as int) + 1;

      if (request.status == 'open') {
        stats['openRequests'] = (stats['openRequests'] as int) + 1;
      } else if (request.status == 'completed') {
        stats['completedRequests'] = (stats['completedRequests'] as int) + 1;
      }

      if (request.isUrgent) {
        stats['urgentRequests'] = (stats['urgentRequests'] as int) + 1;
      }
    }

    // Berechne Completion Rates
    for (final stats in categoryStats.values) {
      final total = stats['totalRequests'] as int;
      final completed = stats['completedRequests'] as int;
      stats['completionRate'] = total > 0 ? (completed / total) * 100 : 0.0;
    }

    return categoryStats;
  }
}
