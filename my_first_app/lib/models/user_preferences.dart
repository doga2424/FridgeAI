class UserPreferences {
  final String gender;
  final String ageRange;
  final List<String> allergies;
  final List<String> dietaryPreferences;
  final List<String> basicTastes;
  final List<String> fitnessGoals;

  UserPreferences({
    required this.gender,
    required this.ageRange,
    required this.allergies,
    required this.dietaryPreferences,
    required this.basicTastes,
    required this.fitnessGoals,
  });

  Map<String, dynamic> toJson() => {
    'gender': gender,
    'ageRange': ageRange,
    'allergies': allergies,
    'dietaryPreferences': dietaryPreferences,
    'basicTastes': basicTastes,
    'fitnessGoals': fitnessGoals,
  };
} 