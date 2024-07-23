import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_v2/data/data.dart';

Periority _periority = Periority.low;

class EditScreen extends StatelessWidget {
  const EditScreen({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    Box box = Hive.box('taskBox');
    ThemeData themeData = Theme.of(context);
    TextEditingController textController =
        TextEditingController(text: task.name);

    return Scaffold(
      backgroundColor: themeData.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: themeData.colorScheme.surface,
        title: Text(
          "Edit Task",
          style: themeData.textTheme.titleLarge,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            task.name = textController.text;
            task.periority = _periority;
            if (task.isInBox) {
              task.save();
            } else {
              box.add(task);
            }
            Navigator.of(context).pop();
          },
          label: Row(
            children: [
              Text(
                "Save Changes",
                style: themeData.textTheme.titleSmall!
                    .apply(color: themeData.colorScheme.surface),
              ),
              const SizedBox(
                width: 8,
              ),
              const Icon(
                CupertinoIcons.check_mark,
                size: 22,
              )
            ],
          )),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            PeriorityListView(themeData: themeData),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                  hintText: "Add a task for today ...",
                  hintStyle: TextStyle(),
                  border: InputBorder.none),
            )
          ],
        ),
      ),
    );
  }
}

class PeriorityListView extends StatefulWidget {
  const PeriorityListView({
    super.key,
    required this.themeData,
  });

  final ThemeData themeData;

  @override
  State<PeriorityListView> createState() => _PeriorityListViewState();
}

class _PeriorityListViewState extends State<PeriorityListView> {
  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Flexible(
            child: PeriorityItem(
          widget: widget,
          title: "High",
          color: widget.themeData.colorScheme.primary,
          onTap: () {
            setState(() {
              _periority = Periority.high;
            });
          },
          isSelected: _periority == Periority.high,
        )),
        Flexible(
            child: PeriorityItem(
          widget: widget,
          title: "Normal",
          color: const Color(0xffF09819),
          onTap: () {
            setState(() {
              _periority = Periority.normal;
            });
          },
          isSelected: _periority == Periority.normal,
        )),
        Flexible(
            child: PeriorityItem(
          widget: widget,
          title: "Low",
          color: const Color(0xff3BE1F1),
          onTap: () {
            setState(() {
              _periority = Periority.low;
            });
          },
          isSelected: _periority == Periority.low,
        )),
      ],
    );
  }
}

class PeriorityItem extends StatelessWidget {
  const PeriorityItem({
    super.key,
    required this.widget,
    required this.title,
    required this.color,
    required this.onTap,
    required this.isSelected,
  });

  final PeriorityListView widget;
  final String title;
  final Color color;
  final Function() onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 38,
        decoration: BoxDecoration(
            color: widget.themeData.colorScheme.surface,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: widget.themeData.colorScheme.onBackground,
              width: 1,
              // color: themeData.colorScheme.onBackground
            )),
        child: Stack(
          children: [
            Center(
              child: Text(
                title,
                style: widget.themeData.textTheme.titleSmall,
              ),
            ),
            Positioned(
                right: 8,
                bottom: 9.5,
                child: PeriorityCheckMark(
                  widget: widget,
                  color: color,
                  isSelected: isSelected,
                ))
          ],
        ),
      ),
    );
  }
}

class PeriorityCheckMark extends StatelessWidget {
  const PeriorityCheckMark({
    super.key,
    required this.widget,
    required this.color,
    required this.isSelected,
  });

  final PeriorityListView widget;
  final Color color;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(9)),
      child: isSelected
          ? Icon(
              CupertinoIcons.check_mark,
              size: 14,
              color: widget.themeData.colorScheme.surface,
            )
          : null,
    );
  }
}
