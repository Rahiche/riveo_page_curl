import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:riveo_page_curl/project.dart';
import 'package:riveo_page_curl/project_card.dart';

class ProjectsList extends StatefulWidget {
  const ProjectsList({super.key});

  @override
  State<ProjectsList> createState() => _ProjectsListState();
}

class _ProjectsListState extends State<ProjectsList> {
  final List<Project> projects = List.from(defaultProjects);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: projects.length,
      clipBehavior: Clip.none,
      addRepaintBoundaries: true,
      itemBuilder: (context, index) {
        return Padding(
          key: ValueKey(index),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            height: 170,
            width: double.infinity,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                CupertinoIcons.delete,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ).animate(effects: [
                    const VisibilityEffect(delay: Duration(milliseconds: 500))
                  ]),
                ),
                Positioned.fill(
                  child: ProjectCard(
                    onDelete: () {
                      projects.removeAt(index);
                      setState(() {});
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      clipBehavior: Clip.hardEdge,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CachedNetworkImage(
                              imageUrl: projects[index].url,
                              progressIndicatorBuilder: (context, url, _) =>
                                  SizedBox.expand(
                                child: Container(
                                  color: Colors.black,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned.fill(
                              child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black26,
                                  Colors.black12,
                                  Colors.transparent
                                ],
                              ),
                            ),
                          )),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              projects[index].title,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 32,
                              color: const Color(0XFF647A9F),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(CupertinoIcons.arrow_down_circle),
                                        SizedBox(width: 4),
                                        Text("2 MB")
                                      ],
                                    ),
                                    Spacer(),
                                    Row(
                                      children: [
                                        Icon(CupertinoIcons.calendar),
                                        SizedBox(width: 4),
                                        Text("just now")
                                      ],
                                    ),
                                    Spacer(),
                                    Row(
                                      children: [
                                        Icon(CupertinoIcons.time),
                                        SizedBox(width: 4),
                                        Text("10m")
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
