import 'package:flutter/material.dart';
import 'package:mastodon/providers/compose_provider.dart';
import 'package:mastodon/providers/home_provider.dart';
import 'package:mastodon/providers/settings_provider.dart';
import 'package:provider/provider.dart';

class ComposeScreen extends StatefulWidget {
  const ComposeScreen({super.key});

  @override
  State<ComposeScreen> createState() => _ComposeScreenState();
}

class _ComposeScreenState extends State<ComposeScreen> {
  _onCompose(String text) async {
    final homeProvider = context.read<HomeProvider>();
    await context.read<ComposeProvider>().publishStatus(text);
    homeProvider.selectMenu(HomeMenu.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Compose"),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(3.0),
            child: _ComposeLoading(),
          ),
        ),
        body: ComposeInput(onPublish: _onCompose));
  }
}

class ComposeInput extends StatefulWidget {
  final void Function(String text) onPublish;
  final String? initialText;

  const ComposeInput({
    required this.onPublish,
    this.initialText,
    super.key,
  });

  @override
  State<ComposeInput> createState() => _ComposeInputState();
}

class _ComposeInputState extends State<ComposeInput> {
  TextEditingController? _textController;

  _loadInitial() async {
    final settingsProvider = context.read<SettingsProvider>();
    await settingsProvider.refresh();
    await settingsProvider.loadInstanceSettings();
  }

  bool get hasStatusText {
    return _textController?.text.isNotEmpty ?? false;
  }

  _onSubmit() {
    widget.onPublish(_textController?.text ?? '');
  }

  @override
  void initState() {
    _textController = TextEditingController(text: widget.initialText);
    Future.microtask(_loadInitial);
    super.initState();
  }

  @override
  void dispose() {
    _textController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final maxLength = settingsProvider.statusMaxLength;
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        Stack(
          children: [
            TextField(
              enabled: maxLength > 0,
              maxLength: maxLength > 0 ? maxLength : null,
              minLines: 5,
              maxLines: 10,
              decoration: const InputDecoration(
                hintText: 'What\'s on your mind?',
                counterText: '',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) {
                setState(() {});
              },
              controller: _textController,
              autofocus: true,
            ),
            if (_textController != null)
              Positioned(
                  bottom: 5,
                  right: 5,
                  child: _ComposeCountLimit(_textController!))
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: hasStatusText ? _onSubmit : null,
              child: const Text('Publish!'),
            )
          ],
        )
      ]),
    );
  }
}

class _ComposeCountLimit extends StatelessWidget {
  final TextEditingController controller;
  const _ComposeCountLimit(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final theme = Theme.of(context);
    final maxLength = settingsProvider.statusMaxLength;
    final currentLength = controller.text.length;

    final text = '${maxLength - (currentLength)} / $maxLength';
    final dangerLength = (maxLength * 0.9).floor();
    final isDangerLength = currentLength > dangerLength;

    final textStyle = theme.textTheme.caption!.copyWith(
      color: isDangerLength ? theme.errorColor : theme.textTheme.caption!.color,
    );

    return Text(text, style: textStyle);
  }
}

class _ComposeLoading extends StatelessWidget {
  const _ComposeLoading();

  @override
  Widget build(BuildContext context) {
    final composeProvider = context.watch<ComposeProvider>();
    if (composeProvider.loading) {
      return const LinearProgressIndicator();
    }
    return Container();
  }
}
