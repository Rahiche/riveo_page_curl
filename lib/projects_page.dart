import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:riveo_page_curl/assets.dart';
import 'package:riveo_page_curl/projects_list.dart';

class RiveoProjectsPage extends StatefulWidget {
  const RiveoProjectsPage({super.key});

  @override
  State<RiveoProjectsPage> createState() => _RiveoProjectsPageState();
}

class _RiveoProjectsPageState extends State<RiveoProjectsPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          titleSpacing: 0,
          title: Row(
            children: [
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF3C88F7),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: SvgPicture.string(
                      Assets.cameraIcon,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: SvgPicture.string(
                    Assets.listIcon,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
        backgroundColor: Colors.black,
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            const ProjectsList(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF191919),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                height: 80,
                child: Row(
                  children: [
                    _buildTab(Assets.homeIcon, "Home"),
                    Transform.translate(
                      offset: const Offset(0, -35),
                      child: FloatingActionButton(
                        backgroundColor: const Color(0xFF3C88F7),
                        onPressed: () {},
                        mini: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          CupertinoIcons.plus,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    _buildTab(Assets.projectsIcon, "Projects")
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String icon, String text) {
    final isSelected = text == "Projects";
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16) + const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 28,
              width: 22,
              child: SvgPicture.string(
                icon,
                color: isSelected ? null : const Color(0xFF696969),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF696969),
              ),
            )
          ],
        ),
      ),
    );
  }
}
