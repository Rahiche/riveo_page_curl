import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riveo_page_curl/projects/project.dart';
import 'package:riveo_page_curl/projects/projects_list_item.dart';
import 'package:riveo_page_curl/utils/default_proejcts.dart';

class ProjectsList extends StatefulWidget {
  const ProjectsList({super.key});

  @override
  State<ProjectsList> createState() => _ProjectsListState();
}

class _ProjectsListState extends State<ProjectsList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  late List<Project> projects;

  @override
  void initState() {
    super.initState();
    projects = List.from(defaultProjects);
  }

  void _removeProject(int index) async {
    final removed = projects.removeAt(index);
    const duration = Duration(milliseconds: 800);
    _listKey.currentState!.removeItem(
      index,
      (context, animation) => _buildRemovedItem(index, animation, removed),
      duration: duration,
    );
  }

  Widget _buildRemovedItem(
    int index,
    Animation<double> animation,
    Project removed,
  ) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: animation,
        curve: Curves.elasticOut,
      ).drive(Tween(begin: 0, end: 1)),
      child: ProjectsListItem(
        project: removed,
        onDelete: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      initialItemCount: projects.length,
      itemBuilder: (context, index, animation) {
        return ProjectsListItem(
          key: ValueKey(index),
          onDelete: () => _removeProject(index),
          project: projects[index],
        );
      },
    );
  }
}
