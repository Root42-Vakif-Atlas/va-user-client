import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/l10n/failure_messages.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/features/memory_corner/domain/entities/memory.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/bloc/memory_list_bloc.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/memory_presentation.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/widgets/memory_actions.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/widgets/memory_card.dart';

/// Üst ağaçtaki [MemoryListBloc]'a bağlı anı kartı: silme onayı, bildirme
/// formu ve misafir için giriş açıklaması burada yönetilir.
class MemoryListItem extends StatelessWidget {
  const MemoryListItem({
    required this.memory,
    required this.viewerId,
    required this.onSignIn,
    super.key,
  });

  final Memory memory;

  /// Oturum açık kullanıcının kimliği; misafirde `null`.
  final String? viewerId;
  final ValueChanged<MemorySignInIntent> onSignIn;

  Future<void> _delete(BuildContext context) async {
    final bloc = context.read<MemoryListBloc>();
    if (await confirmMemoryDelete(context)) {
      bloc.add(MemoryListEvent.deleteRequested(memory));
    }
  }

  Future<void> _report(BuildContext context) async {
    if (viewerId == null) {
      if (await showMemorySignInSheet(context, MemorySignInIntent.report)) {
        onSignIn(MemorySignInIntent.report);
      }
      return;
    }
    final bloc = context.read<MemoryListBloc>();
    final submission = await showMemoryReportSheet(context);
    if (submission != null) {
      bloc.add(
        MemoryListEvent.reportRequested(
          memory: memory,
          reason: submission.reason,
          note: submission.note,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final busy = context.select(
      (MemoryListBloc bloc) => bloc.state.busyIds.contains(memory.id),
    );
    return MemoryCard(
      memory: memory,
      isOwn: memory.isAuthoredBy(viewerId),
      isBusy: busy,
      onDelete: () => unawaited(_delete(context)),
      onReport: () => unawaited(_report(context)),
    );
  }
}

/// Silme / bildirme sonucunu SnackBar ve ekran okuyucu duyurusuyla bildirir.
class MemoryNoticeListener extends StatelessWidget {
  const MemoryNoticeListener({required this.child, super.key});

  final Widget child;

  void _onNotice(BuildContext context, MemoryListState state) {
    final notice = state.notice;
    if (notice == null) {
      return;
    }
    final l10n = context.l10n;
    final message = switch (notice.kind) {
      MemoryNoticeKind.deleted => l10n.memoryDeleted,
      MemoryNoticeKind.reported => l10n.memoryReported,
      MemoryNoticeKind.actionFailed =>
        notice.failure?.toUserMessage(l10n) ?? l10n.errorUnexpected,
    };
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
    unawaited(
      context.read<A11yAnnouncer>().announce(
        message,
        assertive: notice.kind == MemoryNoticeKind.actionFailed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MemoryListBloc, MemoryListState>(
      listenWhen: (previous, current) =>
          current.noticeCount != previous.noticeCount,
      listener: _onNotice,
      child: child,
    );
  }
}
