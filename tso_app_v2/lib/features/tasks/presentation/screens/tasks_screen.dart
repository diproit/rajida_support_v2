import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tso_app_v2/features/tasks/presentation/screens/task_details_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<String> taskTypes = [
    'All Tasks',
    'Service Visit',
    'Online Issue',
    'Installation',
    'Maintenance',
  ];
  final List<String> statusTypes = [
    'All Status',
    'Pending',
    'Done',
    'In Progress',
    'Cancelled',
  ];

  String selectedTaskType = 'All Tasks';
  String selectedStatus = 'All Status';
  DateTime selectedDate = DateTime.now();

  final List<TaskModel> tasks = [
    TaskModel(
      clientName: 'ABC Client',
      phone: '0771234567',
      assignDate: '10.02.2026',
      time: '9:00 AM',
      serviceType: 'Service Visit',
      status: TaskStatus.pending, id: '',
    ),
    TaskModel(
      clientName: 'PQR Client',
      phone: '0771234567',
      assignDate: '11.02.2026',
      time: '9:00 AM',
      serviceType: 'Online Issue',
      status: TaskStatus.pending, id: '',
    ),
    TaskModel(
      clientName: 'LMN Client',
      phone: '0771234567',
      assignDate: '12.02.2026',
      time: '9:00 AM',
      serviceType: 'Service Visit',
      status: TaskStatus.done, id: '',
    ),
    TaskModel(
      clientName: 'JKL Client',
      phone: '0771234567',
      assignDate: '14.02.2026',
      time: '9:00 AM',
      serviceType: 'Online Issue',
      status: TaskStatus.done, id: '',
    ),
    TaskModel(
      clientName: 'XYZ Client',
      phone: '0777654321',
      assignDate: '15.02.2026',
      time: '11:30 AM',
      serviceType: 'Installation',
      status: TaskStatus.inProgress, id: '',
    ),
    TaskModel(
      clientName: 'DEF Client',
      phone: '0779876543',
      assignDate: '16.02.2026',
      time: '2:00 PM',
      serviceType: 'Maintenance',
      status: TaskStatus.pending, id: '',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header with greeting and profile
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tasks',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A237E),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'You have ${tasks.where((t) => t.status == TaskStatus.pending).length} pending tasks',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      // Container(
                      //   width: 50,
                      //   height: 50,
                      //   decoration: BoxDecoration(
                      //     gradient: LinearGradient(
                      //       colors: [
                      //         Colors.blue.shade700,
                      //         Colors.blue.shade400,
                      //       ],
                      //     ),
                      //     shape: BoxShape.circle,
                      //     boxShadow: [
                      //       BoxShadow(
                      //         color: Colors.blue.shade200,
                      //         blurRadius: 10,
                      //         offset: const Offset(0, 4),
                      //       ),
                      //     ],
                      //   ),
                      //   child: const Center(
                      //     child: Text(
                      //       'JD',
                      //       style: TextStyle(
                      //         color: Colors.white,
                      //         fontWeight: FontWeight.bold,
                      //         fontSize: 18,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),

            // Search Bar
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search tasks, clients...',
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.blue.shade700,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Filter Chips
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SizedBox(
                  height: 110,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'Task Type',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: taskTypes.length,
                          itemBuilder: (context, index) {
                            final type = taskTypes[index];
                            final isSelected = selectedTaskType == type;
                            return Container(
                              margin: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(type),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    selectedTaskType = type;
                                  });
                                },
                                backgroundColor: Colors.grey.shade50,
                                selectedColor: Colors.blue.shade700,
                                checkmarkColor: Colors.white,
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey.shade700,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                                side: BorderSide(
                                  color: isSelected
                                      ? Colors.blue.shade700
                                      : Colors.grey.shade300,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Status and Date Filters
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      // Status Filter
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Status',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedStatus,
                                  isExpanded: true,
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.blue.shade700,
                                  ),
                                  items: statusTypes.map((status) {
                                    return DropdownMenuItem(
                                      value: status,
                                      child: Text(
                                        status,
                                        style: TextStyle(
                                          color: Colors.grey.shade800,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedStatus = value!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Date Filter
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime(2024),
                                  lastDate: DateTime(2026, 12, 31),
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: ColorScheme.light(
                                          primary: Colors.blue.shade700,
                                          onPrimary: Colors.white,
                                          surface: Colors.white,
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );
                                if (picked != null) {
                                  setState(() {
                                    selectedDate = picked;
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${selectedDate.day.toString().padLeft(2, '0')}.${selectedDate.month.toString().padLeft(2, '0')}.${selectedDate.year}',
                                      style: TextStyle(
                                        color: Colors.grey.shade800,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Icon(
                                      Icons.calendar_today,
                                      size: 16,
                                      color: Colors.blue.shade700,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Tasks Header
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tasks',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade900,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.sort,
                              size: 16,
                              color: Colors.blue.shade700,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Sort',
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 16)),

            // Tasks List
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final task = tasks[index];
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: TaskCard(task: task),
                  );
                }, childCount: tasks.length),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final TaskModel task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade50,
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Navigate to task details screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetailsScreen(task: task),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Client Name and Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        task.clientName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A237E),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: task.statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: task.statusColor.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: task.statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            task.statusText,
                            style: TextStyle(
                              color: task.statusColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Phone
                Row(
                  children: [
                    Icon(Icons.phone, size: 16, color: Colors.grey.shade500),
                    const SizedBox(width: 8),
                    Text(
                      task.phone,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Assign Date and Time
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${task.assignDate} at ${task.time}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Divider
                Divider(color: Colors.grey.shade200, height: 1),
                const SizedBox(height: 12),

                // Service Type and Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            task.serviceIcon,
                            size: 14,
                            color: Colors.blue.shade700,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            task.serviceType,
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        if (task.status != TaskStatus.done)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.edit_outlined,
                                size: 20,
                                color: Colors.grey.shade600,
                              ),
                              onPressed: () {},
                              constraints: const BoxConstraints(
                                minWidth: 36,
                                minHeight: 36,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: task.status == TaskStatus.done
                                  ? [Colors.grey.shade400, Colors.grey.shade500]
                                  : [
                                      Colors.blue.shade700,
                                      Colors.blue.shade600,
                                    ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: (task.status == TaskStatus.done
                                    ? Colors.grey.shade400
                                    : Colors.blue.shade200),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: Icon(
                              task.status == TaskStatus.done
                                  ? Icons.check_circle
                                  : Icons.play_arrow,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {},
                            constraints: const BoxConstraints(
                              minWidth: 36,
                              minHeight: 36,
                            ),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Add this to your tasks_screen.dart file, update the TaskStatus enum and TaskModel class

enum TaskStatus {
  pending,
  proposed,
  confirmed,
  inProgress,
  completed,
  closed,
  cancelled,
  done,
}

class TaskModel {
  final String id;
  final String clientName;
  final String phone;
  String assignDate;
  String time;
  final String serviceType;
  TaskStatus status;

  TaskModel({
    required this.id,
    required this.clientName,
    required this.phone,
    required this.assignDate,
    required this.time,
    required this.serviceType,
    required this.status,
  });

  Color get statusColor {
    switch (status) {
      case TaskStatus.pending:
        return Colors.orange;
      case TaskStatus.proposed:
        return Colors.purple;
      case TaskStatus.confirmed:
        return Colors.blue;
      case TaskStatus.inProgress:
        return Colors.indigo;
      case TaskStatus.completed:
        return Colors.green;
      case TaskStatus.closed:
        return Colors.grey;
      case TaskStatus.cancelled:
        return Colors.red;
        case TaskStatus.done:
        return Colors.green;    }
  }

  String get statusText {
    switch (status) {
      case TaskStatus.pending:
        return 'PENDING';
      case TaskStatus.proposed:
        return 'PROPOSED';
      case TaskStatus.confirmed:
        return 'CONFIRMED';
      case TaskStatus.inProgress:
        return 'IN PROGRESS';
      case TaskStatus.completed:
        return 'COMPLETED';
      case TaskStatus.closed:
        return 'CLOSED';
      case TaskStatus.cancelled:
        return 'CANCELLED';
        case TaskStatus.done:
        return 'DONE';
    }
  }

  IconData get serviceIcon {
    switch (serviceType) {
      case 'Service Visit':
        return Icons.home_work_outlined;
      case 'Online Issue':
        return Icons.wifi;
      case 'Installation':
        return Icons.build;
      case 'Maintenance':
        return Icons.settings;
      default:
        return Icons.task_alt;
    }
  }
}
