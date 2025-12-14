import 'package:architect_nexus/features/profile/domain/entities/user_progress.dart';
import 'package:hive/hive.dart';

class ModuleProgressModel extends HiveObject {
  ModuleProgressModel({
    required this.moduleId,
    required this.currentSlide,
    required this.totalSlides,
    required this.isCompleted,
    this.completedAt,
    required this.lastAccessedAt,
    this.isBookmarked = false,
  });

  final String moduleId;
  final int currentSlide;
  final int totalSlides;
  final bool isCompleted;
  final DateTime? completedAt;
  final DateTime lastAccessedAt;
  final bool isBookmarked;

  ModuleProgress toEntity() {
    return ModuleProgress(
      moduleId: moduleId,
      currentSlide: currentSlide,
      totalSlides: totalSlides,
      isCompleted: isCompleted,
      completedAt: completedAt,
      lastAccessedAt: lastAccessedAt,
      isBookmarked: isBookmarked,
    );
  }

  static ModuleProgressModel fromEntity(ModuleProgress progress) {
    return ModuleProgressModel(
      moduleId: progress.moduleId,
      currentSlide: progress.currentSlide,
      totalSlides: progress.totalSlides,
      isCompleted: progress.isCompleted,
      completedAt: progress.completedAt,
      lastAccessedAt: progress.lastAccessedAt,
      isBookmarked: progress.isBookmarked,
    );
  }
}

class ModuleProgressModelAdapter extends TypeAdapter<ModuleProgressModel> {
  @override
  final int typeId = 3;

  @override
  ModuleProgressModel read(BinaryReader reader) {
    final fields = reader.readMap().cast<String, dynamic>();
    return ModuleProgressModel(
      moduleId: fields['moduleId'] as String,
      currentSlide: fields['currentSlide'] as int,
      totalSlides: fields['totalSlides'] as int,
      isCompleted: fields['isCompleted'] as bool,
      completedAt: fields['completedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(fields['completedAt'] as int)
          : null,
      lastAccessedAt: DateTime.fromMillisecondsSinceEpoch(fields['lastAccessedAt'] as int),
      isBookmarked: fields['isBookmarked'] as bool? ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, ModuleProgressModel obj) {
    writer.writeMap({
      'moduleId': obj.moduleId,
      'currentSlide': obj.currentSlide,
      'totalSlides': obj.totalSlides,
      'isCompleted': obj.isCompleted,
      'completedAt': obj.completedAt?.millisecondsSinceEpoch,
      'lastAccessedAt': obj.lastAccessedAt.millisecondsSinceEpoch,
      'isBookmarked': obj.isBookmarked,
    });
  }
}
