import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:math';
import '../utils/constants.dart';
import '../data/arabic_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  int _currentIndex = 0;
  int _score = 0;
  int? _selectedAnswer;
  bool _answered = false;
  bool _quizComplete = false;
  List<ArabicWord> _quizWords = [];
  List<List<String>> _options = [];

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
    _initQuiz();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _initQuiz() {
    final words = List<ArabicWord>.from(ArabicData.words)..shuffle();
    _quizWords = words.take(10).toList();
    _options = _quizWords.map((word) {
      final wrong = ArabicData.words
          .where((w) => w.english != word.english)
          .toList()
        ..shuffle();
      final opts = [
        word.english,
        wrong[0].english,
        wrong[1].english,
        wrong[2].english
      ]..shuffle();
      return opts;
    }).toList();
    setState(() {
      _currentIndex = 0;
      _score = 0;
      _selectedAnswer = null;
      _answered = false;
      _quizComplete = false;
    });
  }

  void _selectAnswer(int index) {
    if (_answered) return;
    final correct =
    _options[_currentIndex].indexOf(_quizWords[_currentIndex].english);
    setState(() {
      _selectedAnswer = index;
      _answered = true;
      if (index == correct) {
        _score++;
      } else {
        _shakeController.forward().then((_) => _shakeController.reset());
      }
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (_currentIndex < _quizWords.length - 1) {
        setState(() {
          _currentIndex++;
          _selectedAnswer = null;
          _answered = false;
        });
      } else {
        _saveQuizResult().then((_) {
          setState(() => _quizComplete = true);
        });
      }
    });
  }

  Future<void> _saveQuizResult() async {
    final prefs = await SharedPreferences.getInstance();
    int attempts = prefs.getInt('quiz_attempts') ?? 0;
    await prefs.setInt('quiz_attempts', attempts + 1);
    int totalCorrect = prefs.getInt('total_correct') ?? 0;
    await prefs.setInt('total_correct', totalCorrect + _score);
    int totalQuestions = prefs.getInt('total_questions') ?? 0;
    await prefs.setInt('total_questions', totalQuestions + _quizWords.length);
    int xp = prefs.getInt('xp') ?? 0;
    await prefs.setInt('xp', xp + (_score * 10));
    int streak = prefs.getInt('streak') ?? 0;
    await prefs.setInt('streak', streak + 1);
    int bestScore = prefs.getInt('best_score') ?? 0;
    if (_score > bestScore) {
      await prefs.setInt('best_score', _score);
    }
  }

  Color _getOptionColor(int index) {
    if (!_answered) return AppColors.cardDark;
    final correct =
    _options[_currentIndex].indexOf(_quizWords[_currentIndex].english);
    if (index == correct) return AppColors.success.withValues(alpha: 0.3);
    if (index == _selectedAnswer) return AppColors.error.withValues(alpha: 0.3);
    return AppColors.cardDark;
  }

  Color _getOptionBorder(int index) {
    if (!_answered) return Colors.white12;
    final correct =
    _options[_currentIndex].indexOf(_quizWords[_currentIndex].english);
    if (index == correct) return AppColors.success;
    if (index == _selectedAnswer) return AppColors.error;
    return Colors.white12;
  }

  @override
  Widget build(BuildContext context) {
    if (_quizComplete) return _buildResultScreen();

    final word = _quizWords[_currentIndex];
    final opts = _options[_currentIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInDown(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '🧠 Quiz',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        '⭐ $_score/${_quizWords.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: (_currentIndex + 1) / _quizWords.length,
                  backgroundColor: Colors.white12,
                  valueColor:
                  AlwaysStoppedAnimation<Color>(AppColors.primary),
                  minHeight: 6,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Question ${_currentIndex + 1} of ${_quizWords.length}',
                style: const TextStyle(color: Colors.white38, fontSize: 13),
              ),

              const SizedBox(height: 30),

              FadeInUp(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, Color(0xFF3B82F6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(word.emoji,
                          style: const TextStyle(fontSize: 50)),
                      const SizedBox(height: 16),
                      const Text(
                        'What does this mean?',
                        style:
                        TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        word.arabic,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        word.transliteration,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Expanded(
                child: ListView.builder(
                  itemCount: opts.length,
                  itemBuilder: (context, index) {
                    final isCorrect = _answered &&
                        index ==
                            _options[_currentIndex]
                                .indexOf(_quizWords[_currentIndex].english);
                    final isWrong =
                        _answered && index == _selectedAnswer && !isCorrect;

                    return AnimatedBuilder(
                      animation: _shakeAnimation,
                      builder: (context, child) {
                        double offset = 0;
                        if (isWrong) {
                          offset =
                              sin(_shakeAnimation.value * 3.14159 * 4) * 10;
                        }
                        return Transform.translate(
                          offset: Offset(offset, 0),
                          child: child,
                        );
                      },
                      child: FadeInUp(
                        delay: Duration(milliseconds: 100 * index),
                        child: GestureDetector(
                          onTap: () => _selectAnswer(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: _getOptionColor(index),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _getOptionBorder(index),
                                width: _answered ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      ['A', 'B', 'C', 'D'][index],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Flexible(
                                  child: Text(
                                    opts[index],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                if (_answered)
                                  Icon(
                                    isCorrect
                                        ? Icons.check_circle
                                        : isWrong
                                        ? Icons.cancel
                                        : null,
                                    color: isCorrect
                                        ? AppColors.success
                                        : AppColors.error,
                                    size: 24,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    final percentage = (_score / _quizWords.length * 100).round();
    final emoji = percentage >= 80
        ? '🏆'
        : percentage >= 60
        ? '👍'
        : '💪';
    final message = percentage >= 80
        ? 'Excellent Work!'
        : percentage >= 60
        ? 'Good Job!'
        : 'Keep Practicing!';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BounceInDown(
                child: Text(emoji, style: const TextStyle(fontSize: 80)),
              ),
              const SizedBox(height: 24),
              FadeInUp(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '$_score/${_quizWords.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$percentage% Correct',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _initQuiz,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Try Again 🔄',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}