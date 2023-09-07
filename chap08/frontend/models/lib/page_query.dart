import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'enums/enums.dart';

class PageQuery extends Equatable {
  final String? title;
  final Platform? platform;
  final PageType? pageType;
  final PageStatus? status;
  final String? startTimeFrom;
  final String? startTimeTo;
  final String? endTimeFrom;
  final String? endTimeTo;
  final int page;

  const PageQuery({
    this.title,
    this.platform,
    this.pageType,
    this.status,
    this.startTimeFrom,
    this.startTimeTo,
    this.endTimeFrom,
    this.endTimeTo,
    this.page = 0,
  });

  PageQuery copyWith({
    String? title,
    Platform? platform,
    PageType? pageType,
    PageStatus? status,
    String? startTimeFrom,
    String? startTimeTo,
    String? endTimeFrom,
    String? endTimeTo,
    int? page,
  }) {
    return PageQuery(
      title: title ?? this.title,
      platform: platform ?? this.platform,
      pageType: pageType ?? this.pageType,
      status: status ?? this.status,
      startTimeFrom: startTimeFrom ?? startTimeFrom,
      startTimeTo: startTimeTo ?? startTimeTo,
      endTimeFrom: endTimeFrom ?? endTimeFrom,
      endTimeTo: endTimeTo ?? endTimeTo,
      page: page ?? this.page,
    );
  }

  PageQuery clear(String field) {
    switch (field) {
      case 'title':
        return PageQuery(
          title: null,
          platform: platform,
          pageType: pageType,
          status: status,
          startTimeFrom: startTimeFrom,
          startTimeTo: startTimeTo,
          endTimeFrom: endTimeFrom,
          endTimeTo: endTimeTo,
          page: page,
        );
      case 'platform':
        return PageQuery(
          title: title,
          platform: null,
          pageType: pageType,
          status: status,
          startTimeFrom: startTimeFrom,
          startTimeTo: startTimeTo,
          endTimeFrom: endTimeFrom,
          endTimeTo: endTimeTo,
          page: page,
        );
      case 'pageType':
        return PageQuery(
          title: title,
          platform: platform,
          pageType: null,
          status: status,
          startTimeFrom: startTimeFrom,
          startTimeTo: startTimeTo,
          endTimeFrom: endTimeFrom,
          endTimeTo: endTimeTo,
          page: page,
        );
      case 'status':
        return PageQuery(
          title: title,
          platform: platform,
          pageType: pageType,
          status: null,
          startTimeFrom: startTimeFrom,
          startTimeTo: startTimeTo,
          endTimeFrom: endTimeFrom,
          endTimeTo: endTimeTo,
          page: page,
        );
      case 'startTimeFrom':
        return PageQuery(
          title: title,
          platform: platform,
          pageType: pageType,
          status: status,
          startTimeFrom: null,
          startTimeTo: startTimeTo,
          endTimeFrom: endTimeFrom,
          endTimeTo: endTimeTo,
          page: page,
        );
      case 'startTimeTo':
        return PageQuery(
          title: title,
          platform: platform,
          pageType: pageType,
          status: status,
          startTimeFrom: startTimeFrom,
          startTimeTo: null,
          endTimeFrom: endTimeFrom,
          endTimeTo: endTimeTo,
          page: page,
        );
      case 'endTimeFrom':
        return PageQuery(
          title: title,
          platform: platform,
          pageType: pageType,
          status: status,
          startTimeFrom: startTimeFrom,
          startTimeTo: startTimeTo,
          endTimeFrom: null,
          endTimeTo: endTimeTo,
          page: page,
        );
      case 'endTimeTo':
        return PageQuery(
          title: title,
          platform: platform,
          pageType: pageType,
          status: status,
          startTimeFrom: startTimeFrom,
          startTimeTo: startTimeTo,
          endTimeFrom: endTimeFrom,
          endTimeTo: null,
          page: page,
        );
      default:
        return this;
    }
  }

  String toJsonString() {
    return jsonEncode({
      'title': title,
      'platform': platform?.value,
      'pageType': pageType?.value,
      'status': status?.value,
      'startTimeFrom': startTimeFrom,
      'startTimeTo': startTimeTo,
      'endTimeFrom': endTimeFrom,
      'endTimeTo': endTimeTo,
      'page': page,
    });
  }

  @override
  List<Object?> get props => [
        title,
        platform,
        pageType,
        status,
        startTimeFrom,
        startTimeTo,
        endTimeFrom,
        endTimeTo,
        page,
      ];

  @override
  String toString() {
    return 'PageQuery{title: $title, platform: $platform, pageType: $pageType, status: $status, startTimeFrom: $startTimeFrom, startTimeTo: $startTimeTo, endTimeFrom: $endTimeFrom, endTimeTo: $endTimeTo, page: $page}';
  }
}
