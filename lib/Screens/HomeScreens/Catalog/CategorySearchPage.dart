import 'package:flutter/material.dart';
import 'package:gold_project/Utils/AppColors.dart';
import 'package:gold_project/Utils/FFontStyles.dart';
import 'package:gold_project/Utils/ImageAssets.dart';
import 'package:gold_project/Widgets/AppBar/CustomAppBar.dart';

class CategorySearchPage extends StatefulWidget {
  const CategorySearchPage({super.key});

  @override
  State<CategorySearchPage> createState() => _CategorySearchPageState();
}

class _CategorySearchPageState extends State<CategorySearchPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  // Simulate persistent storage
  static List<String> _persistentHistory = ['Gold Ring', 'Mangalsutra', 'Necklace'];

  List<String> searchHistory = [];

  @override
  void initState() {
    super.initState();
    searchHistory = List.from(_persistentHistory); // load previous history

    _focusNode.addListener(() {
      setState(() {}); // rebuild to show/hide history when focus changes
    });
  }

  void _addToSearchHistory(String query) {
    if (query.isEmpty) return;
    setState(() {
      searchHistory.remove(query); // move to top if exists
      searchHistory.insert(0, query);
      if (searchHistory.length > 10) searchHistory.removeLast();

      // update persistent storage
      _persistentHistory = List.from(searchHistory);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    bool showHistory = _controller.text.isEmpty && _focusNode.hasFocus && searchHistory.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Search'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: 'Search products',
                prefixIcon: Icon(Icons.search, color: AppColors.borderColor2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(200),
                  borderSide: BorderSide(color: AppColors.borderColor2, width: 1.5),
                ),
                filled: true,
                fillColor: AppColors.background,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
              ),
              onSubmitted: (value) {
                if (value.isEmpty) return;
                _addToSearchHistory(value);
                _controller.clear();
                _focusNode.unfocus();
                Navigator.pop(context, value); // return query
              },
            ),
            const SizedBox(height: 16),
            if (showHistory)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Search History',
                  style: FFontStyles.searchHeading(18),
                  textAlign: TextAlign.left,
                ),
              ),
            if (showHistory)
              Expanded(
                child: ListView.builder(
                  itemCount: searchHistory.length,
                  itemBuilder: (context, index) {
                    final query = searchHistory[index];
                    return ListTile(
                      title: Text(query, style: FFontStyles.searchHistory(16)),
                      trailing: Image.asset(ImageAssets.arrowUpLinear, width: 20),
                      onTap: () {
                        _addToSearchHistory(query);
                        _controller.text = query;
                        _focusNode.unfocus();
                        Navigator.pop(context, query);
                      },
                    );
                  },
                ),
              )
            else
              Expanded(
                child: Center(
                  child: Text(
                    'Enter a search term above',
                    style: FFontStyles.headingSubTitleText(16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
