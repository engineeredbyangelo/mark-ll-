/// Learning Module Entity (Domain Layer)
class LearningModule {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final List<String> tags;
  final int estimatedMinutes;
  final int totalSlides;
  final ModuleDifficulty difficulty;
  final DateTime publishedAt;

  const LearningModule({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.tags,
    required this.estimatedMinutes,
    required this.totalSlides,
    required this.difficulty,
    required this.publishedAt,
  });
}

enum ModuleDifficulty {
  beginner,
  intermediate,
  advanced,
}

/// Module Slide Entity
class ModuleSlide {
  final String id;
  final String moduleId;
  final int order;
  final SlideType type;
  final String title;
  final String content;
  final String? codeSnippet;
  final String? codeLanguage;
  final String? imageUrl;

  const ModuleSlide({
    required this.id,
    required this.moduleId,
    required this.order,
    required this.type,
    required this.title,
    required this.content,
    this.codeSnippet,
    this.codeLanguage,
    this.imageUrl,
  });
}

enum SlideType {
  text,
  code,
  image,
  interactive,
}
