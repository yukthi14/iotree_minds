import 'package:flutter/material.dart';
import 'package:iotree_minds/model.dart';
import 'package:iotree_minds/providers.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Use Future.microtask to defer the fetch operation
    Future.microtask(() => _fetchData());
  }

  void _fetchData() async {
    await context.read<DataProvider>().fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Items',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<DataProvider>(
        builder: (context, provider, child) {
          return provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: provider.items.length ?? 0,
                  itemBuilder: (context, index) {
                    final post = provider.items[index];
                    return ListTile(
                      title: Text(post.item),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                              onTap: () {
                                _showUpdatePostDialog(
                                    context, post as Map<String, dynamic>);
                              },
                              child: const Text(
                                'Edit',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 24),
                              )),
                          GestureDetector(
                              onTap: () {
                                provider.deleteItem(post.id);
                              },
                              child: const Text(
                                'Delete',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 24),
                              )),
                        ],
                      ),
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            _showCreatePostDialog(context);
          },
          child: const Text(
            'Add',
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  void _showCreatePostDialog(BuildContext context) {
    final _titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Add Post',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
            ],
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black)),
              onPressed: () {
                final postData = {
                  'title': _titleController.text,
                };
                context.read<DataProvider>().createItem(postData as Item);
                Navigator.of(context).pop();
              },
              child: const Text(
                'Create',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showUpdatePostDialog(BuildContext context, Map<String, dynamic> post) {
    final _titleController = TextEditingController(text: post['title']);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Update Post',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<DataProvider>().updateItem(post['id'],
                    Item(id: post['id'], item: _titleController.text));
                Navigator.of(context).pop();
              },
              child: const Text(
                'Update',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
