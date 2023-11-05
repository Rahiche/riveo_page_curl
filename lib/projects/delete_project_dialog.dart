import 'package:flutter/cupertino.dart';

class DeleteProjectDialog extends StatelessWidget {
  const DeleteProjectDialog({
    Key? key,
    required this.onCancel,
    required this.onDelete,
  }) : super(key: key);

  final Future<void> Function() onCancel;
  final Future<void> Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Delete Project'),
      content: const Text('Are you sure you want to delete this project?'),
      actions: <Widget>[
        CupertinoDialogAction(
          onPressed: onCancel,
          child: const Text('Cancel'),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: onDelete,
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
