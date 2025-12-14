import 'package:architect_nexus/features/learning/domain/entities/learning_module.dart';
import 'package:hive/hive.dart';

class ModuleSlideModel extends HiveObject {
  ModuleSlideModel({
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

  final String id;
  final String moduleId;
  final int order;
  final SlideType type;
  final String title;
  final String content;
  final String? codeSnippet;
  final String? codeLanguage;
  final String? imageUrl;

  ModuleSlide toEntity() {
    return ModuleSlide(
      id: id,
      moduleId: moduleId,
      order: order,
      type: type,
      title: title,
      content: content,
      codeSnippet: codeSnippet,
      codeLanguage: codeLanguage,
      imageUrl: imageUrl,
    );
  }
}

class ModuleSlideModelAdapter extends TypeAdapter<ModuleSlideModel> {
  @override
  final int typeId = 2;

  @override
  ModuleSlideModel read(BinaryReader reader) {
    final fields = reader.readMap().cast<String, dynamic>();
    return ModuleSlideModel(
      id: fields['id'] as String,
      moduleId: fields['moduleId'] as String,
      order: fields['order'] as int,
      type: SlideType.values[fields['type'] as int],
      title: fields['title'] as String,
      content: fields['content'] as String,
      codeSnippet: fields['codeSnippet'] as String?,
      codeLanguage: fields['codeLanguage'] as String?,
      imageUrl: fields['imageUrl'] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ModuleSlideModel obj) {
    writer.writeMap({
      'id': obj.id,
      'moduleId': obj.moduleId,
      'order': obj.order,
      'type': obj.type.index,
      'title': obj.title,
      'content': obj.content,
      'codeSnippet': obj.codeSnippet,
      'codeLanguage': obj.codeLanguage,
      'imageUrl': obj.imageUrl,
    });
  }
}
