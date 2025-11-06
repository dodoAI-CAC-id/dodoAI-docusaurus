import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:mamoai/shared/presentation/components/atoms/app_button.dart';
import 'package:mamoai/shared/presentation/components/atoms/app_text_field.dart';
import 'package:mamoai/shared/presentation/components/atoms/app_checkbox.dart';
import 'package:mamoai/shared/presentation/components/atoms/app_dropdown.dart';
import 'package:mamoai/shared/presentation/components/atoms/app_icon_button.dart';
import 'package:mamoai/shared/presentation/components/atoms/app_text.dart';
import 'package:mamoai/features/incident_history/domain/entities/incident.dart';
import 'package:mamoai/features/incident_history/presentation/widgets/molecules/incident_list_row.dart';
import 'package:mamoai/features/incident_history/presentation/widgets/molecules/date_range_picker.dart';
import 'package:mamoai/features/incident_history/presentation/widgets/molecules/search_criteria_input.dart';
import 'package:mamoai/features/incident_history/presentation/widgets/molecules/video_player_dialog.dart';
import 'package:mamoai/features/incident_history/presentation/widgets/organisms/search_panel.dart';
import 'package:mamoai/features/incident_history/presentation/widgets/organisms/incident_list_table.dart';
import 'package:mamoai/features/incident_history/presentation/widgets/organisms/pagination_controls.dart';

void main() {
  runApp(const WidgetbookApp());
}

class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      addons: [
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(
              name: 'Light',
              data: ThemeData.light().copyWith(
                primaryColor: Colors.blue,
                colorScheme: ColorScheme.light(
                  primary: Colors.blue,
                  secondary: Colors.blueAccent,
                ),
              ),
            ),
            WidgetbookTheme(
              name: 'Dark',
              data: ThemeData.dark().copyWith(
                primaryColor: Colors.blue,
                colorScheme: ColorScheme.dark(
                  primary: Colors.blue,
                  secondary: Colors.blueAccent,
                ),
              ),
            ),
          ],
        ),
        DeviceFrameAddon(
          devices: [
            Devices.ios.iPhone13,
            Devices.android.samsungGalaxyS20,
            Devices.macOS.macBookPro,
          ],
        ),
      ],
      directories: [
        WidgetbookCategory(
          name: 'Atoms',
          children: [
            WidgetbookComponent(
              name: 'AppButton',
              useCases: [
                WidgetbookUseCase(
                  name: 'Primary',
                  builder: (context) => Center(
                    child: AppButton(
                      text: '検索',
                      onPressed: () {},
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Primary with Icon',
                  builder: (context) => Center(
                    child: AppButton(
                      text: '検索',
                      icon: Icons.search,
                      onPressed: () {},
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Secondary',
                  builder: (context) => Center(
                    child: AppButton(
                      text: 'キャンセル',
                      type: ButtonType.secondary,
                      onPressed: () {},
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Danger',
                  builder: (context) => Center(
                    child: AppButton(
                      text: '削除',
                      type: ButtonType.danger,
                      onPressed: () {},
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Loading',
                  builder: (context) => Center(
                    child: AppButton(
                      text: '読み込み中',
                      isLoading: true,
                      onPressed: () {},
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Disabled',
                  builder: (context) => Center(
                    child: AppButton(
                      text: '無効',
                      onPressed: null,
                    ),
                  ),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'AppTextField',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AppTextField(
                      label: '見守り対象者名',
                      hint: '例: 山田太郎',
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'With Prefix Icon',
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AppTextField(
                      label: '検索',
                      hint: 'キーワードを入力',
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'With Suffix Icon',
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AppTextField(
                      label: '日付',
                      hint: 'yyyy/mm/dd',
                      readOnly: true,
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'With Error',
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AppTextField(
                      label: 'メールアドレス',
                      hint: 'example@example.com',
                      errorText: '正しいメールアドレスを入力してください',
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Disabled',
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AppTextField(
                      label: '無効フィールド',
                      hint: '入力不可',
                      enabled: false,
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Multiline',
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AppTextField(
                      label: 'コメント',
                      hint: 'コメントを入力',
                      maxLines: 5,
                    ),
                  ),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'AppCheckbox',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => Center(
                    child: AppCheckbox(
                      value: false,
                      onChanged: (value) {},
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Checked',
                  builder: (context) => Center(
                    child: AppCheckbox(
                      value: true,
                      onChanged: (value) {},
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'With Label',
                  builder: (context) => Center(
                    child: AppCheckbox(
                      value: false,
                      label: '全て選択',
                      onChanged: (value) {},
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Disabled',
                  builder: (context) => Center(
                    child: AppCheckbox(
                      value: false,
                      enabled: false,
                      onChanged: (value) {},
                    ),
                  ),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'AppDropdown',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AppDropdown<String>(
                      label: 'ステータス',
                      hint: '選択してください',
                      items: const [
                        DropdownMenuItem(value: 'open', child: Text('未対応')),
                        DropdownMenuItem(value: 'resolved', child: Text('対応済み')),
                        DropdownMenuItem(value: 'monitoring', child: Text('監視中')),
                      ],
                      onChanged: (value) {},
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'With Value',
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AppDropdown<String>(
                      label: '異常タイプ',
                      value: '転倒',
                      items: const [
                        DropdownMenuItem(value: '転倒', child: Text('転倒')),
                        DropdownMenuItem(value: '徘徊', child: Text('徘徊')),
                        DropdownMenuItem(value: '離床', child: Text('離床')),
                      ],
                      onChanged: (value) {},
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Disabled',
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AppDropdown<String>(
                      label: 'ステータス',
                      hint: '選択不可',
                      enabled: false,
                      items: const [
                        DropdownMenuItem(value: 'open', child: Text('未対応')),
                      ],
                      onChanged: (value) {},
                    ),
                  ),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'AppIconButton',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => Center(
                    child: AppIconButton(
                      icon: Icons.play_circle,
                      tooltip: '再生',
                      onPressed: () {},
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Small Size',
                  builder: (context) => Center(
                    child: AppIconButton(
                      icon: Icons.download,
                      tooltip: 'ダウンロード',
                      size: 20.0,
                      onPressed: () {},
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Large Size',
                  builder: (context) => Center(
                    child: AppIconButton(
                      icon: Icons.info,
                      tooltip: '詳細',
                      size: 32.0,
                      onPressed: () {},
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Custom Color',
                  builder: (context) => Center(
                    child: AppIconButton(
                      icon: Icons.delete,
                      tooltip: '削除',
                      color: Colors.red,
                      onPressed: () {},
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Disabled',
                  builder: (context) => Center(
                    child: AppIconButton(
                      icon: Icons.edit,
                      tooltip: '編集',
                      onPressed: null,
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Various Icons',
                  builder: (context) => Center(
                    child: Wrap(
                      spacing: 16.0,
                      runSpacing: 16.0,
                      children: [
                        AppIconButton(
                          icon: Icons.play_circle,
                          tooltip: '再生',
                          onPressed: () {},
                        ),
                        AppIconButton(
                          icon: Icons.download,
                          tooltip: 'ダウンロード',
                          onPressed: () {},
                        ),
                        AppIconButton(
                          icon: Icons.info,
                          tooltip: '詳細',
                          onPressed: () {},
                        ),
                        AppIconButton(
                          icon: Icons.search,
                          tooltip: '検索',
                          onPressed: () {},
                        ),
                        AppIconButton(
                          icon: Icons.close,
                          tooltip: '閉じる',
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'AppText',
              useCases: [
                WidgetbookUseCase(
                  name: 'H1 Style',
                  builder: (context) => Center(
                    child: AppText(
                      text: '履歴画面',
                      type: TextStyleType.h1,
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'H2 Style',
                  builder: (context) => Center(
                    child: AppText(
                      text: '検索条件',
                      type: TextStyleType.h2,
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'H3 Style',
                  builder: (context) => Center(
                    child: AppText(
                      text: '検索結果',
                      type: TextStyleType.h3,
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Body1 Style',
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AppText(
                      text: 'これは本文テキストです。Body1スタイルは通常の段落テキストに使用されます。',
                      type: TextStyleType.body1,
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Body2 Style',
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AppText(
                      text: 'これは補足テキストです。Body2スタイルは副次的な情報に使用されます。',
                      type: TextStyleType.body2,
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Caption Style',
                  builder: (context) => Center(
                    child: AppText(
                      text: '※注意事項やキャプション',
                      type: TextStyleType.caption,
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Custom Color',
                  builder: (context) => Center(
                    child: AppText(
                      text: 'カスタムカラーテキスト',
                      type: TextStyleType.body1,
                      color: Colors.blue,
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Text Alignment',
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppText(
                          text: '左揃え',
                          type: TextStyleType.body1,
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 8),
                        AppText(
                          text: '中央揃え',
                          type: TextStyleType.body1,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        AppText(
                          text: '右揃え',
                          type: TextStyleType.body1,
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Max Lines',
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AppText(
                      text: 'これは非常に長いテキストです。最大行数を2行に制限しているため、それ以上の内容は省略記号で表示されます。',
                      type: TextStyleType.body1,
                      maxLines: 2,
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'All Styles Comparison',
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(text: 'H1: 大見出し', type: TextStyleType.h1),
                        const SizedBox(height: 8),
                        AppText(text: 'H2: 中見出し', type: TextStyleType.h2),
                        const SizedBox(height: 8),
                        AppText(text: 'H3: 小見出し', type: TextStyleType.h3),
                        const SizedBox(height: 8),
                        AppText(text: 'Body1: 本文テキスト', type: TextStyleType.body1),
                        const SizedBox(height: 8),
                        AppText(text: 'Body2: 補足テキスト', type: TextStyleType.body2),
                        const SizedBox(height: 8),
                        AppText(text: 'Caption: キャプション', type: TextStyleType.caption),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        WidgetbookCategory(
          name: 'Molecules',
          children: [
            WidgetbookComponent(
              name: 'IncidentListRow',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default (Open Status)',
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: IncidentListRow(
                      incident: Incident(
                        id: 'INC001',
                        detectedAt: DateTime(2025, 10, 20, 14, 30),
                        type: '転倒',
                        personId: 'PERSON001',
                        personName: '山田太郎',
                        roomNumber: '101',
                        status: 'open',
                        videoId: 'VIDEO001',
                        createdAt: DateTime(2025, 10, 20, 14, 30),
                        updatedAt: DateTime(2025, 10, 20, 14, 30),
                      ),
                      isSelected: false,
                      onSelectionChanged: (value) {},
                      onPlayVideo: () {},
                      onDownloadVideo: () {},
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Selected',
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: IncidentListRow(
                      incident: Incident(
                        id: 'INC002',
                        detectedAt: DateTime(2025, 10, 20, 15, 45),
                        type: '徘徊',
                        personId: 'PERSON002',
                        personName: '佐藤花子',
                        roomNumber: '202',
                        status: 'monitoring',
                        videoId: 'VIDEO002',
                        createdAt: DateTime(2025, 10, 20, 15, 45),
                        updatedAt: DateTime(2025, 10, 20, 15, 45),
                      ),
                      isSelected: true,
                      onSelectionChanged: (value) {},
                      onPlayVideo: () {},
                      onDownloadVideo: () {},
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Resolved Status',
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: IncidentListRow(
                      incident: Incident(
                        id: 'INC003',
                        detectedAt: DateTime(2025, 10, 19, 10, 15),
                        type: '離床',
                        personId: 'PERSON003',
                        personName: '鈴木一郎',
                        roomNumber: '303',
                        status: 'resolved',
                        videoId: 'VIDEO003',
                        createdAt: DateTime(2025, 10, 19, 10, 15),
                        updatedAt: DateTime(2025, 10, 19, 11, 30),
                      ),
                      isSelected: false,
                      onSelectionChanged: (value) {},
                      onPlayVideo: () {},
                      onDownloadVideo: () {},
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'No Video',
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: IncidentListRow(
                      incident: Incident(
                        id: 'INC004',
                        detectedAt: DateTime(2025, 10, 21, 8, 0),
                        type: '転倒',
                        personId: 'PERSON004',
                        personName: '田中次郎',
                        roomNumber: '404',
                        status: 'open',
                        videoId: null,
                        createdAt: DateTime(2025, 10, 21, 8, 0),
                        updatedAt: DateTime(2025, 10, 21, 8, 0),
                      ),
                      isSelected: false,
                      onSelectionChanged: (value) {},
                      onPlayVideo: () {},
                      onDownloadVideo: () {},
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Multiple Rows',
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        IncidentListRow(
                          incident: Incident(
                            id: 'INC001',
                            detectedAt: DateTime(2025, 10, 20, 14, 30),
                            type: '転倒',
                            personId: 'PERSON001',
                            personName: '山田太郎',
                            roomNumber: '101',
                            status: 'open',
                            videoId: 'VIDEO001',
                            createdAt: DateTime(2025, 10, 20, 14, 30),
                            updatedAt: DateTime(2025, 10, 20, 14, 30),
                          ),
                          isSelected: false,
                          onSelectionChanged: (value) {},
                          onPlayVideo: () {},
                          onDownloadVideo: () {},
                        ),
                        IncidentListRow(
                          incident: Incident(
                            id: 'INC002',
                            detectedAt: DateTime(2025, 10, 20, 15, 45),
                            type: '徘徊',
                            personId: 'PERSON002',
                            personName: '佐藤花子',
                            roomNumber: '202',
                            status: 'monitoring',
                            videoId: 'VIDEO002',
                            createdAt: DateTime(2025, 10, 20, 15, 45),
                            updatedAt: DateTime(2025, 10, 20, 15, 45),
                          ),
                          isSelected: true,
                          onSelectionChanged: (value) {},
                          onPlayVideo: () {},
                          onDownloadVideo: () {},
                        ),
                        IncidentListRow(
                          incident: Incident(
                            id: 'INC003',
                            detectedAt: DateTime(2025, 10, 19, 10, 15),
                            type: '離床',
                            personId: 'PERSON003',
                            personName: '鈴木一郎',
                            roomNumber: '303',
                            status: 'resolved',
                            videoId: 'VIDEO003',
                            createdAt: DateTime(2025, 10, 19, 10, 15),
                            updatedAt: DateTime(2025, 10, 19, 11, 30),
                          ),
                          isSelected: false,
                          onSelectionChanged: (value) {},
                          onPlayVideo: () {},
                          onDownloadVideo: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'DateRangePicker',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default (No Dates)',
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DateRangePicker(
                      startDate: null,
                      endDate: null,
                      onStartDateChanged: (date) {},
                      onEndDateChanged: (date) {},
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'With Start Date Only',
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DateRangePicker(
                      startDate: DateTime(2025, 10, 1),
                      endDate: null,
                      onStartDateChanged: (date) {},
                      onEndDateChanged: (date) {},
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'With Both Dates',
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DateRangePicker(
                      startDate: DateTime(2025, 10, 1),
                      endDate: DateTime(2025, 10, 31),
                      onStartDateChanged: (date) {},
                      onEndDateChanged: (date) {},
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Interactive',
                  builder: (context) {
                    DateTime? startDate;
                    DateTime? endDate;
                    
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: DateRangePicker(
                            startDate: startDate,
                            endDate: endDate,
                            onStartDateChanged: (date) {
                              setState(() {
                                startDate = date;
                              });
                            },
                            onEndDateChanged: (date) {
                              setState(() {
                                endDate = date;
                              });
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'SearchCriteriaInput',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default (Empty)',
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SearchCriteriaInput(
                      personName: null,
                      incidentType: null,
                      status: null,
                      startDate: null,
                      endDate: null,
                      onPersonNameChanged: (value) {},
                      onIncidentTypeChanged: (value) {},
                      onStatusChanged: (value) {},
                      onStartDateChanged: (date) {},
                      onEndDateChanged: (date) {},
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'With All Values',
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SearchCriteriaInput(
                      personName: '山田太郎',
                      incidentType: '転倒',
                      status: 'open',
                      startDate: DateTime(2025, 10, 1),
                      endDate: DateTime(2025, 10, 31),
                      onPersonNameChanged: (value) {},
                      onIncidentTypeChanged: (value) {},
                      onStatusChanged: (value) {},
                      onStartDateChanged: (date) {},
                      onEndDateChanged: (date) {},
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Partial Values',
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SearchCriteriaInput(
                      personName: '佐藤花子',
                      incidentType: null,
                      status: 'resolved',
                      startDate: null,
                      endDate: null,
                      onPersonNameChanged: (value) {},
                      onIncidentTypeChanged: (value) {},
                      onStatusChanged: (value) {},
                      onStartDateChanged: (date) {},
                      onEndDateChanged: (date) {},
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Interactive',
                  builder: (context) {
                    String? personName;
                    String? incidentType;
                    String? status;
                    DateTime? startDate;
                    DateTime? endDate;

                    return StatefulBuilder(
                      builder: (context, setState) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SearchCriteriaInput(
                            personName: personName,
                            incidentType: incidentType,
                            status: status,
                            startDate: startDate,
                            endDate: endDate,
                            onPersonNameChanged: (value) {
                              setState(() {
                                personName = value;
                              });
                            },
                            onIncidentTypeChanged: (value) {
                              setState(() {
                                incidentType = value;
                              });
                            },
                            onStatusChanged: (value) {
                              setState(() {
                                status = value;
                              });
                            },
                            onStartDateChanged: (date) {
                              setState(() {
                                startDate = date;
                              });
                            },
                            onEndDateChanged: (date) {
                              setState(() {
                                endDate = date;
                              });
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'VideoPlayerDialog',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => Center(
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => VideoPlayerDialog(
                            videoId: 'VIDEO001',
                            incidentId: 'INC001',
                            onClose: () => Navigator.of(context).pop(),
                          ),
                        );
                      },
                      child: const Text('動画ダイアログを開く'),
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Different Incident',
                  builder: (context) => Center(
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => VideoPlayerDialog(
                            videoId: 'VIDEO002',
                            incidentId: 'INC002',
                            onClose: () => Navigator.of(context).pop(),
                          ),
                        );
                      },
                      child: const Text('別のインシデントの動画を開く'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        WidgetbookCategory(
          name: 'Organisms',
          children: [
            WidgetbookComponent(
              name: 'IncidentListTable',
              useCases: [
                WidgetbookUseCase(
                  name: 'Empty State',
                  builder: (context) => IncidentListTable(
                    incidents: const [],
                    selectedIncidentIds: const {},
                    onSelectionChanged: (id, selected) {},
                    onPlayVideo: (id) {},
                    onDownloadVideo: (id) {},
                  ),
                ),
                WidgetbookUseCase(
                  name: 'With Data',
                  builder: (context) => IncidentListTable(
                    incidents: [
                      Incident(
                        id: 'INC001',
                        detectedAt: DateTime(2025, 10, 20, 14, 30),
                        type: '転倒',
                        personId: 'PERSON001',
                        personName: '山田太郎',
                        roomNumber: '101',
                        status: 'open',
                        videoId: 'VIDEO001',
                        createdAt: DateTime(2025, 10, 20, 14, 30),
                        updatedAt: DateTime(2025, 10, 20, 14, 30),
                      ),
                      Incident(
                        id: 'INC002',
                        detectedAt: DateTime(2025, 10, 20, 15, 45),
                        type: '徘徊',
                        personId: 'PERSON002',
                        personName: '佐藤花子',
                        roomNumber: '202',
                        status: 'monitoring',
                        videoId: 'VIDEO002',
                        createdAt: DateTime(2025, 10, 20, 15, 45),
                        updatedAt: DateTime(2025, 10, 20, 15, 45),
                      ),
                      Incident(
                        id: 'INC003',
                        detectedAt: DateTime(2025, 10, 19, 10, 15),
                        type: '離床',
                        personId: 'PERSON003',
                        personName: '鈴木一郎',
                        roomNumber: '303',
                        status: 'resolved',
                        videoId: 'VIDEO003',
                        createdAt: DateTime(2025, 10, 19, 10, 15),
                        updatedAt: DateTime(2025, 10, 19, 11, 30),
                      ),
                    ],
                    selectedIncidentIds: const {},
                    onSelectionChanged: (id, selected) {},
                    onPlayVideo: (id) {},
                    onDownloadVideo: (id) {},
                  ),
                ),
                WidgetbookUseCase(
                  name: 'With Selected Rows',
                  builder: (context) => IncidentListTable(
                    incidents: [
                      Incident(
                        id: 'INC001',
                        detectedAt: DateTime(2025, 10, 20, 14, 30),
                        type: '転倒',
                        personId: 'PERSON001',
                        personName: '山田太郎',
                        roomNumber: '101',
                        status: 'open',
                        videoId: 'VIDEO001',
                        createdAt: DateTime(2025, 10, 20, 14, 30),
                        updatedAt: DateTime(2025, 10, 20, 14, 30),
                      ),
                      Incident(
                        id: 'INC002',
                        detectedAt: DateTime(2025, 10, 20, 15, 45),
                        type: '徘徊',
                        personId: 'PERSON002',
                        personName: '佐藤花子',
                        roomNumber: '202',
                        status: 'monitoring',
                        videoId: 'VIDEO002',
                        createdAt: DateTime(2025, 10, 20, 15, 45),
                        updatedAt: DateTime(2025, 10, 20, 15, 45),
                      ),
                    ],
                    selectedIncidentIds: const {'INC001'},
                    onSelectionChanged: (id, selected) {},
                    onPlayVideo: (id) {},
                    onDownloadVideo: (id) {},
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Interactive',
                  builder: (context) {
                    final incidents = [
                      Incident(
                        id: 'INC001',
                        detectedAt: DateTime(2025, 10, 20, 14, 30),
                        type: '転倒',
                        personId: 'PERSON001',
                        personName: '山田太郎',
                        roomNumber: '101',
                        status: 'open',
                        videoId: 'VIDEO001',
                        createdAt: DateTime(2025, 10, 20, 14, 30),
                        updatedAt: DateTime(2025, 10, 20, 14, 30),
                      ),
                      Incident(
                        id: 'INC002',
                        detectedAt: DateTime(2025, 10, 20, 15, 45),
                        type: '徘徊',
                        personId: 'PERSON002',
                        personName: '佐藤花子',
                        roomNumber: '202',
                        status: 'monitoring',
                        videoId: 'VIDEO002',
                        createdAt: DateTime(2025, 10, 20, 15, 45),
                        updatedAt: DateTime(2025, 10, 20, 15, 45),
                      ),
                      Incident(
                        id: 'INC003',
                        detectedAt: DateTime(2025, 10, 19, 10, 15),
                        type: '離床',
                        personId: 'PERSON003',
                        personName: '鈴木一郎',
                        roomNumber: '303',
                        status: 'resolved',
                        videoId: 'VIDEO003',
                        createdAt: DateTime(2025, 10, 19, 10, 15),
                        updatedAt: DateTime(2025, 10, 19, 11, 30),
                      ),
                    ];

                    return StatefulBuilder(
                      builder: (context, setState) {
                        Set<String> selectedIds = {};

                        return IncidentListTable(
                          incidents: incidents,
                          selectedIncidentIds: selectedIds,
                          onSelectionChanged: (id, selected) {
                            setState(() {
                              if (selected) {
                                selectedIds.add(id);
                              } else {
                                selectedIds.remove(id);
                              }
                            });
                          },
                          onPlayVideo: (id) {
                            print('Play video for incident: $id');
                          },
                          onDownloadVideo: (id) {
                            print('Download video for incident: $id');
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'PaginationControls',
              useCases: [
                WidgetbookUseCase(
                  name: 'First Page',
                  builder: (context) => PaginationControls(
                    currentPage: 1,
                    totalPages: 10,
                    totalCount: 95,
                    onPageChanged: (page) {
                      print('Page changed to: $page');
                    },
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Middle Page',
                  builder: (context) => PaginationControls(
                    currentPage: 5,
                    totalPages: 10,
                    totalCount: 95,
                    onPageChanged: (page) {
                      print('Page changed to: $page');
                    },
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Last Page',
                  builder: (context) => PaginationControls(
                    currentPage: 10,
                    totalPages: 10,
                    totalCount: 95,
                    onPageChanged: (page) {
                      print('Page changed to: $page');
                    },
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Without Total Count',
                  builder: (context) => PaginationControls(
                    currentPage: 3,
                    totalPages: 10,
                    onPageChanged: (page) {
                      print('Page changed to: $page');
                    },
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Interactive',
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        int currentPage = 1;
                        const int totalPages = 10;
                        const int totalCount = 95;

                        return PaginationControls(
                          currentPage: currentPage,
                          totalPages: totalPages,
                          totalCount: totalCount,
                          onPageChanged: (page) {
                            setState(() {
                              currentPage = page;
                            });
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'SearchPanel',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default (Empty)',
                  builder: (context) => SearchPanel(
                    startDate: null,
                    endDate: null,
                    roomNumber: null,
                    personName: null,
                    assignedTo: null,
                    actionType: null,
                    incidentType: null,
                    onStartDateChanged: (date) {},
                    onEndDateChanged: (date) {},
                    onRoomNumberChanged: (value) {},
                    onPersonNameChanged: (value) {},
                    onAssignedToChanged: (value) {},
                    onActionTypeChanged: (value) {},
                    onIncidentTypeChanged: (value) {},
                    onSearch: () {},
                    onClear: () {},
                  ),
                ),
                WidgetbookUseCase(
                  name: 'With Values',
                  builder: (context) => SearchPanel(
                    startDate: DateTime(2025, 10, 1),
                    endDate: DateTime(2025, 10, 31),
                    roomNumber: '101',
                    personName: '山田太郎',
                    assignedTo: '佐藤看護師',
                    actionType: '対応',
                    incidentType: '転倒',
                    onStartDateChanged: (date) {},
                    onEndDateChanged: (date) {},
                    onRoomNumberChanged: (value) {},
                    onPersonNameChanged: (value) {},
                    onAssignedToChanged: (value) {},
                    onActionTypeChanged: (value) {},
                    onIncidentTypeChanged: (value) {},
                    onSearch: () {},
                    onClear: () {},
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Interactive',
                  builder: (context) {
                    DateTime? startDate;
                    DateTime? endDate;
                    String? roomNumber;
                    String? personName;
                    String? assignedTo;
                    String? actionType;
                    String? incidentType;

                    return StatefulBuilder(
                      builder: (context, setState) {
                        return SearchPanel(
                          startDate: startDate,
                          endDate: endDate,
                          roomNumber: roomNumber,
                          personName: personName,
                          assignedTo: assignedTo,
                          actionType: actionType,
                          incidentType: incidentType,
                          onStartDateChanged: (date) {
                            setState(() {
                              startDate = date;
                            });
                          },
                          onEndDateChanged: (date) {
                            setState(() {
                              endDate = date;
                            });
                          },
                          onRoomNumberChanged: (value) {
                            setState(() {
                              roomNumber = value;
                            });
                          },
                          onPersonNameChanged: (value) {
                            setState(() {
                              personName = value;
                            });
                          },
                          onAssignedToChanged: (value) {
                            setState(() {
                              assignedTo = value;
                            });
                          },
                          onActionTypeChanged: (value) {
                            setState(() {
                              actionType = value;
                            });
                          },
                          onIncidentTypeChanged: (value) {
                            setState(() {
                              incidentType = value;
                            });
                          },
                          onSearch: () {
                            // 検索実行
                            print('検索実行: $personName, $roomNumber, $assignedTo, $actionType, $incidentType');
                          },
                          onClear: () {
                            setState(() {
                              startDate = null;
                              endDate = null;
                              roomNumber = null;
                              personName = null;
                              assignedTo = null;
                              actionType = null;
                              incidentType = null;
                            });
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
