import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_v2/data/data.dart';
import 'package:todo_v2/screens/edit/edit.dart';

const String taskBoxName = "taskBox";

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final Box box = Hive.box(taskBoxName);
    final TextEditingController searchBoxController = TextEditingController();
    final ValueNotifier valueNotifier = ValueNotifier("");

    return SafeArea(
      child: Scaffold(
        backgroundColor: themeData.colorScheme.background,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EditScreen(
                        task: Task(),
                      )));
            },
            label: Row(
              children: [
                Text(
                  'Add New Task',
                  style: themeData.textTheme.titleSmall!
                      .apply(color: themeData.colorScheme.onSecondary),
                ),
                const SizedBox(
                  width: 8,
                ),
                const Icon(
                  CupertinoIcons.plus,
                  size: 22,
                )
              ],
            )),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // APP BAR STARTED
              AppBar(
                  themeData: themeData,
                  searchBoxController: searchBoxController,
                  valueNotifier: valueNotifier),
              // END APP BAR
              // CONTENT BODY STARTED
              HomeContent(
                  themeData: themeData,
                  box: box,
                  valueNotifier: valueNotifier,
                  searchBoxController: searchBoxController)
            ],
          ),
        ),
      ),
    );
  }
}

class AppBar extends StatelessWidget {
  const AppBar({
    super.key,
    required this.themeData,
    required this.searchBoxController,
    required this.valueNotifier,
  });

  final ThemeData themeData;
  final TextEditingController searchBoxController;
  final ValueNotifier valueNotifier;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        themeData.colorScheme.primary,
        themeData.colorScheme.secondary
      ])),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "To Do List",
                  style: themeData.textTheme.titleLarge!
                      .apply(color: themeData.colorScheme.onSecondary),
                ),
                Icon(
                  CupertinoIcons.share,
                  color: themeData.colorScheme.onSecondary,
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            // SEARCH BOX STARTED
            SizedBox(
              height: 48,
              child: TextField(
                controller: searchBoxController,
                onChanged: (value) {
                  valueNotifier.value = value;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 0, style: BorderStyle.none),
                      borderRadius: BorderRadius.circular(27.0),
                    ),
                    filled: true,
                    hintStyle:
                        TextStyle(color: themeData.colorScheme.onBackground),
                    hintText: "Search tasks...",
                    fillColor: themeData.colorScheme.surface,
                    prefixIcon: Icon(
                      CupertinoIcons.search,
                      color: themeData.colorScheme.onBackground,
                    )),
              ),
            )
            // END SEARCH BOX
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({
    super.key,
    required this.themeData,
    required this.box,
    required this.valueNotifier,
    required this.searchBoxController,
  });

  final ThemeData themeData;
  final Box box;
  final ValueNotifier valueNotifier;
  final TextEditingController searchBoxController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Today",
                style: themeData.textTheme.titleMedium,
              ),
              const SizedBox(
                height: 4,
              ),
              Container(
                color: themeData.colorScheme.secondary,
                height: 3,
                width: 65,
              )
            ]),
            ElevatedButton(
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(
                      themeData.colorScheme.onBackground),
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xffEAEFF5)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3)))),
              onPressed: () {
                box.clear();
              },
              child: const Row(
                children: [
                  Text(
                    "Delete All",
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Icon(
                    CupertinoIcons.delete_solid,
                    size: 22,
                  ),
                ],
              ),
            )
          ]),
          // LIST VIEW STARTED
          ValueListenableBuilder(
              valueListenable: valueNotifier,
              builder: (context, value, child) {
                return ValueListenableBuilder(
                  valueListenable: box.listenable(),
                  builder: (context, value_, child) {
                    final List items;
                    if (searchBoxController.text.isNotEmpty) {
                      items = box.values
                          .where((element) => element.name.contains(value))
                          .toList();
                    } else {
                      items = box.values.toList();
                    }
                    if (box.isNotEmpty) {
                      return ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 75),
                          itemCount: items.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            Task task = items[index];
                            Color taskColor;
                            switch (task.periority) {
                              case Periority.low:
                                taskColor = const Color(0xff3BE1F1);
                                break;
                              case Periority.normal:
                                taskColor = const Color(0xffF09819);
                                break;
                              case Periority.high:
                                taskColor = themeData.colorScheme.primary;
                                break;
                            }
                            if (items.isNotEmpty) {
                              // TASK ITEM STARTED..
                              return TaskItemView(
                                  themeData: themeData,
                                  task: task,
                                  taskColor: taskColor);
                              // EDN LIST VIEW ITEM
                            } else if (items.isEmpty) {
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 200,
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    "Not found ...",
                                    style: themeData.textTheme.bodyLarge,
                                  )
                                ],
                              );
                            }
                          });
                    } else {
                      return EmptyState(themeData: themeData);
                    }
                  },
                );
              })
        ],
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.themeData,
  });

  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 200,
        ),
        SvgPicture.asset(
          'assets/img/empty_state.svg',
          height: 88,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          "Task is empty",
          style: themeData.textTheme.bodyLarge,
        )
      ],
    );
  }
}

class TaskItemView extends StatefulWidget {
  const TaskItemView({
    super.key,
    required this.themeData,
    required this.task,
    required this.taskColor,
  });

  final ThemeData themeData;
  final Task task;
  final Color taskColor;

  @override
  State<TaskItemView> createState() => _TaskItemViewState();
}

class _TaskItemViewState extends State<TaskItemView> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EditScreen(task: widget.task)));
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
        padding: const EdgeInsets.only(left: 12),
        height: 78,
        decoration: BoxDecoration(
            color: widget.themeData.colorScheme.surface,
            borderRadius: BorderRadius.circular(8)),
        child: Row(children: [
          // CUSTOM CHECK MARK STARTED
          TaskCheckMark(
            themeData: widget.themeData,
            task: widget.task,
            onTap: () {
              setState(() {
                widget.task.isCompleted = !widget.task.isCompleted;
              });
            },
          ), // END CUSTOM CHECK MARK..
          const SizedBox(
            width: 12,
          ),
          Expanded(
              child: Text(
            widget.task.name,
            overflow: TextOverflow.ellipsis,
            style: widget.task.isCompleted
                ? const TextStyle(decoration: TextDecoration.lineThrough)
                : null,
          )),
          Container(
            width: 8,
            decoration: BoxDecoration(
                color: widget.taskColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                )),
          ) // END TASK ITEM
        ]),
      ),
    );
  }
}

class TaskCheckMark extends StatelessWidget {
  const TaskCheckMark({
    super.key,
    required this.themeData,
    required this.onTap,
    required this.task,
  });

  final ThemeData themeData;
  final Function() onTap;
  final Task task;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
            color: task.isCompleted
                ? themeData.colorScheme.primary
                : themeData.colorScheme.surface,
            border: task.isCompleted ? null : Border.all(width: 1),
            borderRadius: BorderRadius.circular(12)),
        child: task.isCompleted
            ? Icon(
                CupertinoIcons.check_mark,
                size: 14,
                color: themeData.colorScheme.surface,
              )
            : null,
      ),
    );
  }
}
