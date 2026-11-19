import 'package:course_ddl/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('开屏后可搜索并新增 DDL 便签', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const CourseDdlApp());
    expect(find.text('把要做的事，一笔一划记下来'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 2500));
    await tester.pumpAndSettle();

    expect(find.text('课程 DDL 备忘'), findsOneWidget);
    expect(find.text('完成本地存储作业'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, '数据结构');
    await tester.pumpAndSettle();
    expect(find.text('第 3 章课后练习'), findsOneWidget);
    expect(find.text('完成本地存储作业'), findsNothing);

    await tester.tap(find.byTooltip('清空搜索'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('新增 DDL 便签'));
    await tester.pumpAndSettle();

    expect(find.text('新增便签'), findsOneWidget);
    await tester.enterText(find.byType(TextField).at(0), '操作系统实验报告');
    await tester.enterText(find.byType(TextField).at(1), '操作系统');
    await tester.tap(find.text('完成'));
    await tester.pumpAndSettle();

    expect(find.text('操作系统实验报告'), findsOneWidget);
  });
}
