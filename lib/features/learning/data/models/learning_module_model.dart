import 'package:architect_nexus/features/learning/domain/entities/learning_module.dart';
import 'package:hive/hive.dart';

class LearningModuleModel extends HiveObject {
  LearningModuleModel({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.tags,
    required this.estimatedMinutes,
    required this.totalSlides,
    required this.difficulty,
    required this.publishedAt,
    this.isExploreCurated = false,
  });

  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final List<String> tags;
  final int estimatedMinutes;
  final int totalSlides;
  final ModuleDifficulty difficulty;
  final DateTime publishedAt;
  final bool isExploreCurated;

  LearningModule toEntity() {
    return LearningModule(
      id: id,
      title: title,
      description: description,
      thumbnailUrl: thumbnailUrl,
      tags: tags,
      estimatedMinutes: estimatedMinutes,
      totalSlides: totalSlides,
      difficulty: difficulty,
      publishedAt: publishedAt,
      isExploreCurated: isExploreCurated,
    );
  }

  static LearningModuleModel fromEntity(LearningModule module) {
    return LearningModuleModel(
      id: module.id,
      title: module.title,
      description: module.description,
      thumbnailUrl: module.thumbnailUrl,
      tags: module.tags,
      estimatedMinutes: module.estimatedMinutes,
      totalSlides: module.totalSlides,
      difficulty: module.difficulty,
      publishedAt: module.publishedAt,
      isExploreCurated: module.isExploreCurated,
    );
  }
}

class LearningModuleModelAdapter extends TypeAdapter<LearningModuleModel> {
  @override
  final int typeId = 1;

  @override
  LearningModuleModel read(BinaryReader reader) {
    final fields = reader.readMap().cast<String, dynamic>();
    return LearningModuleModel(
      id: fields['id'] as String,
      title: fields['title'] as String,
      description: fields['description'] as String,
      thumbnailUrl: fields['thumbnailUrl'] as String,
      tags: (fields['tags'] as List).cast<String>(),
      estimatedMinutes: fields['estimatedMinutes'] as int,
      totalSlides: fields['totalSlides'] as int,
      difficulty: ModuleDifficulty.values[fields['difficulty'] as int],
      publishedAt: DateTime.fromMillisecondsSinceEpoch(fields['publishedAt'] as int),
      isExploreCurated: fields['isExploreCurated'] as bool? ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, LearningModuleModel obj) {
    writer.writeMap({
      'id': obj.id,
      'title': obj.title,
      'description': obj.description,
      'thumbnailUrl': obj.thumbnailUrl,
      'tags': obj.tags,
      'estimatedMinutes': obj.estimatedMinutes,
      'totalSlides': obj.totalSlides,
      'difficulty': obj.difficulty.index,
      'publishedAt': obj.publishedAt.millisecondsSinceEpoch,
      'isExploreCurated': obj.isExploreCurated,
    });
  }
}
