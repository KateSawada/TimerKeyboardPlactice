import 'package:flutter/material.dart';
// import 'halzoblog/main.dart';
// import 'riverpod/main.dart';

// void main() => runApp(MyApp());

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'riverpod/main.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const RiverpodSample(),
//     );
//   }
// }

// final strProvider = Provider((ref) {
//   return 'Hello Riverpod';
// });

// class RiverpodSample extends ConsumerWidget {
//   const RiverpodSample({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final value = ref.watch(strProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Riverpod Sample'),
//       ),
//       body: Center(
//         child: Text(
//           value,
//           style: const TextStyle(fontSize: 24),
//         ),
//       ),
//     );
//   }
// }
