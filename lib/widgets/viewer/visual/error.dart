import 'dart:io';

import 'package:aves/model/entry/entry.dart';
import 'package:aves/theme/icons.dart';
import 'package:aves/widgets/common/extensions/build_context.dart';
import 'package:aves/widgets/common/identity/empty.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ErrorView extends StatefulWidget {
  final AvesEntry entry;
  final VoidCallback onTap;

  const ErrorView({
    super.key,
    required this.entry,
    required this.onTap,
  });

  @override
  State<ErrorView> createState() => _ErrorViewState();
}

class _ErrorViewState extends State<ErrorView> {
  late Future<bool> _exists;

  AvesEntry get entry => widget.entry;

  @override
  void initState() {
    super.initState();
    final path = entry.trashDetails?.path ?? entry.path;
    _exists = path != null ? File(path).exists() : SynchronousFuture(true);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap(),
      // use container to expand constraints, so that the user can tap anywhere
      child: Container(
        // opaque to cover potential lower quality layer below
        color: Colors.black,
        child: FutureBuilder<bool>(
            future: _exists,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) return const SizedBox();
              final exists = snapshot.data!;
              return EmptyContent(
                icon: exists ? AIcons.error : AIcons.broken,
                text: exists ? context.l10n.viewerErrorUnknown : context.l10n.viewerErrorDoesNotExist,
                alignment: Alignment.center,
                safeBottom: false,
              );
            }),
      ),
    );
  }
}
