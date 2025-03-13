import 'package:flutter/material.dart';
import 'package:voci_app/features/requests/data/models/request.dart';

class AddModifyRequestDialog extends StatefulWidget {
  final String title;
  final Request? initialRequest;
  final Function(Request) onSave;

  const AddModifyRequestDialog({
    super.key,
    required this.title,
    this.initialRequest,
    required this.onSave,
  });

  @override
  AddModifyRequestDialogState createState() => AddModifyRequestDialogState();
}

class AddModifyRequestDialogState extends State<AddModifyRequestDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _id;
  late String? _creatorId;
  late String _homelessID;
  late String _title;
  late String _description;
  late RequestStatus _status;
  late int _timestamp;
  late RequestIconCategory _iconCategory;
  late RequestArea _area;

  @override
  void initState() {
    super.initState();
    _id = widget.initialRequest?.id ?? '';
    _creatorId = widget.initialRequest?.creatorId;
    _homelessID = widget.initialRequest?.homelessID ?? '';
    _title = widget.initialRequest?.title ?? '';
    _description = widget.initialRequest?.description ?? '';
    _status = widget.initialRequest?.status ?? RequestStatus.todo;
    _timestamp = widget.initialRequest?.timestamp ?? DateTime.now().millisecondsSinceEpoch;
    _iconCategory = widget.initialRequest?.iconCategory ?? RequestIconCategory.other;
    _area = widget.initialRequest?.area ?? RequestArea.ovest;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: true,
      initialChildSize: 0.9,
      minChildSize: 0.5,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              )
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _homelessID,
                      decoration: const InputDecoration(labelText: 'Homeless ID'),
                      validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter a homeless ID' : null,
                      onChanged: (value) => _homelessID = value,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _title,
                      decoration: const InputDecoration(labelText: 'Title'),
                      validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter a title' : null,
                      onChanged: (value) => _title = value,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _description,
                      decoration: const InputDecoration(labelText: 'Description'),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter a description'
                          : null,
                      onChanged: (value) => _description = value,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<RequestIconCategory>(
                      value: _iconCategory,
                      decoration: const InputDecoration(labelText: 'Icon Category'),
                      items: RequestIconCategory.values.map((RequestIconCategory category) {
                        return DropdownMenuItem<RequestIconCategory>(
                          value: category,
                          child: Text(category.displayName),
                        );
                      }).toList(),
                      onChanged: (RequestIconCategory? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _iconCategory = newValue;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<RequestArea>(
                      value: _area,
                      decoration: const InputDecoration(labelText: 'Area'),
                      items: RequestArea.values.map((RequestArea area) {
                        return DropdownMenuItem<RequestArea>(
                          value: area,
                          child: Text(area.name),
                        );
                      }).toList(),
                      onChanged: (RequestArea? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _area = newValue;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final newRequest = Request(
                                id: _id,
                                creatorId: _creatorId,
                                homelessID: _homelessID,
                                title: _title,
                                description: _description,
                                status: _status,
                                timestamp: _timestamp,
                                iconCategory: _iconCategory,
                                area: _area,
                              );
                              widget.onSave(newRequest);
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}