import 'package:flutter/material.dart';

class WorkingPullRefreshDemo extends StatefulWidget {
  const WorkingPullRefreshDemo({super.key});

  @override
  State<WorkingPullRefreshDemo> createState() =>
      _WorkingPullRefreshDemoState();
}

class _WorkingPullRefreshDemoState
    extends State<WorkingPullRefreshDemo> {
  List<int> items = List.generate(8, (i) => i + 1);
  bool isLoadingMore = false;
  bool hasMoreData = true;

  /// 🔄 Pull to Refresh
  Future<void> _onRefresh() async {
    debugPrint('REFRESH CALLED');
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      items = List.generate(8, (i) => i + 1);
      hasMoreData = true;
    });
  }

  /// ⬇️ Load More
  Future<void> _loadMore() async {
    if (isLoadingMore || !hasMoreData) return;

    debugPrint('LOAD MORE CALLED');
    setState(() => isLoadingMore = true);

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      items.addAll(
        List.generate(5, (i) => items.length + i + 1),
      );
      isLoadingMore = false;

      if (items.length >= 25) {
        hasMoreData = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Working Pull To Refresh'),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent - 40) {
              _loadMore();
            }
            return false;
          },
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 20),
            itemCount: items.length + 1,
            itemBuilder: (context, index) {
              if (index == items.length) {
                return _footer();
              }

              return Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: const Icon(Icons.check_circle),
                  title: Text('Item ${items[index]}'),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// 🔻 Footer
  Widget _footer() {
    if (!hasMoreData) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Text(
            'No more data',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    if (isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return const SizedBox(height: 50);
  }
}