import 'package:flutter/material.dart';
import 'package:frontend/components/admin-components/permission-components/permission_data.dart';
import 'package:frontend/modules/permissions/models/permission.dart';
import 'package:frontend/modules/permissions/services/permission_service.dart';

class PermissionForm extends StatefulWidget {
  final Permission? permission;

  const PermissionForm({Key? key, this.permission}) : super(key: key);

  @override
  _PermissionFormState createState() => _PermissionFormState();
}

class _PermissionFormState extends State<PermissionForm> {
  final PermissionService _permissionService = PermissionService();
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _userIdController;
  
  String? _selectedPermissionType;
  String? _selectedAction;
  int _publishStatus = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _userIdController = TextEditingController();
    
    _selectedPermissionType = PermissionData.permissionTypes.values.first;
    _selectedAction = PermissionData.actions.first;
    _updateName();
    
    if (widget.permission != null) {
      _loadExistingPermission();
    }
  }

  void _loadExistingPermission() {
    final permission = widget.permission!;
    final parts = permission.name.split(':');
    if (parts.length == 2) {
      _selectedPermissionType = parts[0];
      _selectedAction = parts[1];
    }
    _descriptionController.text = permission.description;
    _userIdController.text = permission.userId.toString();
    _publishStatus = permission.publish;
    _updateName();
  }

  String get _generatedName => '${_selectedPermissionType}:${_selectedAction}';

  void _updateName() {
    _nameController.text = _generatedName;
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final userId = int.parse(_userIdController.text);
      final name = _generatedName;
      final description = _descriptionController.text;

      if (widget.permission == null) {
        await _permissionService.add(
          name: name,
          publish: _publishStatus,
          userId: userId,
          description: description,
        );
        _showSuccessMessage('Thêm quyền thành công');
      } else {
        await _permissionService.update(
          id: widget.permission!.id,
          name: name,
          publish: _publishStatus,
          userId: userId,
          description: description,
        );
        _showSuccessMessage('Cập nhật quyền thành công');
      }
      _navigateBack();
    } catch (e) {
      _showErrorMessage('Lỗi: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deletePermission() async {
    if (widget.permission == null) return;
    
    setState(() => _isLoading = true);
    try {
      await _permissionService.delete(widget.permission!.id);
      _showSuccessMessage('Xóa quyền thành công');
      _navigateBack();
    } catch (e) {
      _showErrorMessage('Lỗi: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _navigateBack() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.permission == null ? 'Thêm quyền mới' : 'Chỉnh sửa quyền'),
        actions: [
          if (widget.permission != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _isLoading ? null : _deletePermission,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildPermissionTypeDropdown(),
                    const SizedBox(height: 16),
                    _buildActionDropdown(),
                    const SizedBox(height: 16),
                    _buildNameField(),
                    const SizedBox(height: 16),
                    _buildDescriptionField(),
                    const SizedBox(height: 16),
                    _buildUserIdField(),
                    const SizedBox(height: 16),
                    _buildStatusDropdown(),
                    const SizedBox(height: 24),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildPermissionTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedPermissionType,
      decoration: const InputDecoration(
        labelText: 'Loại quyền',
        border: OutlineInputBorder(),
      ),
      items: PermissionData.permissionTypes.values.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedPermissionType = newValue;
          _updateName();
        });
      },
    );
  }

  Widget _buildActionDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedAction,
      decoration: const InputDecoration(
        labelText: 'Hành động',
        border: OutlineInputBorder(),
      ),
      items: PermissionData.actions.map((String action) {
        return DropdownMenuItem<String>(
          value: action,
          child: Text(action),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedAction = newValue;
          _updateName();
        });
      },
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Tên quyền',
        border: OutlineInputBorder(),
      ),
      enabled: false,
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: const InputDecoration(
        labelText: 'Mô tả',
        border: OutlineInputBorder(),
      ),
      maxLines: 3,
    );
  }

  Widget _buildUserIdField() {
    return TextFormField(
      controller: _userIdController,
      decoration: const InputDecoration(
        labelText: 'User ID',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập User ID';
        }
        if (int.tryParse(value) == null) {
          return 'Vui lòng nhập số';
        }
        return null;
      },
    );
  }

  Widget _buildStatusDropdown() {
    return Row(
      children: [
        const Text('Trạng thái:'),
        const SizedBox(width: 16),
        DropdownButton<int>(
          value: _publishStatus,
          onChanged: (int? newValue) {
            setState(() {
              _publishStatus = newValue!;
            });
          },
          items: PermissionData.publishStatus.entries
              .map((e) => DropdownMenuItem<int>(
                    value: e.key,
                    child: Text(e.value),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitForm,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            widget.permission == null ? 'Thêm quyền' : 'Cập nhật quyền',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _userIdController.dispose();
    super.dispose();
  }
}