import 'package:architect_nexus/features/learning/data/models/learning_module_model.dart';
import 'package:architect_nexus/features/learning/data/models/module_slide_model.dart';
import 'package:architect_nexus/features/learning/domain/entities/learning_module.dart';
import 'package:architect_nexus/features/learning/domain/entities/learning_module.dart' as entities;

final seedLearningModules = <LearningModuleModel>[
  LearningModuleModel(
    id: 'neural_networks_intro',
    title: 'Build Your First Neural Network',
    description:
        'Learn the fundamentals of neurons, activation functions, and backpropagation through an interactive walkthrough.',
    thumbnailUrl: 'assets/images/neural_network.png',
    tags: ['AI', 'Python', 'Deep Learning'],
    estimatedMinutes: 12,
    totalSlides: 6,
    difficulty: ModuleDifficulty.intermediate,
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
    difficulty: ModuleDifficulty.advanced,
    publishedAt: DateTime(2024, 10, 15),
    isExploreCurated: false,
  ),
];

final seedLearningSlides = <ModuleSlideModel>[
  ModuleSlideModel(
    id: 'nn_slide_1',
    moduleId: 'neural_networks_intro',
    order: 0,
    type: entities.SlideType.text,
    title: 'Neural Nets, Simplified',
    content:
        'Neural networks are layered functions that learn weights to map inputs to outputs. Each neuron applies a linear transform followed by a non-linearity.',
  ),
  ModuleSlideModel(
    id: 'nn_slide_2',
    moduleId: 'neural_networks_intro',
    order: 1,
    type: entities.SlideType.code,
    title: 'Forward Pass',
    content: 'This NumPy snippet shows how inputs flow forward:',
    codeSnippet:
        'import numpy as np\n\ndef forward_pass(x, weights, bias):\n    z = np.dot(x, weights) + bias\n    return 1 / (1 + np.exp(-z))',
    codeLanguage: 'python',
  ),
  ModuleSlideModel(
    id: 'nn_slide_3',
    moduleId: 'neural_networks_intro',
    order: 2,
    type: entities.SlideType.text,
    title: 'Activation Functions',
    content:
        'Common activations include ReLU, sigmoid, and tanh. They introduce non-linearity so your model can learn complex decision boundaries.',
  ),
  ModuleSlideModel(
    id: 'nn_slide_4',
    moduleId: 'neural_networks_intro',
    order: 3,
    type: entities.SlideType.text,
    title: 'Backpropagation',
    content:
        'Backprop uses calculus to compute gradients for each weight. Optimizers like Adam adjust weights using those gradients.',
  ),
  ModuleSlideModel(
    id: 'nn_slide_5',
    moduleId: 'neural_networks_intro',
    order: 4,
    type: entities.SlideType.text,
    title: 'Try It',
    content:
        'Open the notebook attached to this module and tweak layer sizes. Notice how convergence time changes.',
  ),
  ModuleSlideModel(
    id: 'quantum_slide_1',
    moduleId: 'quantum_basics',
    order: 0,
    type: entities.SlideType.text,
    title: 'Meet the Qubit',
    content:
        'A qubit occupies a superposition state |ψ⟩ = α|0⟩ + β|1⟩. Measurement collapses it to either 0 or 1.',
  ),
  ModuleSlideModel(
    id: 'quantum_slide_2',
    moduleId: 'quantum_basics',
    order: 1,
    type: entities.SlideType.code,
    title: 'Bloch Sphere Plot',
    content: 'Use Qiskit to visualize superposition states:',
    codeSnippet:
        'from qiskit import QuantumCircuit\nfrom qiskit.visualization import plot_bloch_multivector\n\nqc = QuantumCircuit(1)\nqc.h(0)\nstate = Statevector.from_instruction(qc)\nplot_bloch_multivector(state)',
    codeLanguage: 'python',
  ),
  ModuleSlideModel(
    id: 'quantum_slide_3',
    moduleId: 'quantum_basics',
    order: 2,
    type: entities.SlideType.text,
    title: 'Entanglement',
    content:
        'Entangled qubits share state. Measuring one instantly reveals information about the other, regardless of distance.',
  ),
  ModuleSlideModel(
    id: 'quantum_slide_4',
    moduleId: 'quantum_basics',
    order: 3,
    type: entities.SlideType.text,
    title: 'Quantum Circuits',
    content:
        'Quantum gates (H, X, CX) rotate qubit states on the Bloch sphere. Circuits compose gates sequentially.',
  ),
  ModuleSlideModel(
    id: 'quantum_slide_5',
    moduleId: 'quantum_basics',
    order: 4,
    type: entities.SlideType.text,
    title: 'Next Steps',
    content: 'Experiment with Grover’s algorithm to feel the speed-up VS classical search.',
  ),
];
