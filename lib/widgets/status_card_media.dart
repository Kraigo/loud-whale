import 'package:flutter/material.dart';
import 'package:mastodon/base/database.dart';
import 'package:mastodon/enties/entries.dart';
import 'package:provider/provider.dart';

class StatusCardMedia extends StatelessWidget {
  final StatusEntity status;
  const StatusCardMedia(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context
          .read<AppDatabase>()
          .attachmentDao
          .findAttachemntsByStatus(status.id),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Container();
        }
        return Column(
            children: snapshot.data!
                .map((e) => SizedBox(
                      height: 250,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(
                          e.previewUrl,
                          alignment: const Alignment(0.5, 0.5),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ))
                .toList());
      },
    );
  }
}
