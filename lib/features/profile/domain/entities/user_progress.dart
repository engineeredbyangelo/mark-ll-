/// User Progress Entity (Domain Layer)
class UserProgress {
  final String userId;
  final Map<String, ModuleProgress> moduleProgress;
  final List<String> savedModules;
  final Map<String, int> skillPoints; // skill tag -> points
  final int totalCompletedModules;

  const UserProgress({
    required this.userId,
    required this.moduleProgress,
    required this.savedModules,
    required this.skillPoints,
    required this.totalCompletedModules,
  });
}

class ModuleProgress {
  final String moduleId;
  final int currentSlide;
  final int totalSlides;
  final bool isCompleted;
  final DateTime? completedAt;
  final DateTime lastAccessedAt;
  final bool isBookmarked;

  const ModuleProgress({
    required this.moduleId,
    required this.currentSlide,
    required this.totalSlides,
    required this.isCompleted,
    this.completedAt,
    required this.lastAccessedAt,
    this.isBookmarked = false,
  });

  double get progressPercentage => (currentSlide / totalSlides) * 100;
}
