import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../workout_feedback_cubit.dart';

final class WorkoutFeedbackNoteField extends StatelessWidget {
  const WorkoutFeedbackNoteField({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return TextField(
      minLines: 3,
      maxLines: 3,
      onChanged: context.read<WorkoutFeedbackCubit>().noteChanged,
      style: textTheme.bodyMedium,
      decoration: const InputDecoration(hintText: '다리 가벼웠음, 호흡 안정적...'),
    );
  }
}
