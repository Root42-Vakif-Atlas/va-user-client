import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/a11y/reduce_motion.dart';
import 'package:vakif_atlas/core/l10n/failure_messages.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/auth/domain/entities/legal_document.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/account_blocs.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/atoms/diamond_divider.dart';
import 'package:vakif_atlas/shared/widgets/templates/status_message_view.dart';

/// Sürümlü yasal metin (Kullanım Koşulları / KVKK Aydınlatma Metni).
class LegalDocumentPage extends StatefulWidget {
  const LegalDocumentPage({required this.type, super.key});

  final LegalDocumentType type;

  @override
  State<LegalDocumentPage> createState() => _LegalDocumentPageState();
}

class _LegalDocumentPageState extends State<LegalDocumentPage> {
  String? _loadedLanguage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final language = Localizations.localeOf(context).languageCode;
    if (_loadedLanguage != language) {
      _loadedLanguage = language;
      _load();
    }
  }

  void _load() => context.read<LegalDocumentCubit>().load(
    widget.type,
    languageCode: _loadedLanguage ?? 'tr',
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final title = switch (widget.type) {
      LegalDocumentType.termsOfUse => l10n.legalTermsTitle,
      LegalDocumentType.privacyNotice => l10n.legalPrivacyTitle,
    };

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: BlocBuilder<LegalDocumentCubit, LegalDocumentState>(
        builder: (context, state) => switch (state) {
          LegalDocumentLoading() => Center(
            child: Semantics(
              label: l10n.commonLoading,
              child: context.reduceMotion
                  ? const Icon(Icons.hourglass_top)
                  : const CircularProgressIndicator(),
            ),
          ),
          LegalDocumentFailure(:final failure) => StatusMessageView(
            tone: StatusMessageTone.error,
            icon: Icons.cloud_off_outlined,
            title: title,
            message: failure.toUserMessage(l10n),
            actionLabel: l10n.commonRetry,
            onAction: _load,
          ),
          LegalDocumentLoaded(:final document) => _DocumentBody(
            document: document,
          ),
        },
      ),
    );
  }
}

class _DocumentBody extends StatelessWidget {
  const _DocumentBody({required this.document});

  final LegalDocument document;

  @override
  Widget build(BuildContext context) {
    final paragraphs = document.body
        .split('\n\n')
        .where((paragraph) => paragraph.trim().isNotEmpty);

    return SafeArea(
      child: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            AppText(
              document.title,
              role: AppTextRole.headlineMedium,
              isHeading: true,
            ),
            const SizedBox(height: AppSpacing.xs),
            AppText(
              context.l10n.legalVersion(
                document.version,
                document.effectiveDate,
              ),
              role: AppTextRole.bodySmall,
              color: context.colors.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.sm),
            const DiamondDivider(),
            for (final paragraph in paragraphs) ...[
              const SizedBox(height: AppSpacing.md),
              AppText(paragraph.trim()),
            ],
          ],
        ),
      ),
    );
  }
}
