import 'package:flutter/material.dart';
import 'package:mastodon/base/database.dart';
import 'package:mastodon/base/store_key.dart';
import 'package:mastodon/providers/authorization_provider.dart';
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
  TextEditingController? _textController;

  @override
  void initState() {
    _textController = TextEditingController();
    super.initState();
    Future.microtask(_loadInitial);
  }

  @override
  void dispose() {
    _textController?.dispose();
    super.dispose();
  }

  _loadInitial() async {
    final settingsProvider = context.read<SettingsProvider>();
    await settingsProvider.refresh();
    await settingsProvider.loadInstanceSettings();
  }

  _onCompose() async {
    final text = _textController?.text ?? '';
    final homeProvider = context.read<HomeProvider>();
    await context.read<ComposeProvider>().publishStatus(text);
    homeProvider.selectMenu(HomeMenu.home);
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Compose"),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(3.0),
          child: _ComposeLoading(),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          TextField(
            enabled: settingsProvider.statusMaxLength > 0,
            maxLength: settingsProvider.statusMaxLength > 0
                ? settingsProvider.statusMaxLength
                : null,
            minLines: 5,
            maxLines: 10,
            decoration: InputDecoration(
              hintText: 'What\'s on your mind?',
              counterText:
                  '${settingsProvider.statusMaxLength - (_textController?.text.length ?? 0)} characters',
              border: const OutlineInputBorder(),
            ),
            onChanged: (_) {
              setState(() {});
            },
            controller: _textController,
            autofocus: true,
          ),
          ElevatedButton(
              onPressed: hasStatusText ? _onCompose : null,
              child: const Text('Publish'))
        ]),
      ),
    );
  }

  bool get hasStatusText {
    return _textController?.text.isNotEmpty ?? false;
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
