import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const CourseDdlApp());
}

class AppColors {
  static const paper = Color(0xFFF1E4C3);
  static const paperLight = Color(0xFFFBF6E9);
  static const ink = Color(0xFF25241F);
  static const mutedInk = Color(0xFF746D5D);
  static const line = Color(0xFFB9AA88);
}

class CourseDdlApp extends StatelessWidget {
  const CourseDdlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '纸间 DDL',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.paper,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.ink).copyWith(
          primary: AppColors.ink,
          onPrimary: AppColors.paperLight,
          surface: AppColors.paperLight,
          onSurface: AppColors.ink,
          outline: AppColors.line,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.paper,
          foregroundColor: AppColors.ink,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.paperLight,
          hintStyle: const TextStyle(color: AppColors.mutedInk),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.line),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.line),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.ink, width: 1.5),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.ink,
          foregroundColor: AppColors.paperLight,
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: AppColors.ink,
          contentTextStyle: TextStyle(color: AppColors.paperLight),
        ),
      ),
      home: const SplashPage(),
    );
  }
}

class CheckItem {
  CheckItem(this.text, {this.done = false});

  String text;
  bool done;
}

class DdlNote {
  DdlNote({
    required this.id,
    required this.title,
    required this.course,
    required this.content,
    required this.dueDate,
    required this.updatedAt,
    this.imagePath,
    this.isCompleted = false,
    this.isPinned = false,
    List<CheckItem>? items,
  }) : items = items ?? [];

  final String id;
  String title;
  String course;
  String content;
  DateTime dueDate;
  DateTime updatedAt;
  String? imagePath;
  bool isCompleted;
  bool isPinned;
  final List<CheckItem> items;
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 2400),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed && mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(builder: (_) => const HomePage()),
            );
          }
        });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              const Spacer(),
              const Text(
                '纸间',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 10,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '课程 DDL 备忘',
                style: TextStyle(
                  color: AppColors.mutedInk,
                  fontSize: 16,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 48),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final value = Curves.easeOut.transform(_controller.value);
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 14 * (1 - value)),
                      child: Transform.rotate(
                        angle: -0.16 + value * 0.16,
                        child: child,
                      ),
                    ),
                  );
                },
                child: const Icon(
                  Icons.edit_outlined,
                  size: 92,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 12),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    size: const Size(180, 24),
                    painter: SketchLinePainter(
                      progress: Curves.easeInOut.transform(_controller.value),
                    ),
                  );
                },
              ),
              const Spacer(),
              const Text(
                '把要做的事，一笔一划记下来',
                style: TextStyle(color: AppColors.mutedInk, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SketchLinePainter extends CustomPainter {
  const SketchLinePainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(0, size.height * 0.7)
      ..quadraticBezierTo(
        size.width * progress * 0.45,
        0,
        size.width * progress,
        size.height * 0.55,
      );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(SketchLinePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final List<DdlNote> _notes = _sampleNotes();

  static List<DdlNote> _sampleNotes() {
    final now = DateTime.now();
    return [
      DdlNote(
        id: 'sample-flutter',
        title: '完成本地存储作业',
        course: '移动应用开发实训',
        content: '完成主题记忆、CRUD 和关键词搜索，整理关键代码与运行截图。',
        dueDate: now.add(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(hours: 2)),
        isPinned: true,
        items: [
          CheckItem('完成主题记忆', done: true),
          CheckItem('完成便签增删改查'),
          CheckItem('检查搜索与空结果提示'),
        ],
      ),
      DdlNote(
        id: 'sample-data-structure',
        title: '第 3 章课后练习',
        course: '数据结构',
        content: '完成链表与栈相关习题，标记仍然不理解的题目。',
        dueDate: now.add(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 1)),
        items: [CheckItem('选择题'), CheckItem('算法设计题')],
      ),
      DdlNote(
        id: 'sample-english',
        title: '英语阅读打卡',
        course: '大学英语',
        content: '完成 Unit 4 阅读并整理生词。',
        dueDate: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 2)),
        isCompleted: true,
        items: [CheckItem('阅读文章', done: true), CheckItem('整理生词', done: true)],
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DdlNote> get _visibleNotes {
    final keyword = _searchController.text.trim().toLowerCase();
    final notes = _notes.where((note) {
      if (keyword.isEmpty) return true;
      return note.title.toLowerCase().contains(keyword) ||
          note.course.toLowerCase().contains(keyword) ||
          note.content.toLowerCase().contains(keyword);
    }).toList();
    notes.sort((a, b) {
      if (a.isPinned != b.isPinned) return a.isPinned ? -1 : 1;
      if (a.isCompleted != b.isCompleted) return a.isCompleted ? 1 : -1;
      return a.dueDate.compareTo(b.dueDate);
    });
    return notes;
  }

  Future<void> _openEditor([DdlNote? note]) async {
    final result = await Navigator.of(context).push<DdlNote>(
      MaterialPageRoute(builder: (_) => NoteEditorPage(note: note)),
    );
    if (result == null) return;
    setState(() {
      if (note == null) {
        _notes.add(result);
      } else {
        final index = _notes.indexWhere((item) => item.id == result.id);
        if (index != -1) _notes[index] = result;
      }
    });
  }

  void _deleteNote(DdlNote note) {
    setState(() => _notes.removeWhere((item) => item.id == note.id));
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('便签已删除')));
  }

  @override
  Widget build(BuildContext context) {
    final visibleNotes = _visibleNotes;
    final unfinished = _notes.where((note) => !note.isCompleted).length;
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '纸间',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
            ),
            Text(
              '课程 DDL 备忘',
              style: TextStyle(fontSize: 12, color: AppColors.mutedInk),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Center(
              child: Text(
                '待完成 $unfinished',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: '搜索课程、主题或内容',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isEmpty
                      ? null
                      : IconButton(
                          tooltip: '清空搜索',
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                          icon: const Icon(Icons.close),
                        ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 22),
              child: Row(
                children: [
                  Icon(Icons.push_pin_outlined, size: 15),
                  SizedBox(width: 6),
                  Text(
                    '重点置顶 · 点击卡片继续记录',
                    style: TextStyle(fontSize: 12, color: AppColors.mutedInk),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: visibleNotes.isEmpty
                  ? const _EmptyNotes()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 90),
                      itemCount: visibleNotes.length,
                      itemBuilder: (context, index) {
                        final note = visibleNotes[index];
                        return TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: 1),
                          duration: Duration(
                            milliseconds: 350 + (index > 5 ? 350 : index * 70),
                          ),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, 24 * (1 - value)),
                                child: child,
                              ),
                            );
                          },
                          child: DdlCard(
                            note: note,
                            onTap: () => _openEditor(note),
                            onToggle: () => setState(() {
                              note.isCompleted = !note.isCompleted;
                            }),
                            onTogglePin: () => setState(() {
                              note.isPinned = !note.isPinned;
                            }),
                            onDelete: () => _deleteNote(note),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: '新增 DDL 便签',
        onPressed: _openEditor,
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }
}

class _EmptyNotes extends StatelessWidget {
  const _EmptyNotes();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book_outlined, size: 54, color: AppColors.mutedInk),
            SizedBox(height: 16),
            Text(
              '没有找到相关便签',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              '换个关键词，或点击右下角记一笔',
              style: TextStyle(color: AppColors.mutedInk),
            ),
          ],
        ),
      ),
    );
  }
}

class DdlCard extends StatelessWidget {
  const DdlCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onToggle,
    required this.onTogglePin,
    required this.onDelete,
  });

  final DdlNote note;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onTogglePin;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final doneItems = note.items.where((item) => item.done).length;
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 0,
      color: note.isCompleted ? AppColors.paper : AppColors.paperLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: note.isPinned ? AppColors.ink : AppColors.line,
          width: note.isPinned ? 1.4 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    tooltip: note.isCompleted ? '标为待完成' : '标为已完成',
                    onPressed: onToggle,
                    icon: Icon(
                      note.isCompleted
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: AppColors.ink,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${formatDate(note.dueDate)} · ${dueLabel(note)}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: note.isCompleted
                            ? AppColors.mutedInk
                            : AppColors.ink,
                      ),
                    ),
                  ),
                  if (note.isPinned)
                    const Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: Icon(Icons.push_pin, size: 18),
                    ),
                  PopupMenuButton<String>(
                    tooltip: '更多操作',
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == 'pin') onTogglePin();
                      if (value == 'delete') onDelete();
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'pin',
                        child: Text(note.isPinned ? '取消置顶' : '重点置顶'),
                      ),
                      const PopupMenuItem(value: 'delete', child: Text('删除便签')),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (note.course.isNotEmpty)
                      Text(
                        note.course,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.mutedInk,
                          letterSpacing: 1,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      note.title,
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        decoration: note.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: note.isCompleted
                            ? AppColors.mutedInk
                            : AppColors.ink,
                      ),
                    ),
                    if (note.content.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        note.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          height: 1.5,
                          color: AppColors.mutedInk,
                        ),
                      ),
                    ],
                    if (note.items.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: note.items.isEmpty
                            ? 0
                            : doneItems / note.items.length,
                        minHeight: 3,
                        color: AppColors.ink,
                        backgroundColor: AppColors.line,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '条目 $doneItems/${note.items.length}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.mutedInk,
                        ),
                      ),
                    ],
                    if (note.imagePath != null) ...[
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: Image.file(
                            File(note.imagePath!),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    Text(
                      '最近编辑 ${formatEditedAt(note.updatedAt)}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.mutedInk,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NoteEditorPage extends StatefulWidget {
  const NoteEditorPage({super.key, this.note});

  final DdlNote? note;

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _CheckItemDraft {
  _CheckItemDraft(CheckItem item)
    : controller = TextEditingController(text: item.text),
      done = item.done;

  _CheckItemDraft.empty() : controller = TextEditingController();

  final TextEditingController controller;
  bool done = false;
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _courseController;
  late final TextEditingController _contentController;
  late final DateTime _initialDueDate;
  late DateTime _dueDate;
  late bool _isPinned;
  late List<_CheckItemDraft> _items;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    final note = widget.note;
    _titleController = TextEditingController(text: note?.title ?? '');
    _courseController = TextEditingController(text: note?.course ?? '');
    _contentController = TextEditingController(text: note?.content ?? '');
    _initialDueDate =
        note?.dueDate ?? DateTime.now().add(const Duration(days: 1));
    _dueDate = _initialDueDate;
    _isPinned = note?.isPinned ?? false;
    _imagePath = note?.imagePath;
    _items = note?.items.map(_CheckItemDraft.new).toList() ?? [];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _courseController.dispose();
    _contentController.dispose();
    for (final item in _items) {
      item.controller.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      helpText: '选择 DDL 日期',
      cancelText: '取消',
      confirmText: '确定',
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  Future<void> _pickImage() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 90,
      );
      if (image != null && mounted) {
        setState(() => _imagePath = image.path);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('暂时无法选择图片，请检查相册权限')));
      }
    }
  }

  void _save() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('请先填写主题概要')));
      return;
    }
    final items = _items
        .where((draft) => draft.controller.text.trim().isNotEmpty)
        .map(
          (draft) => CheckItem(draft.controller.text.trim(), done: draft.done),
        )
        .toList();
    Navigator.of(context).pop(
      DdlNote(
        id: widget.note?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        course: _courseController.text.trim(),
        content: _contentController.text.trim(),
        dueDate: _dueDate,
        updatedAt: DateTime.now(),
        imagePath: _imagePath,
        isCompleted: widget.note?.isCompleted ?? false,
        isPinned: _isPinned,
        items: items,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? '新增便签' : '编辑便签'),
        actions: [
          IconButton(
            tooltip: _isPinned ? '取消重点标注' : '标为重点',
            onPressed: () => setState(() => _isPinned = !_isPinned),
            icon: Icon(_isPinned ? Icons.push_pin : Icons.push_pin_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                decoration: const InputDecoration(hintText: '主题概要（必填）'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _courseController,
                decoration: const InputDecoration(
                  hintText: '课程名称，例如：数据结构',
                  prefixIcon: Icon(Icons.menu_book_outlined),
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: _pickDueDate,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.paperLight,
                    border: Border.all(color: AppColors.line),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.event_outlined),
                      const SizedBox(width: 12),
                      const Expanded(child: Text('DDL 日期')),
                      Text(
                        formatDate(_dueDate),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const _SectionTitle(title: '详细记录'),
              const SizedBox(height: 8),
              TextField(
                controller: _contentController,
                minLines: 4,
                maxLines: 7,
                decoration: const InputDecoration(
                  hintText: '记录作业要求、注意事项或解题思路……',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Expanded(child: _SectionTitle(title: '条目清单')),
                  TextButton.icon(
                    onPressed: () {
                      setState(() => _items.add(_CheckItemDraft.empty()));
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('添加条目'),
                  ),
                ],
              ),
              if (_items.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    '可将作业拆成多项，逐项打勾。',
                    style: TextStyle(color: AppColors.mutedInk),
                  ),
                ),
              ..._items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return Container(
                  key: ObjectKey(item),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: AppColors.paperLight,
                    border: Border.all(color: AppColors.line),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                        value: item.done,
                        onChanged: (value) {
                          setState(() => item.done = value ?? false);
                        },
                      ),
                      Expanded(
                        child: TextField(
                          controller: item.controller,
                          decoration: const InputDecoration(
                            hintText: '输入一个待办条目',
                            filled: false,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: '删除条目',
                        onPressed: () {
                          setState(() {
                            final removed = _items.removeAt(index);
                            removed.controller.dispose();
                          });
                        },
                        icon: const Icon(Icons.close, size: 19),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 12),
              const _SectionTitle(title: '图片记录'),
              const SizedBox(height: 8),
              if (_imagePath == null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: AppColors.paperLight,
                    border: Border.all(color: AppColors.line),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.image_outlined,
                        size: 38,
                        color: AppColors.mutedInk,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '封面或笔记图片（可选）',
                        style: TextStyle(color: AppColors.mutedInk),
                      ),
                      TextButton(
                        onPressed: _pickImage,
                        child: const Text('从相册选择'),
                      ),
                    ],
                  ),
                )
              else
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                ImageZoomPage(imagePath: _imagePath!),
                          ),
                        );
                      },
                      child: Container(
                        height: 220,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.paperLight,
                          border: Border.all(color: AppColors.line),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.file(
                          File(_imagePath!),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            '点击图片可双指等比缩放',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.mutedInk,
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.swap_horiz, size: 18),
                          label: const Text('更换'),
                        ),
                        TextButton.icon(
                          onPressed: () => setState(() => _imagePath = null),
                          icon: const Icon(Icons.delete_outline, size: 18),
                          label: const Text('移除'),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(18, 10, 18, 12),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.add_photo_alternate_outlined),
                label: const Text('插入图片'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check),
                label: const Text('完成'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    );
  }
}

class ImageZoomPage extends StatelessWidget {
  const ImageZoomPage({super.key, required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ink,
      appBar: AppBar(
        backgroundColor: AppColors.ink,
        foregroundColor: AppColors.paperLight,
        title: const Text('图片记录'),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return InteractiveViewer(
              minScale: 1,
              maxScale: 5,
              child: SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: Image.file(File(imagePath), fit: BoxFit.contain),
              ),
            );
          },
        ),
      ),
    );
  }
}

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

String _twoDigits(int value) => value.toString().padLeft(2, '0');

String formatDate(DateTime value) {
  return '${value.year}.${_twoDigits(value.month)}.${_twoDigits(value.day)}';
}

String formatEditedAt(DateTime value) {
  return '${value.year}.${_twoDigits(value.month)}.${_twoDigits(value.day)} '
      '${_twoDigits(value.hour)}:${_twoDigits(value.minute)}';
}

String dueLabel(DdlNote note) {
  if (note.isCompleted) return '已完成';
  final days = _dateOnly(note.dueDate)
      .difference(_dateOnly(DateTime.now()))
      .inDays;
  if (days < 0) return '已逾期 ${-days} 天';
  if (days == 0) return '今天截止';
  if (days == 1) return '明天截止';
  return '还剩 $days 天';
}
