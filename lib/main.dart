import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'all_fluent_icons.dart'; // アイコンリストをインポート

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fluent Icons Viewer',
      debugShowCheckedModeBanner: false, // デバッグバナーを非表示
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        // Webアプリらしい見た目のための調整
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.grey[800],
          elevation: 1,
          titleTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
      home: const IconViewerPage(),
    );
  }
}

class IconViewerPage extends StatefulWidget {
  const IconViewerPage({super.key});

  @override
  State<IconViewerPage> createState() => _IconViewerPageState();
}

class _IconViewerPageState extends State<IconViewerPage> {
  // 表示用のアイコンリスト
  List<IconDetail> _filteredIcons = allFluentIcons;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 検索テキストの変更を監視
    _searchController.addListener(_filterIcons);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // 検索クエリに基づいてアイコンをフィルタリングするメソッド
  void _filterIcons() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredIcons = allFluentIcons;
      } else {
        _filteredIcons = allFluentIcons
            .where(
                (iconDetail) => iconDetail.name.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fluent System Icons Viewer'),
        centerTitle: true,
        // 検索バー
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search icons by name (e.g., home_filled)',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
        ),
      ),
      body: _buildIconGrid(),
    );
  }

  // アイコンを表示するグリッドウィジェット
  Widget _buildIconGrid() {
    if (_filteredIcons.isEmpty) {
      return const Center(child: Text('No icons found.'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150.0, // 各アイテムの最大幅
        mainAxisSpacing: 12.0,
        crossAxisSpacing: 12.0,
      ),
      itemCount: _filteredIcons.length,
      itemBuilder: (context, index) {
        final iconDetail = _filteredIcons[index];
        return InkWell(
          onTap: () {
            // アイコン名をクリップボードにコピー
            Clipboard.setData(ClipboardData(text: iconDetail.name));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Copied "${iconDetail.name}" to clipboard!'),
                duration: const Duration(seconds: 1),
                backgroundColor: Colors.green,
              ),
            );
          },
          borderRadius: BorderRadius.circular(8.0),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(iconDetail.icon, size: 40, color: Colors.blue.shade700),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    iconDetail.name.replaceAll('_', '_\u200B'), // 改行しやすくする
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
