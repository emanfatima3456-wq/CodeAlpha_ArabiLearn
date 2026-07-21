import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  int _xp = 0;
  int _streak = 0;
  int _totalCorrect = 0;
  int _totalQuestions = 0;
  int _quizAttempts = 0;
  double _overallProgress = 0;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOut),
    );
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final correct = prefs.getInt('total_correct') ?? 0;
    final total = prefs.getInt('total_questions') ?? 0;
    final progress = total > 0 ? correct / total : 0.0;

    setState(() {
      _xp = prefs.getInt('xp') ?? 0;
      _streak = prefs.getInt('streak') ?? 0;
      _totalCorrect = correct;
      _totalQuestions = total;
      _quizAttempts = prefs.getInt('quiz_attempts') ?? 0;
      _overallProgress = progress;
      _isLoaded = true;
    });

    _progressAnimation = Tween<double>(
      begin: 0,
      end: _overallProgress,
    ).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOut),
    );

    _progressController.forward();
  }

  bool get _isQuizPro => _quizAttempts >= 3;
  bool get _isWordMaster => _totalCorrect >= 20;
  bool get _isWeekStreak => _streak >= 7;
  bool get _isXpHunter => _xp >= 100;

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
      return const Scaffold(
        backgroundColor: Color(0xFF1A1A2E),
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInDown(
                child: const Text(
                  '📈 Progress',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Overall Progress Circle
              FadeInUp(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, Color(0xFF3B82F6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Overall Progress',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      AnimatedBuilder(
                        animation: _progressAnimation,
                        builder: (context, child) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 150,
                                height: 150,
                                child: CircularProgressIndicator(
                                  value: _progressAnimation.value,
                                  backgroundColor: Colors.white24,
                                  valueColor:
                                  const AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                  strokeWidth: 12,
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    '${(_progressAnimation.value * 100).round()}%',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    'Correct',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStat('$_xp', 'XP Earned', '⭐'),
                          _buildStat('$_totalCorrect', 'Correct', '✅'),
                          _buildStat('$_streak', 'Streak', '🔥'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Quiz Stats
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                child: const Text(
                  'Quiz Stats',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              FadeInUp(
                delay: const Duration(milliseconds: 300),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatBox('$_quizAttempts', 'Quizzes\nPlayed',
                          Icons.quiz, AppColors.primary),
                      _buildStatBox(
                          '$_totalCorrect/$_totalQuestions',
                          'Correct\nAnswers',
                          Icons.check_circle,
                          AppColors.success),
                      _buildStatBox('$_xp XP', 'Total\nPoints',
                          Icons.star, AppColors.gold),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Achievements
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: const Text(
                  '🏆 Achievements',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _buildAchievement('🔥', 'Week Streak', _isWeekStreak, '7 days'),
                  _buildAchievement('📚', 'Word Master', _isWordMaster, '20 correct'),
                  _buildAchievement('🧠', 'Quiz Pro', _isQuizPro, '3 quizzes'),
                  _buildAchievement('⭐', 'XP Hunter', _isXpHunter, '100 XP'),
                  _buildAchievement('🏅', 'Champion', _quizAttempts >= 10, '10 quizzes'),
                  _buildAchievement('💎', 'Legend', _xp >= 500, '500 XP'),
                ],
              ),

              const SizedBox(height: 24),

              if (_quizAttempts == 0)
                FadeInUp(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.cardDark,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: AppColors.primary.withOpacity(0.3)),
                    ),
                    child: const Column(
                      children: [
                        Text('🎯', style: TextStyle(fontSize: 40)),
                        SizedBox(height: 8),
                        Text(
                          'No quizzes yet!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Take a quiz to see your progress here',
                          style:
                          TextStyle(color: Colors.white54, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label, String emoji) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildStatBox(
      String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 11),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAchievement(
      String emoji, String title, bool unlocked, String requirement) {
    return Container(
      decoration: BoxDecoration(
        color: unlocked
            ? AppColors.primary.withOpacity(0.2)
            : AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: unlocked
              ? AppColors.primary.withOpacity(0.4)
              : Colors.white12,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            unlocked ? emoji : '🔒',
            style: const TextStyle(fontSize: 28),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: unlocked ? Colors.white : Colors.white24,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            requirement,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 9,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}