import 'package:flutter/material.dart';
import 'package:mastodon/enties/entries.dart';
import 'package:mastodon_api/mastodon_api.dart';

class StatusPoll extends StatelessWidget {
  final PollEntity poll;
  const StatusPoll({required this.poll, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var p in poll.options) _buildPollOption(context, p),
        Row(
          children: [
            Text(
              "${poll.votesCount} people",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Text(" - "),
            Text(
              poll.isExpired ? 'Closed' : '',
              style: Theme.of(context).textTheme.labelMedium,
            )
          ],
        )
      ],
    );
  }

  Widget _buildPollOption(BuildContext context, PollOption option) {
    final percent = option.votesCount / poll.votesCount;
    final percentFormat = (percent * 100).toStringAsFixed(0);
    final index = poll.options.indexOf(option);
    final isSelected = poll.ownVotes.contains(index);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(width: 30, child: Text('$percentFormat%')),
              const SizedBox(
                width: 8,
              ),
              Flexible(
                child: Text(
                  option.title,
                  softWrap: true,
                ),
              ),
              if (isSelected) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.check,
                  size: 18,
                  color: Theme.of(context).primaryColor,
                )
              ]
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          FractionallySizedBox(
              widthFactor: option.votesCount / poll.votesCount,
              child: Container(
                width: double.infinity,
                height: 5,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).disabledColor,
                  borderRadius: BorderRadius.circular(20),
                ),
              ))
        ],
      ),
    );
  }
}
