import 'package:equatable/equatable.dart';

import 'enums/enums.dart';
import 'page_block.dart';
import 'page_config.dart';

class PageLayout extends Equatable {
  final int? id;
  final String? title;
  final Platform platform;
  final PageType pageType;
  final PageStatus status;
  final DateTime? startTime;
  final DateTime? endTime;
  final List<PageBlock> blocks;
  final PageConfig config;

  const PageLayout({
    this.id,
    this.title = '',
    required this.platform,
    required this.pageType,
    required this.config,
    required this.status,
    this.startTime,
    this.endTime,
    this.blocks = const [],
  });

  factory PageLayout.fromJson(Map<String, dynamic> json) {
    return PageLayout(
      id: json['id'] as int?,
      title: json['title'] as String?,
      platform: Platform.values.firstWhere(
        (e) => e.value == json['platform'],
        orElse: () => Platform.app,
      ),
      pageType: PageType.values.firstWhere(
        (e) => e.value == json['pageType'],
        orElse: () => PageType.home,
      ),
      status: PageStatus.values.firstWhere(
        (e) => e.value == json['status'],
        orElse: () => PageStatus.draft,
      ),
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      blocks: json['blocks'] == null
          ? []
          : (json['blocks'] as List<dynamic>)
              .map((e) => PageBlock.fromJson(e as Map<String, dynamic>))
              .toList(),
      config: PageConfig.fromJson(json['config'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'platform': platform.value,
      'pageType': pageType.value,
      'status': status.value,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'blocks': blocks.map((e) => e.toJson()).toList(),
      'config': config.toJson(),
    };
  }

  @override
  List<Object?> get props {
    return [
      id,
      title,
      platform,
      pageType,
      status,
      startTime,
      endTime,
      blocks,
      config,
    ];
  }

  @override
  String toString() {
    return 'PageLayout{id: $id, title: $title, platform: $platform, pageType: $pageType, status: $status, startTime: $startTime, endTime: $endTime, blocks: $blocks, config: $config}';
  }

  PageLayout copyWith({
    int? id,
    String? title,
    Platform? platform,
    PageType? pageType,
    PageStatus? status,
    DateTime? startTime,
    DateTime? endTime,
    List<PageBlock>? blocks,
    PageConfig? config,
  }) {
    return PageLayout(
      id: id ?? this.id,
      title: title ?? this.title,
      platform: platform ?? this.platform,
      pageType: pageType ?? this.pageType,
      status: status ?? this.status,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      blocks: blocks ?? this.blocks,
      config: config ?? this.config,
    );
  }

  factory PageLayout.empty() {
    return PageLayout(
      title: '',
      platform: Platform.app,
      pageType: PageType.home,
      status: PageStatus.draft,
      config: PageConfig.empty(),
    );
  }

  bool get isDraft => status == PageStatus.draft;

  bool get isPublished => status == PageStatus.published;

  bool get isArchived => status == PageStatus.archived;
}
