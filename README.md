# 🔄 Smart Pull Refresh (Flutter)

A lightweight and dependency-free **Flutter utility** to implement  
**Pull To Refresh** and **Load More (Infinite Scroll)** functionality  
with clean logic and full control over UI and pagination state.

Built using Flutter’s `RefreshIndicator` and `ScrollNotification` APIs —  
simple, fast, and production-ready.

---

## ✨ Features


🔄 Pull to refresh list data  
⬇️ Load more data on scroll end (pagination)  
🎨 Custom footer loader & “No more data” state  
🧠 Safe logic (prevents multiple load calls)  
⚡ Lightweight & fast (pure Flutter)  
❌ No third-party dependencies  

---

## ✨ Preview





https://github.com/user-attachments/assets/abdfa2b8-c53e-4509-b024-e49a9f816988



---

## ✨ Installation
Add this to your package's pubspec.yaml file:
```
dependencies:
  smart_pull_refresh:
    path: ../smart_pull_refresh
```
▶️ From GitHub
```
dependencies:
  smart_pull_refresh:
    git:
      url: https://github.com/yourusername/smart_pull_refresh.git
```
Then Run:
```
flutter pub get
```
## 📁 Folder Structure
```
smart_pull_refresh/
│
├── lib/
│ └── smart_pull_refresh.dart
│
├── example/
│ └── demo screen 
│ └── main.dart
│
├── pubspec.yaml
├── README.md
└── LICENSE
  ```
## 🚀 Usage 
```

Below is a simple demo screen showing how to use **SmartPullRefresh**  
to enable **Pull To Refresh** and **Load More** in a list.

---

```dart
import 'package:flutter/material.dart';
import 'smart_pull_refresh.dart';

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
        List.generate(10, (i) => items.length + i),
      );
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
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.refresh),
            title: Text('Item ${items[index]}'),
          );
        },
      ),
    );
  }
}

```
## 📜 License
MIT License
```
Copyright (c) 2025 Excelsior Technologies

Permission is hereby granted, free of charge, to any person obtaining a copy  
of this software and associated documentation files (the "Software"), to deal  
in the Software without restriction, including without limitation the rights  
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell  
copies of the Software, and to permit persons to whom the Software is  
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all  
copies or substantial portions of the Software.

