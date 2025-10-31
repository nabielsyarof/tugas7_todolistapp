import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ActivityProvider(),
      child: const ToDoApp(),
    ),
  );
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List Activity App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF7E57C2),
        scaffoldBackgroundColor: const Color(0xFFF8F7FA),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

// Provider untuk state management
class ActivityProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _activities = [];

  List<Map<String, dynamic>> get activities => _activities;

  void addActivity(String text) {
    _activities.add({'text': text, 'done': false});
    notifyListeners();
  }

  void deleteActivity(int index) {
    _activities.removeAt(index);
    notifyListeners();
  }

  void toggleDone(int index) {
    _activities[index]['done'] = !_activities[index]['done'];
    notifyListeners();
  }
}

// Home Page
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();

  void _addActivity() {
    final provider = Provider.of<ActivityProvider>(context, listen: false);
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      provider.addActivity(text);
      _controller.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"$text" ditambahkan ✅'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.deepPurple,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ActivityProvider>(context);
    final activities = provider.activities;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7E57C2), Color(0xFF512DA8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          "📝 To-Do Activity App",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            // 🔹 Input teks
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Contoh: Belajar Flutter",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.task_alt),
                    ),
                    onSubmitted: (_) => _addActivity(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7E57C2),
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  onPressed: _addActivity,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 🔹 List kegiatan
            Expanded(
              child: activities.isEmpty
                  ? const Center(
                      child: Text(
                        "✨ Belum ada kegiatan hari ini ✨",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  : ListView.builder(
                      itemCount: activities.length,
                      itemBuilder: (context, index) {
                        final activity = activities[index];
                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            leading: IconButton(
                              icon: Icon(
                                activity['done']
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: activity['done']
                                    ? Colors.green
                                    : Colors.purple,
                              ),
                              onPressed: () => provider.toggleDone(index),
                            ),
                            title: Text(
                              activity['text'],
                              style: TextStyle(
                                fontSize: 17,
                                decoration: activity['done']
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                color: activity['done']
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_forever,
                                  color: Colors.redAccent),
                              onPressed: () => provider.deleteActivity(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
