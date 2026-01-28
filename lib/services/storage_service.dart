import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/index.dart';

class StorageService {
  static const String _claimsKey = 'claims';
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Claims operations
  Future<List<Claim>> getAllClaims() async {
    try {
      final String? claimsJson = _prefs.getString(_claimsKey);
      if (claimsJson == null) {
        return [];
      }
      final List<dynamic> decoded = jsonDecode(claimsJson);
      return decoded.map((claim) => Claim.fromJson(claim)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<Claim?> getClaimById(String id) async {
    try {
      final claims = await getAllClaims();
      return claims.firstWhere((claim) => claim.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> saveClaim(Claim claim) async {
    try {
      final claims = await getAllClaims();
      final index = claims.indexWhere((c) => c.id == claim.id);
      
      if (index != -1) {
        claims[index] = claim;
      } else {
        claims.add(claim);
      }
      
      final String encoded = jsonEncode(claims.map((c) => c.toJson()).toList());
      await _prefs.setString(_claimsKey, encoded);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> deleteClaim(String id) async {
    try {
      final claims = await getAllClaims();
      claims.removeWhere((claim) => claim.id == id);
      
      final String encoded = jsonEncode(claims.map((c) => c.toJson()).toList());
      await _prefs.setString(_claimsKey, encoded);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> clearAllClaims() async {
    try {
      await _prefs.remove(_claimsKey);
    } catch (e) {
      // Handle error silently
    }
  }
}
