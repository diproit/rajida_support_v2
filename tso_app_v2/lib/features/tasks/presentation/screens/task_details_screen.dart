import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tso_app_v2/features/tasks/presentation/screens/tasks_screen.dart';  // Add this import

class TaskDetailsScreen extends StatefulWidget {
  final TaskModel task;

  const TaskDetailsScreen({
    super.key,
    required this.task,
  });

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final TextEditingController _commentController = TextEditingController();
  final List<CommentModel> _comments = [];
  final List<WorkflowModel> _workflowItems = [];

  DateTime? _proposedDate;
  TimeOfDay? _proposedTime;
  bool _isProposing = false;

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

    _initializeWorkflow();
    _loadSampleComments();
  }

  void _initializeWorkflow() {
    // Initialize workflow based on current task status
    final task = widget.task;

    // Task Created
    _workflowItems.add(WorkflowModel(
      id: '1',
      title: 'Task Created',
      description: 'Task has been created and assigned',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      status: WorkflowStatus.completed,
      actor: 'System',
      actorType: ActorType.system,
    ));

    // Client Acceptance (based on status)
    if (task.status == TaskStatus.pending ||
        task.status == TaskStatus.proposed ||
        task.status == TaskStatus.confirmed) {
      _workflowItems.add(WorkflowModel(
        id: '2',
        title: 'Client Acceptance',
        description: task.status == TaskStatus.proposed
            ? 'Client proposed new schedule - Awaiting your response'
            : task.status == TaskStatus.confirmed
            ? 'Client confirmed the schedule'
            : 'Awaiting client acceptance',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        status: task.status == TaskStatus.confirmed
            ? WorkflowStatus.completed
            : task.status == TaskStatus.proposed
            ? WorkflowStatus.pending
            : WorkflowStatus.inProgress,
        actor: task.status == TaskStatus.confirmed ? 'Client' : 'Pending',
        actorType: task.status == TaskStatus.confirmed
            ? ActorType.client
            : ActorType.system,
        actionRequired: task.status == TaskStatus.proposed,
      ));
    }

    // Schedule Confirmation
    if (task.status == TaskStatus.confirmed ||
        task.status == TaskStatus.inProgress ||
        task.status == TaskStatus.completed ||
        task.status == TaskStatus.closed) {
      _workflowItems.add(WorkflowModel(
        id: '3',
        title: 'Schedule Confirmed',
        description: 'Service schedule confirmed for ${task.assignDate} at ${task.time}',
        timestamp: DateTime.now().subtract(const Duration(hours: 20)),
        status: WorkflowStatus.completed,
        actor: 'Both parties',
        actorType: ActorType.system,
      ));
    }

    // Task Started
    if (task.status == TaskStatus.inProgress ||
        task.status == TaskStatus.completed ||
        task.status == TaskStatus.closed) {
      _workflowItems.add(WorkflowModel(
        id: '4',
        title: 'Task Started',
        description: 'Field agent started the service',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        status: WorkflowStatus.completed,
        actor: 'John Doe (Agent)',
        actorType: ActorType.agent,
      ));
    }

    // Task Completed
    if (task.status == TaskStatus.completed ||
        task.status == TaskStatus.closed) {
      _workflowItems.add(WorkflowModel(
        id: '5',
        title: 'Task Completed',
        description: 'Service has been completed successfully',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        status: WorkflowStatus.completed,
        actor: 'John Doe (Agent)',
        actorType: ActorType.agent,
      ));
    }

    // Client Review & Closed
    if (task.status == TaskStatus.closed) {
      _workflowItems.add(WorkflowModel(
        id: '6',
        title: 'Client Review',
        description: 'Client reviewed and accepted the service',
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        status: WorkflowStatus.completed,
        actor: 'ABC Client',
        actorType: ActorType.client,
      ));

      _workflowItems.add(WorkflowModel(
        id: '7',
        title: 'Task Closed',
        description: 'Task has been closed successfully',
        timestamp: DateTime.now(),
        status: WorkflowStatus.completed,
        actor: 'System',
        actorType: ActorType.system,
      ));
    }
  }

  void _loadSampleComments() {
    if (widget.task.status != TaskStatus.pending) {
      _comments.add(CommentModel(
        id: '1',
        author: 'Client',
        authorType: ActorType.client,
        comment: 'Please complete the service by tomorrow.',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      ));

      _comments.add(CommentModel(
        id: '2',
        author: 'John Doe',
        authorType: ActorType.agent,
        comment: 'I will be there at 9:00 AM.',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ));
    }
  }

  void _addComment() {
    if (_commentController.text.isNotEmpty) {
      setState(() {
        _comments.add(CommentModel(
          id: DateTime.now().toString(),
          author: 'John Doe',
          authorType: ActorType.agent,
          comment: _commentController.text,
          timestamp: DateTime.now(),
        ));
        _commentController.clear();
      });
    }
  }

  void _proposeNewSchedule() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
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

    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.blue.shade700,
                onPrimary: Colors.white,
              ),
            ),
            child: child!,
          );
        },
      );

      if (time != null) {
        setState(() {
          _proposedDate = date;
          _proposedTime = time;
          _isProposing = true;
        });
      }
    }
  }

  void _submitProposal() {
    if (_proposedDate != null && _proposedTime != null) {
      setState(() {
        widget.task.status = TaskStatus.proposed;
        widget.task.assignDate = DateFormat('dd.MM.yyyy').format(_proposedDate!);
        widget.task.time = _proposedTime!.format(context);

        _workflowItems.add(WorkflowModel(
          id: DateTime.now().toString(),
          title: 'New Schedule Proposed',
          description: 'Agent proposed new schedule: ${widget.task.assignDate} at ${widget.task.time}',
          timestamp: DateTime.now(),
          status: WorkflowStatus.pending,
          actor: 'John Doe (Agent)',
          actorType: ActorType.agent,
          actionRequired: true,
        ));

        _isProposing = false;
        _proposedDate = null;
        _proposedTime = null;
      });
    }
  }

  void _acceptTask() {
    setState(() {
      widget.task.status = TaskStatus.confirmed;

      _workflowItems.add(WorkflowModel(
        id: DateTime.now().toString(),
        title: 'Task Accepted',
        description: 'You have accepted the task',
        timestamp: DateTime.now(),
        status: WorkflowStatus.completed,
        actor: 'John Doe (Agent)',
        actorType: ActorType.agent,
      ));
    });
  }

  void _startTask() {
    setState(() {
      widget.task.status = TaskStatus.inProgress;

      _workflowItems.add(WorkflowModel(
        id: DateTime.now().toString(),
        title: 'Task Started',
        description: 'Field agent started the service',
        timestamp: DateTime.now(),
        status: WorkflowStatus.completed,
        actor: 'John Doe (Agent)',
        actorType: ActorType.agent,
      ));
    });
  }

  void _finishTask() {
    setState(() {
      widget.task.status = TaskStatus.completed;

      _workflowItems.add(WorkflowModel(
        id: DateTime.now().toString(),
        title: 'Task Completed',
        description: 'Service has been completed successfully',
        timestamp: DateTime.now(),
        status: WorkflowStatus.completed,
        actor: 'John Doe (Agent)',
        actorType: ActorType.agent,
      ));
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Task Details',
          style: TextStyle(
            color: Color(0xFF1A237E),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: widget.task.statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: widget.task.statusColor.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: widget.task.statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  widget.task.statusText,
                  style: TextStyle(
                    color: widget.task.statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            // Client Information Card
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue.shade50,
                      Colors.white,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade100.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade700,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            widget.task.clientName[0],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.task.clientName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A237E),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  widget.task.serviceType,
                                  style: TextStyle(
                                    color: Colors.blue.shade700,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(height: 1),
                    const SizedBox(height: 20),

                    // Contact Info
                    _buildInfoRow(
                      icon: Icons.phone,
                      label: 'Phone',
                      value: widget.task.phone,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      icon: Icons.calendar_today,
                      label: 'Assign Date',
                      value: widget.task.assignDate,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      icon: Icons.access_time,
                      label: 'Time',
                      value: widget.task.time,
                    ),

                    if (widget.task.status == TaskStatus.proposed) ...[
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.orange.shade700,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Client proposed a new schedule. Please review and respond.',
                                style: TextStyle(
                                  color: Colors.orange.shade700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Action Buttons
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildActionButtons(),
              ),
            ),

            // Proposal Section
            if (_isProposing) ...[
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.edit_calendar,
                            color: Colors.blue.shade700,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Propose New Schedule',
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_proposedDate != null && _proposedTime != null) ...[
                        _buildInfoRow(
                          icon: Icons.calendar_today,
                          label: 'Proposed Date',
                          value: DateFormat('dd.MM.yyyy').format(_proposedDate!),
                          iconColor: Colors.blue.shade700,
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          icon: Icons.access_time,
                          label: 'Proposed Time',
                          value: _proposedTime!.format(context),
                          iconColor: Colors.blue.shade700,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _submitProposal,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade700,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('Submit Proposal'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _isProposing = false;
                                    _proposedDate = null;
                                    _proposedTime = null;
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.grey.shade700,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  side: BorderSide(color: Colors.grey.shade300),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('Cancel'),
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        const Text(
                          'Select new date and time for the service',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _proposeNewSchedule,
                            icon: const Icon(Icons.calendar_month),
                            label: const Text('Select Date & Time'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.blue.shade700,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(color: Colors.blue.shade700),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],

            SliverToBoxAdapter(child: SizedBox(height: 8)),

            // Comments Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Comments',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade900,
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    // Comment Input
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: TextField(
                              controller: _commentController,
                              decoration: InputDecoration(
                                hintText: 'Add a comment...',
                                hintStyle: TextStyle(color: Colors.grey.shade500),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                              maxLines: 3,
                              minLines: 1,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue.shade700, Colors.blue.shade600],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.shade200,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.send, color: Colors.white),
                            onPressed: _addComment,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Comments List
                    ..._comments.map((comment) => _buildCommentTile(comment)),

                    if (_comments.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 40,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'No comments yet',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 8)),

            // Workflow Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Workflow',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade900,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_getCompletedSteps()}/${_workflowItems.length} steps',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: _workflowItems.map((item) => _buildWorkflowTile(item)).toList(),
                ),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color iconColor = Colors.blue,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: iconColor,
        ),
        const SizedBox(width: 12),
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF1A237E),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    final task = widget.task;

    if (task.status == TaskStatus.pending) {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _acceptTask,
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Accept Task'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _proposeNewSchedule,
              icon: const Icon(Icons.edit_calendar),
              label: const Text('Propose'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue.shade700,
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: Colors.blue.shade700),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      );
    } else if (task.status == TaskStatus.proposed) {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _acceptTask,
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Accept Proposal'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _proposeNewSchedule,
              icon: const Icon(Icons.restore),
              label: const Text('Counter'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.orange.shade700,
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: Colors.orange.shade700),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      );
    } else if (task.status == TaskStatus.confirmed) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _startTask,
          icon: const Icon(Icons.play_arrow),
          label: const Text('Start Task'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
    } else if (task.status == TaskStatus.inProgress) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _finishTask,
          icon: const Icon(Icons.check),
          label: const Text('Finish Task'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildCommentTile(CommentModel comment) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: comment.authorType == ActorType.agent
            ? Colors.blue.shade50
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: comment.authorType == ActorType.agent
                ? Colors.blue.shade700
                : Colors.grey.shade600,
            child: Text(
              comment.author[0],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      comment.author,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: comment.authorType == ActorType.agent
                            ? Colors.blue.shade700
                            : Colors.grey.shade800,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      _formatTime(comment.timestamp),
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment.comment,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkflowTile(WorkflowModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Indicator
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: _getWorkflowStatusColor(item.status),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _getWorkflowStatusColor(item.status).withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Icon(
                    _getWorkflowStatusIcon(item.status),
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
              if (item != _workflowItems.last)
                Container(
                  width: 2,
                  height: 30,
                  color: item.status == WorkflowStatus.completed
                      ? Colors.green.shade200
                      : Colors.grey.shade300,
                ),
            ],
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: item.status == WorkflowStatus.completed
                              ? Colors.grey.shade900
                              : item.status == WorkflowStatus.inProgress
                              ? Colors.blue.shade700
                              : Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      _formatTime(item.timestamp),
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 12,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'by ${item.actor}',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                if (item.actionRequired) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 12,
                          color: Colors.orange.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Action Required',
                          style: TextStyle(
                            color: Colors.orange.shade700,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _getCompletedSteps() {
    return _workflowItems.where((item) =>
    item.status == WorkflowStatus.completed
    ).length;
  }

  Color _getWorkflowStatusColor(WorkflowStatus status) {
    switch (status) {
      case WorkflowStatus.completed:
        return Colors.green;
      case WorkflowStatus.inProgress:
        return Colors.blue;
      case WorkflowStatus.pending:
        return Colors.orange;
      case WorkflowStatus.cancelled:
        return Colors.red;
    }
  }

  IconData _getWorkflowStatusIcon(WorkflowStatus status) {
    switch (status) {
      case WorkflowStatus.completed:
        return Icons.check;
      case WorkflowStatus.inProgress:
        return Icons.autorenew;
      case WorkflowStatus.pending:
        return Icons.schedule;
      case WorkflowStatus.cancelled:
        return Icons.close;
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('dd.MM.yyyy').format(time);
    }
  }
}

// Models
enum WorkflowStatus {
  pending,
  inProgress,
  completed,
  cancelled,
}

enum ActorType {
  agent,
  client,
  system,
}

class WorkflowModel {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final WorkflowStatus status;
  final String actor;
  final ActorType actorType;
  final bool actionRequired;

  WorkflowModel({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.status,
    required this.actor,
    required this.actorType,
    this.actionRequired = false,
  });
}

class CommentModel {
  final String id;
  final String author;
  final ActorType authorType;
  final String comment;
  final DateTime timestamp;

  CommentModel({
    required this.id,
    required this.author,
    required this.authorType,
    required this.comment,
    required this.timestamp,
  });
}