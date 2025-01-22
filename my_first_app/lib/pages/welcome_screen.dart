import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_first_app/services/auth_service.dart';

enum AgeRange {
  under18('<18'),
  under30('18-29'),
  under45('30-44'),
  under60('45-59'),
  over60('60+');

  final String label;
  const AgeRange(this.label);
}

enum Allergy {
  peanuts('Peanuts 🥜', 'Including peanut oil'),
  treeNuts('Tree Nuts 🌰', 'Almonds, cashews, walnuts'),
  dairy('Dairy 🥛', 'Milk, cheese, yogurt'),
  eggs('Eggs 🥚', 'All egg products'),
  soy('Soy 🫘', 'Including soy sauce'),
  wheat('Wheat 🌾', 'Bread, pasta'),
  fish('Fish 🐟', 'All fish types'),
  shellfish('Shellfish 🦐', 'Shrimp, crab, lobster'),
  sesame('Sesame 🫘', 'Seeds and oils'),
  gluten('Gluten 🌾', 'Wheat, barley, rye');

  final String label;
  final String description;
  const Allergy(this.label, this.description);
}

enum DietaryPreference {
  vegetarian('Vegetarian 🥗', 'No meat'),
  vegan('Vegan 🌱', 'No animal products'),
  pescatarian('Pescatarian 🐟', 'Fish but no meat'),
  keto('Keto 🥑', 'Low-carb, high-fat'),
  paleo('Paleo 🍖', 'Whole foods only'),
  glutenFree('Gluten-Free 🌾', 'No gluten'),
  dairyFree('Dairy-Free 🥛', 'No dairy'),
  halal('Halal 🕌', 'Halal certified'),
  kosher('Kosher ✡️', 'Kosher certified'),
  lowCarb('Low-Carb 🥩', 'Reduced carbs');

  final String label;
  final String description;
  const DietaryPreference(this.label, this.description);
}

enum BasicTaste {
  sweet('Sweet 🍯', 'Desserts, fruits'),
  salty('Salty 🧂', 'Snacks, chips'),
  sour('Sour 🍋', 'Citrus, pickled'),
  bitter('Bitter ☕', 'Coffee, dark chocolate'),
  spicy('Spicy 🌶️', 'Hot peppers, chili'),
  umami('Umami 🍜', 'Savory, meaty'),
  tangy('Tangy 🍊', 'Citrus, vinegar'),
  smoky('Smoky 🔥', 'Grilled, barbecued'),
  herbal('Herbal 🌿', 'Fresh herbs, tea'),
  minty('Minty 🌱', 'Cool, refreshing');

  final String label;
  final String description;
  const BasicTaste(this.label, this.description);
}

enum Gender {
  male('Male 👨', 'For accurate daily calorie needs'),
  female('Female 👩', 'For accurate daily calorie needs'),
  other('Other 🧑', 'For accurate daily calorie needs');

  final String label;
  final String description;
  const Gender(this.label, this.description);
}

enum FitnessGoal {
  weightLoss('Weight Loss 📉', 'Reduce body weight gradually'),
  weightGain('Weight Gain 📈', 'Build muscle and gain weight'),
  maintenance('Maintain Weight ⚖️', 'Keep current weight stable'),
  athletic('Athletic Performance 🏃', 'Optimize for sports/fitness'),
  healthy('Healthy Living 🥗', 'Focus on overall wellness'),
  muscle('Build Muscle 💪', 'Increase strength and muscle mass');

  final String label;
  final String description;
  const FitnessGoal(this.label, this.description);
}

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  AgeRange? _selectedAgeRange;
  final Set<Allergy> _selectedAllergies = {};
  final Set<DietaryPreference> _selectedDiets = {};
  final Set<BasicTaste> _selectedBasicTastes = {};
  int _currentPage = 0;
  Gender? _selectedGender;
  final Set<FitnessGoal> _selectedGoals = {};

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _validateAndContinue() {
    // Remove validation and just continue
    _pageController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Add this method to handle back navigation
  void _handleBack() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Update the skip handler to only skip one page
  void _handleSkip() {
    _pageController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Update the skip button widget
  Widget _buildSkipButton() {
    // Don't show on welcome and final page only
    if (_currentPage == 0 || _currentPage == 7) {
      return SizedBox.shrink();
    }
    
    return Positioned(
      top: 48,
      right: 16,
      child: TextButton(
        onPressed: _handleSkip,
        style: TextButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.primary,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        child: Text(
          'Skip',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // Update the back button widget
  Widget _buildBackButton() {
    if (_currentPage == 0) return SizedBox.shrink();
    
    return Positioned(
      top: 48,
      left: 16,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _handleBack,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(30),
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Theme.of(context).colorScheme.primary,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            physics: NeverScrollableScrollPhysics(),
            children: [
              _buildWelcomePage(),
              _buildGenderPage(),
              _buildAgeInputPage(),
              _buildAllergiesPage(),
              _buildDietaryPage(),
              _buildBasicTastesPage(),
              _buildGoalsPage(),
              _buildFinalPage(),
            ],
          ),
          _buildBackButton(),
          _buildSkipButton(),
        ],
      ),
    );
  }

  Widget _buildWelcomePage() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/fridge.svg',
            width: 200,
            height: 200,
          ),
          SizedBox(height: 32),
          Text(
            'Welcome to FridgeAI!',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            'Discover personalized recipes and manage your food inventory efficiently. Let\'s get started by setting up your profile.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 48),
          ElevatedButton(
            onPressed: () {
              _pageController.nextPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: Text('Get Started'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderPage() {
    return _buildPageContainer(
      child: Column(
        children: [
          _buildPageHeader(
            'What\'s your gender?',
            'For accurate daily calorie recommendations'
          ),
          SizedBox(height: 32),

          ...Gender.values.map((gender) => Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedGender = gender;
                  });
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: _selectedGender == gender
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _selectedGender == gender
                        ? Colors.transparent
                        : Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    ),
                    boxShadow: _selectedGender == gender
                      ? [BoxShadow(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        )]
                      : null,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              gender.label,
                              style: TextStyle(
                                color: _selectedGender == gender
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).colorScheme.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              gender.description,
                              style: TextStyle(
                                color: _selectedGender == gender
                                  ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.7)
                                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        _selectedGender == gender
                          ? Icons.check_circle
                          : Icons.arrow_forward_ios,
                        color: _selectedGender == gender
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )).toList(),

          SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildGoalsPage() {
    return _buildPageContainer(
      child: Column(
        children: [
          _buildPageHeader(
            'What are your fitness goals?',
            'Select all that apply'
          ),
          SizedBox(height: 32),

          ...FitnessGoal.values.map((goal) => Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    if (_selectedGoals.contains(goal)) {
                      _selectedGoals.remove(goal);
                    } else {
                      _selectedGoals.add(goal);
                    }
                  });
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: _selectedGoals.contains(goal)
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _selectedGoals.contains(goal)
                        ? Colors.transparent
                        : Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    ),
                    boxShadow: _selectedGoals.contains(goal)
                      ? [BoxShadow(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        )]
                      : null,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              goal.label,
                              style: TextStyle(
                                color: _selectedGoals.contains(goal)
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).colorScheme.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              goal.description,
                              style: TextStyle(
                                color: _selectedGoals.contains(goal)
                                  ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.7)
                                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        _selectedGoals.contains(goal)
                          ? Icons.check_circle
                          : Icons.add_circle_outline,
                        color: _selectedGoals.contains(goal)
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )).toList(),

          SizedBox(height: 32),

          ElevatedButton(
            onPressed: () {
              _pageController.nextPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: Text('Continue'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              minimumSize: Size(200, 50),
            ),
          ),

          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildAgeInputPage() {
    return _buildPageContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPageHeader('What\'s your age range?', 'Help us personalize your experience'),
          SizedBox(height: 48),

          // Age range buttons
          ...AgeRange.values.map((range) => Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: 300,
              height: 65,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedAgeRange = range;
                  });
                  _validateAndContinue();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedAgeRange == range 
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surface,
                  foregroundColor: _selectedAgeRange == range 
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.primary,
                  elevation: _selectedAgeRange == range ? 8 : 0,
                  shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: _selectedAgeRange == range
                        ? Colors.transparent
                        : Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _selectedAgeRange == range
                                ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.2)
                                : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _getAgeIcon(range),
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 16),
                          Text(
                            range.label,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        _selectedAgeRange == range 
                          ? Icons.check_circle
                          : Icons.arrow_forward_ios,
                        size: _selectedAgeRange == range ? 24 : 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )).toList(),
          SizedBox(height: 48),

          // Progress indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) => Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: index == 1 ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: index == 1 
                  ? Theme.of(context).colorScheme.primary 
                  : Theme.of(context).colorScheme.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
            )),
          ),
        ],
      ),
    );
  }

  // Add this helper method to get appropriate icons for each age range
  IconData _getAgeIcon(AgeRange range) {
    switch (range) {
      case AgeRange.under18:
        return Icons.school;
      case AgeRange.under30:
        return Icons.emoji_people;
      case AgeRange.under45:
        return Icons.work;
      case AgeRange.under60:
        return Icons.family_restroom;
      case AgeRange.over60:
        return Icons.elderly;
    }
  }

  Widget _buildPageHeader(String title, String subtitle) {
    return Padding(
      padding: EdgeInsets.fromLTRB(48, 0, 48, 0),
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
              fontSize: 32,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Add this common container wrapper
  Widget _buildPageContainer({required Widget child}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surface.withOpacity(0.9),
          ],
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 60),
            child,
            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildAllergiesPage() {
    return _buildPageContainer(
      child: Column(
        children: [
          _buildPageHeader(
            'Do you have any allergies?',
            'Select all that apply'
          ),
          SizedBox(height: 32),

          // Allergy options
          ...Allergy.values.map((allergy) => Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    if (_selectedAllergies.contains(allergy)) {
                      _selectedAllergies.remove(allergy);
                    } else {
                      _selectedAllergies.add(allergy);
                    }
                  });
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: _selectedAllergies.contains(allergy)
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _selectedAllergies.contains(allergy)
                        ? Colors.transparent
                        : Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    ),
                    boxShadow: _selectedAllergies.contains(allergy)
                      ? [BoxShadow(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        )]
                      : null,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              allergy.label,
                              style: TextStyle(
                                color: _selectedAllergies.contains(allergy)
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).colorScheme.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              allergy.description,
                              style: TextStyle(
                                color: _selectedAllergies.contains(allergy)
                                  ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.7)
                                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        _selectedAllergies.contains(allergy)
                          ? Icons.check_circle
                          : Icons.add_circle_outline,
                        color: _selectedAllergies.contains(allergy)
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )).toList(),

          SizedBox(height: 32),

          ElevatedButton(
            onPressed: () {
              _pageController.nextPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: Text('Continue'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              minimumSize: Size(200, 50),
            ),
          ),

          SizedBox(height: 24),

          // Progress indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) => Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: index == 2 ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: index == 2
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildDietaryPage() {
    return _buildPageContainer(
      child: Column(
        children: [
          _buildPageHeader(
            'What\'s your diet type?',
            'Select all that apply'
          ),
          SizedBox(height: 32),

          // Diet options
          ...DietaryPreference.values.map((diet) => Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    if (_selectedDiets.contains(diet)) {
                      _selectedDiets.remove(diet);
                    } else {
                      _selectedDiets.add(diet);
                    }
                  });
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: _selectedDiets.contains(diet)
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _selectedDiets.contains(diet)
                        ? Colors.transparent
                        : Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    ),
                    boxShadow: _selectedDiets.contains(diet)
                      ? [BoxShadow(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        )]
                      : null,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              diet.label,
                              style: TextStyle(
                                color: _selectedDiets.contains(diet)
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).colorScheme.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              diet.description,
                              style: TextStyle(
                                color: _selectedDiets.contains(diet)
                                  ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.7)
                                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        _selectedDiets.contains(diet)
                          ? Icons.check_circle
                          : Icons.add_circle_outline,
                        color: _selectedDiets.contains(diet)
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )).toList(),

          SizedBox(height: 32),

          ElevatedButton(
            onPressed: () {
              _pageController.nextPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: Text('Continue'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              minimumSize: Size(200, 50),
            ),
          ),

          SizedBox(height: 24),

          // Progress indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) => Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: index == 2 ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: index == 2
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicTastesPage() {
    return _buildPageContainer(
      child: Column(
        children: [
          _buildPageHeader(
            'What basic tastes do you enjoy?',
            'Select all that apply'
          ),
          SizedBox(height: 32),

          // Basic taste options
          ...BasicTaste.values.map((taste) => Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    if (_selectedBasicTastes.contains(taste)) {
                      _selectedBasicTastes.remove(taste);
                    } else {
                      _selectedBasicTastes.add(taste);
                    }
                  });
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: _selectedBasicTastes.contains(taste)
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _selectedBasicTastes.contains(taste)
                        ? Colors.transparent
                        : Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    ),
                    boxShadow: _selectedBasicTastes.contains(taste)
                      ? [BoxShadow(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        )]
                      : null,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              taste.label,
                              style: TextStyle(
                                color: _selectedBasicTastes.contains(taste)
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).colorScheme.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              taste.description,
                              style: TextStyle(
                                color: _selectedBasicTastes.contains(taste)
                                  ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.7)
                                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        _selectedBasicTastes.contains(taste)
                          ? Icons.check_circle
                          : Icons.add_circle_outline,
                        color: _selectedBasicTastes.contains(taste)
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )).toList(),

          SizedBox(height: 32),

          ElevatedButton(
            onPressed: () {
              _pageController.nextPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: Text('Continue'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              minimumSize: Size(200, 50),
            ),
          ),

          SizedBox(height: 24),

          // Progress indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) => Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: index == 2 ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: index == 2
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildFinalPage() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 100,
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(height: 32),
          Text(
            'All Set!',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            'Your profile has been set up successfully.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 48),
          ElevatedButton(
            onPressed: () async {
              await AuthService().completeFirstLogin();
              Navigator.of(context).pushReplacementNamed('/home');
            },
            child: Text('Start Using FridgeAI'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
} 