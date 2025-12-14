import 'dart:math';

import 'package:architect_nexus/features/learning/data/models/learning_module_model.dart';
import 'package:architect_nexus/features/learning/data/models/module_slide_model.dart';
import 'package:architect_nexus/features/learning/domain/entities/learning_module.dart' as entities;

class LearningRemoteDataSource {
  Future<List<LearningModuleModel>> fetchModules() async {
    await Future.delayed(_simulatedNetworkDelay());
    return _remoteLearningModules;
  }

  Future<List<ModuleSlideModel>> fetchSlides() async {
    await Future.delayed(_simulatedNetworkDelay());
    return _remoteLearningSlides;
  }

  Duration _simulatedNetworkDelay() {
    final milliseconds = 500 + Random().nextInt(600);
    return Duration(milliseconds: milliseconds);
  }
}

final _remoteLearningModules = <LearningModuleModel>[
  LearningModuleModel(
    id: 'neural_networks_intro',
    title: 'Build Your First Neural Network',
    description:
        'Learn the fundamentals of neurons, activation functions, and backpropagation through an interactive walkthrough.',
    thumbnailUrl: 'assets/images/neural_network.png',
    tags: ['AI', 'Python', 'Deep Learning'],
    estimatedMinutes: 12,
    totalSlides: 6,
    difficulty: entities.ModuleDifficulty.intermediate,
    publishedAt: DateTime(2024, 11, 2),
    isExploreCurated: true,
  ),
  LearningModuleModel(
    id: 'quantum_basics',
    title: 'Quantum Computing Crash Course',
    description:
        'Understand qubits, superposition, and quantum circuits using hands-on visualizations.',
    thumbnailUrl: 'assets/images/quantum.png',
    tags: ['Quantum', 'Physics', 'Research'],
    estimatedMinutes: 9,
    totalSlides: 5,
    difficulty: entities.ModuleDifficulty.advanced,
    publishedAt: DateTime(2024, 10, 15),
    isExploreCurated: true,
  ),
  LearningModuleModel(
    id: 'cyber_defense_intro',
    title: 'Cyber Defense Ops 101',
    description:
        'Deploy zero trust, detect anomalies, and run blue-team drills with Spark as your co-analyst.',
    thumbnailUrl: 'assets/images/cyber_defense.png',
    tags: ['Security', 'Ops', 'Zero Trust'],
    estimatedMinutes: 8,
    totalSlides: 4,
    difficulty: entities.ModuleDifficulty.beginner,
    publishedAt: DateTime(2024, 12, 1),
    isExploreCurated: false,
  ),
];

final _remoteLearningSlides = <ModuleSlideModel>[
  ModuleSlideModel(
    id: 'cyber_slide_1',
    moduleId: 'cyber_defense_intro',
    order: 0,
    type: entities.SlideType.text,
    title: 'Threat Landscape',
    content:
        'Modern breaches pivot fast. Adaptive monitoring + automated response buys precious minutes.',
  ),
  ModuleSlideModel(
    id: 'cyber_slide_2',
    moduleId: 'cyber_defense_intro',
    order: 1,
    type: entities.SlideType.code,
    title: 'Detect Suspicious IPs',
    content: 'Streaming query in Python to spotlight lateral movement attempts.',
    codeSnippet:
        'import pandas as pd\nalerts = df[df["geo_risk"] > 0.8]\nalerts.groupby("source_ip").size().sort_values(ascending=False)[:5]',
    codeLanguage: 'python',
  ),
  ModuleSlideModel(
    id: 'cyber_slide_3',
    moduleId: 'cyber_defense_intro',
    order: 2,
    type: entities.SlideType.text,
    title: 'Zero Trust Rituals',
    content:
        'Continuously verify device posture + user intent. Session lifetimes shrink as risk spikes.',
  ),
  ModuleSlideModel(
    id: 'cyber_slide_4',
    moduleId: 'cyber_defense_intro',
    order: 3,
    type: entities.SlideType.text,
    title: 'Blue-Team Drill',
    content:
        'Simulate a runaway token. Practice revocation, blast radius mapping, and stakeholder alerts.',
  ),
];
