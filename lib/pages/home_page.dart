import 'package:first_app/utils/todo_list.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
   const Homepage({super.key});

   @override
   State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _controller = TextEditingController();
  List<Map<String, dynamic>> toDoList = [];
  String filter = 'All';
  void checkBoxChanged(int index) {
    setState(() {
      toDoList[index]['completed'] = !toDoList[index]['completed'];
    });
}
void saveNewTask() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        toDoList.add({
        'task': _controller.text,
        'dueDate': DateTime.now(),
        'completed': false,
    });
    _controller.clear();
    });
  }
 }

void deleteTask(int index) {
    setState(() {
      toDoList.removeAt(index);
    });
  }

void updateFilter(String newFilter) {
    setState(() {
      filter = newFilter;
    });
}

List<Map<String, dynamic>> getFilteredTasks() {
    if (filter == 'Completed') {
      return toDoList.where((task) => task['completed']).toList();
    }
    else if (filter == 'Pending') {
      return toDoList.where((task) => !task['completed']).toList();
 }
   else {
      return toDoList;
   }
}

   @override
   Widget build(BuildContext context) {
     var filteredTasks = getFilteredTasks();
     return Scaffold(
       backgroundColor: Colors.blue.shade100,
       appBar: AppBar(
         title: const Text(
           "Todo List",
         ),
         backgroundColor: Colors.blue.shade400,
         foregroundColor: Colors.white,
       ),
       body: Column(
         children: [
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: [
               FilterButton(
                 label: 'All',
                 isActive: filter == 'All',
                 onPressed: () => updateFilter('All'),
               ),
               FilterButton(
                 label: 'Completed',
                 isActive: filter == 'Completed',
                 onPressed: () => updateFilter('Completed'),
               ),
               FilterButton(
                 label: 'Pending',
                 isActive: filter == 'Pending',
                 onPressed: () => updateFilter('Pending'),
               ),
             ],
           ),
           Expanded(
             child: ListView.builder(
               itemCount: filteredTasks.length,
               itemBuilder: (BuildContext context, index) {
                 return TodoList(
                   taskName: filteredTasks[index]['task'],
                   dueDate: filteredTasks[index]['dueDate'],
                   taskCompleted: filteredTasks[index]['completed'],
                   onChanged: (value) => checkBoxChanged(toDoList.indexOf(filteredTasks[index])),
                   deleteFunction: (context) => deleteTask(toDoList.indexOf(filteredTasks[index])),
                 );
                 },
             ),
           ),
         ],
       ),
       floatingActionButton: Padding(
         padding: const EdgeInsets.symmetric(horizontal: 15),
         child: Row(
           children: [
             Expanded(
               child: Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 20),
                 child: TextField(
                   controller: _controller,
                   decoration: InputDecoration(
                     hintText: "Add a new item",
                     filled: true,
                     fillColor: Colors.blue.shade200,
                     enabledBorder: OutlineInputBorder(
                       borderSide: const BorderSide(
                         color: Colors.blue,
                       ),
                       borderRadius: BorderRadius.circular(15),
                     ),
                     focusedBorder: OutlineInputBorder(
                       borderSide: const BorderSide(
                         color: Colors.blue,
                       ),
                       borderRadius: BorderRadius.circular(15),
                     ),
                   ),
                 ),
               ),
             ),
             FloatingActionButton(
               onPressed: saveNewTask,
               child: const Icon(Icons.add),
             ),
           ],
         ),
       ),
     );
}
}
