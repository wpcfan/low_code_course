import 'package:common/common.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

import 'page_event.dart';
import 'page_state.dart';

class PageBloc extends Bloc<PageEvent, PageState> {
  final PageAdminRepository adminRepo;
  PageBloc(this.adminRepo) : super(PageState.initial()) {
    on<PageEventTitleChanged>(_onPageEventTitleChanged);
    on<PageEventPlatformChanged>(_onPageEventPlatformChanged);
    on<PageEventPageTypeChanged>(_onPageEventPageTypeChanged);
    on<PageEventPageStatusChanged>(_onPageEventPageStatusChanged);
    on<PageEventStartTimeChanged>(_onPageEventStartTimeChanged);
    on<PageEventEndTimeChanged>(_onPageEventEndTimeChanged);
    on<PageEventPageChanged>(_onPageEventPageChanged);
    on<PageEventCreate>(_onPageEventCreate);
    on<PageEventUpdate>(_onPageEventUpdate);
    on<PageEventDelete>(_onPageEventDelete);
    on<PageEventClearAll>(_onPageEventClearAll);
    on<PageEventPublish>(_onPageEventPublish);
    on<PageEventDraft>(_onPageEventDraft);
    on<PageEventClearError>(_onPageEventClearError);
  }

  void _onPageEventClearError(
      PageEventClearError event, Emitter<PageState> emit) async {
    emit(state.copyWith(error: ''));
  }

  void _onPageEventPublish(
      PageEventPublish event, Emitter<PageState> emit) async {
    emit(state.copyWith(loading: true));
    try {
      final layout =
          await adminRepo.publish(event.id, event.startTime, event.endTime);
      emit(state.copyWith(
        loading: false,
        items: state.items.map((e) {
          if (e.id == event.id) {
            return layout;
          }
          return e;
        }).toList(),
        error: '',
      ));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void _onPageEventDraft(PageEventDraft event, Emitter<PageState> emit) async {
    emit(state.copyWith(loading: true));
    try {
      final layout = await adminRepo.draft(event.id);
      emit(state.copyWith(
        loading: false,
        items: state.items.map((e) {
          if (e.id == event.id) {
            return layout;
          }
          return e;
        }).toList(),
        error: '',
      ));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void _onPageEventClearAll(
      PageEventClearAll event, Emitter<PageState> emit) async {
    const query = PageQuery();
    await _query(query, emit);
  }

  void _onPageEventDelete(
      PageEventDelete event, Emitter<PageState> emit) async {
    emit(state.copyWith(loading: true));
    try {
      await adminRepo.delete(event.id);
      emit(state.copyWith(
        loading: false,
        items: state.items.where((element) => element.id != event.id).toList(),
        error: '',
      ));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void _onPageEventUpdate(
      PageEventUpdate event, Emitter<PageState> emit) async {
    emit(state.copyWith(loading: true));
    try {
      final layout = await adminRepo.update(event.id, event.layout);
      emit(state.copyWith(
        loading: false,
        items: state.items.map((e) {
          if (e.id == event.id) {
            return layout;
          }
          return e;
        }).toList(),
        error: '',
      ));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void _onPageEventCreate(
      PageEventCreate event, Emitter<PageState> emit) async {
    emit(state.copyWith(loading: true));
    try {
      final layout = await adminRepo.create(event.layout);
      emit(state.copyWith(
        loading: false,
        items: [layout, ...state.items],
        error: '',
      ));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void _onPageEventEndTimeChanged(
      PageEventEndTimeChanged event, Emitter<PageState> emit) async {
    PageQuery pageQuery = state.query;
    if (event.endTimeFrom != null) {
      pageQuery = pageQuery.copyWith(
        endTimeFrom: event.endTimeFrom?.format('yyyy-MM-dd'),
      );
    } else {
      pageQuery = pageQuery.clear('endTimeFrom');
    }
    if (event.endTimeTo != null) {
      pageQuery = pageQuery.copyWith(
        endTimeTo: event.endTimeTo?.format('yyyy-MM-dd'),
      );
    } else {
      pageQuery = pageQuery.clear('endTimeTo');
    }

    await _query(pageQuery, emit);
  }

  void _onPageEventStartTimeChanged(
      PageEventStartTimeChanged event, Emitter<PageState> emit) async {
    PageQuery pageQuery = state.query;
    if (event.startTimeFrom != null) {
      pageQuery = pageQuery.copyWith(
        startTimeFrom: event.startTimeFrom?.format('yyyy-MM-dd'),
      );
    } else {
      pageQuery = pageQuery.clear('startTimeFrom');
    }
    if (event.startTimeTo != null) {
      pageQuery = pageQuery.copyWith(
        startTimeTo: event.startTimeTo?.format('yyyy-MM-dd'),
      );
    } else {
      pageQuery = pageQuery.clear('startTimeTo');
    }

    await _query(pageQuery, emit);
  }

  void _onPageEventPageStatusChanged(
      PageEventPageStatusChanged event, Emitter<PageState> emit) async {
    final pageQuery = event.pageStatus != null
        ? state.query.copyWith(
            status: event.pageStatus,
          )
        : state.query.clear('status');
    await _query(pageQuery, emit);
  }

  void _onPageEventPageTypeChanged(
      PageEventPageTypeChanged event, Emitter<PageState> emit) async {
    final pageQuery = event.pageType != null
        ? state.query.copyWith(
            pageType: event.pageType,
          )
        : state.query.clear('pageType');
    await _query(pageQuery, emit);
  }

  void _onPageEventPlatformChanged(
      PageEventPlatformChanged event, Emitter<PageState> emit) async {
    final pageQuery = event.platform != null
        ? state.query.copyWith(
            platform: event.platform,
          )
        : state.query.clear('platform');
    await _query(pageQuery, emit);
  }

  void _onPageEventTitleChanged(
      PageEventTitleChanged event, Emitter<PageState> emit) async {
    final pageQuery = event.title != null
        ? state.query.copyWith(
            title: event.title,
          )
        : state.query.clear('title');
    await _query(pageQuery, emit);
  }

  void _onPageEventPageChanged(
      PageEventPageChanged event, Emitter<PageState> emit) async {
    final pageQuery = event.page != null
        ? state.query.copyWith(
            page: event.page,
          )
        : state.query.clear('page');
    await _query(pageQuery, emit);
  }

  Future<void> _query(PageQuery pageQuery, Emitter<PageState> emit) async {
    emit(state.copyWith(
      status: FetchStatus.loading,
    ));
    try {
      final response = await adminRepo.search(pageQuery);
      emit(state.copyWith(
        items: response.items,
        total: response.totalSize,
        totalPage: response.totalPages,
        page: response.page,
        pageSize: response.size,
        query: pageQuery,
        status: FetchStatus.success,
        error: '',
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        status: FetchStatus.failure,
      ));
    }
  }
}
