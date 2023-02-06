import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mastodon/providers/compose_provider.dart';
import 'package:mastodon/providers/home_provider.dart';
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
  }

  @override
  void dispose() {
    _textController?.dispose();
    super.dispose();
  }

  _onCompose() async {
    final text = _textController?.text ?? '';
    final homeProvider = context.read<HomeProvider>();
    await context.read<ComposeProvider>().publishStatus(text);
    homeProvider.openHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Compose"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(3.0),
          child: _ComposeLoading(),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(children: [
          TextField(
            minLines: 5,
            maxLines: 10,
            decoration: InputDecoration(
              hintText: 'What\'s on your mind?',
              counterText: '${_textController?.text.length ?? 0} characters',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) {
              setState(() {});
            },
            controller: _textController,
            autofocus: true,
          ),
          ElevatedButton(
              onPressed: hasStatusText ? _onCompose : null,
              child: Text('Publish'))
        ]),
      ),
    );
  }

  bool get hasStatusText {
    return _textController?.text.isNotEmpty ?? false;
  }
}

class _ComposeLoading extends StatelessWidget {
  const _ComposeLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final composeProvider = context.watch<ComposeProvider>();
    if (composeProvider.loading) {
      return LinearProgressIndicator();
    }
    return Container();
  }
}