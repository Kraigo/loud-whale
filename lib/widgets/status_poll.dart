import 'package:flutter/material.dart';
import 'package:mastodon/enties/entries.dart';
import 'package:mastodon/providers/timeline_provider.dart';
import 'package:mastodon_api/mastodon_api.dart';
import 'package:provider/provider.dart';

class StatusPoll extends StatefulWidget {
  final PollEntity poll;
  const StatusPoll({required this.poll, super.key});

  @override
  State<StatusPoll> createState() => _StatusPollState();
}

class _StatusPollState extends State<StatusPoll> {
  Set<int> selectedOptionIndex = {};

  String get _expiresFormat {
    if (widget.poll.expiresAt == null) return 'Closed';

    Duration diff = widget.poll.expiresAt!.difference(DateTime.now());
    if (diff.inDays > 365) {
      return "${(diff.inDays / 365).floor()} years left";
    }
    if (diff.inDays > 30) {
      return "${(diff.inDays / 30).floor()} minutes left";
    }
    if (diff.inDays > 7) {
      return "${(diff.inDays / 7).floor()} weeks left";
    }
    if (diff.inDays > 0) {
      return "${diff.inDays} days left";
    }
    if (diff.inHours > 0) {
      return "${diff.inHours} hours left";
    }
    if (diff.inMinutes > 0) {
      return "${diff.inMinutes} minutes left";
    }
    return "a little bit";
  }

  bool get _canVote {
    return !widget.poll.isExpired && widget.poll.isVoted != true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var p in widget.poll.options) _buildPollOption(context, p),
        Row(
          children: [
            if (_canVote)
              VoteButton(
                poll: widget.poll,
                choices: selectedOptionIndex,
              ),
            if (!_canVote) RefreshButton(poll: widget.poll),
            const SizedBox(
              width: 8,
            ),
            Text(
              "${widget.poll.votesCount} people",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const Text(" - "),
            Text(
              widget.poll.isExpired ? 'Closed' : _expiresFormat,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        )
      ],
    );
  }

  Widget _buildPollOption(BuildContext context, PollOption option) {
    final percent = option.votesCount / widget.poll.votesCount;
    final percentFormat = (percent * 100).toStringAsFixed(0);
    final index = widget.poll.options.indexOf(option);
    final isSelected = widget.poll.ownVotes.contains(index);

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            if (_canVote) _buildInput(index),
            if (!_canVote)
              SizedBox(
                width: 30,
                child: Text(
                  '$percentFormat%',
                  softWrap: false,
                ),
              ),
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
        if (!_canVote)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: FractionallySizedBox(
                widthFactor: option.votesCount / widget.poll.votesCount,
                child: Container(
                  width: double.infinity,
                  height: 5,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).disabledColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                )),
          )
      ]),
    );
  }

  Widget _buildInput(int index) {
    if (widget.poll.isMultiple) {
      return Checkbox(
          value: selectedOptionIndex.contains(index),
          onChanged: (checked) {
            setState(() {
              if (checked == true) {
                selectedOptionIndex.add(index);
              } else {
                selectedOptionIndex.remove(index);
              }
            });
          });
    }
    return Radio(
      value: index,
      groupValue:
          selectedOptionIndex.isNotEmpty ? selectedOptionIndex.first : null,
      onChanged: (value) {
        setState(() {
          selectedOptionIndex = {value!};
        });
      },
    );
  }
}

class VoteButton extends StatelessWidget {
  final Set<int> choices;
  final PollEntity poll;
  const VoteButton({required this.choices, required this.poll, super.key});

  _onVote(BuildContext context) async {
    final timelineProvider = context.read<TimelineProvider>();

    await timelineProvider.votePoll(poll.id, choices.toList());
    await timelineProvider.updateStatus(poll.statusId);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: choices.isNotEmpty ? () => _onVote(context) : null,
      child: const Text("Vote"),
    );
  }
}

class RefreshButton extends StatelessWidget {
  final PollEntity poll;
  const RefreshButton({required this.poll, super.key});

  _onRefresh(BuildContext context) async {
    final timelineProvider = context.read<TimelineProvider>();
    await timelineProvider.updateStatus(poll.statusId);
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => _onRefresh(context),
      child: const Text("Refresh"),
    );
  }
}
