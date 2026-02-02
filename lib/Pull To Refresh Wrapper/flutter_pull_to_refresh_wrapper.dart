import 'package:flutter/material.dart';

/// =======================================================
/// 🔄 SMART PULL TO REFRESH + LOAD MORE (ALL IN ONE)
/// =======================================================

class SmartPullRefresh extends StatefulWidget {
  final Future<void> Function() onRefresh;
  final Future<void> Function() onLoadMore;
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final bool hasMoreData;

  const SmartPullRefresh({
    super.key,
    required this.onRefresh,
    required this.onLoadMore,
    required this.itemBuilder,
    required this.itemCount,
    required this.hasMoreData,
  });

  @override
  State<SmartPullRefresh> createState() => _SmartPullRefreshState();
}

class _SmartPullRefreshState extends State<SmartPullRefresh> {
  bool isLoadingMore = false;

  void _handleLoadMore() {
    if (!isLoadingMore && widget.hasMoreData) {
      setState(() => isLoadingMore = true);

      widget.onLoadMore().then((_) {
        if (mounted) {
          setState(() => isLoadingMore = false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.blue,
      onRefresh: widget.onRefresh,
      child: NotificationListener<ScrollNotification>(
        onNotification: (scroll) {
          if (scroll.metrics.pixels ==
              scroll.metrics.maxScrollExtent) {
            _handleLoadMore();
          }
          return false;
        },
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: widget.itemCount + 1,
          itemBuilder: (context, index) {
            if (index == widget.itemCount) {
              return _LoadMoreFooter(
                isLoading: isLoadingMore,
                hasMore: widget.hasMoreData,
              );
            }
            return widget.itemBuilder(context, index);
          },
        ),
      ),
    );
  }
}

/// =======================================================
/// 🎨 CUSTOM LOAD MORE FOOTER
/// =======================================================

class _LoadMoreFooter extends StatelessWidget {
  final bool isLoading;
  final bool hasMore;

  const _LoadMoreFooter({
    required this.isLoading,
    required this.hasMore,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasMore) {
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

    if (!isLoading) return const SizedBox(height: 60);

    return const Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: CircularProgressIndicator(strokeWidth: 3),
      ),
    );
  }
}

/// =======================================================
/// 🧪 DEMO SCREEN (SINGLE DEMO)
/// =======================================================

class SmartPullRefreshDemo extends StatefulWidget {
  const SmartPullRefreshDemo({super.key});

  @override
  State<SmartPullRefreshDemo> createState() =>
      _SmartPullRefreshDemoState();
}

class _SmartPullRefreshDemoState
    extends State<SmartPullRefreshDemo> {
  List<int> items = List.generate(20, (i) => i);
  bool hasMore = true;

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      items = List.generate(20, (i) => i);
      hasMore = true;
    });
  }

  Future<void> _loadMore() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      items.addAll(
          List.generate(10, (i) => items.length + i));
      if (items.length >= 50) {
        hasMore = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Pull Refresh Demo'),
      ),
      body: SmartPullRefresh(
        onRefresh: _refresh,
        onLoadMore: _loadMore,
        hasMoreData: hasMore,
        itemCount: items.length,
        itemBuilder: (_, index) {
          return Card(
            margin:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.refresh),
              title: Text('Item ${items[index]}'),
            ),
          );
        },
      ),
    );
  }
}