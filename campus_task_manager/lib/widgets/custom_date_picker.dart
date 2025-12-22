// lib/widgets/custom_date_picker.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  final ValueChanged<DateTime> onDateSelected;
  final DateTime initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? labelText;
  final bool showTime;
  
  const CustomDatePicker({
    super.key,
    required this.onDateSelected,
    required this.initialDate,
    this.firstDate,
    this.lastDate,
    this.labelText = 'Pilih Tanggal',
    this.showTime = false,
  });
  
  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  
  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _selectedTime = TimeOfDay.fromDateTime(widget.initialDate);
  }
  
  void _showDateSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _buildDateSelector();
      },
    );
  }
  
  Widget _buildDateSelector() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.labelText!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Year Selector
                  _buildYearSelector(),
                  
                  // Month Selector
                  _buildMonthSelector(),
                  
                  // Day Selector
                  _buildDaySelector(),
                  
                  // Time Selector (if enabled)
                  if (widget.showTime) _buildTimeSelector(),
                  
                  // Action Buttons
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildYearSelector() {
    final currentYear = DateTime.now().year;
    final List<int> years = List.generate(11, (index) => currentYear - 5 + index);
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tahun',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: years.map((year) {
              final isSelected = year == _selectedDate.year;
              return ChoiceChip(
                label: Text(year.toString()),
                selected: isSelected,
                onSelected: (_) {
                  setState(() {
                    _selectedDate = DateTime(
                      year,
                      _selectedDate.month,
                      _selectedDate.day,
                      _selectedTime.hour,
                      _selectedTime.minute,
                    );
                  });
                },
                selectedColor: Theme.of(context).primaryColor,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMonthSelector() {
    // PERBAIKAN DI SINI: Gunakan List<Map<String, dynamic>> dengan tipe yang tepat
    final List<Map<String, dynamic>> months = [
      {'id': 1, 'name': 'Januari'},
      {'id': 2, 'name': 'Februari'},
      {'id': 3, 'name': 'Maret'},
      {'id': 4, 'name': 'April'},
      {'id': 5, 'name': 'Mei'},
      {'id': 6, 'name': 'Juni'},
      {'id': 7, 'name': 'Juli'},
      {'id': 8, 'name': 'Agustus'},
      {'id': 9, 'name': 'September'},
      {'id': 10, 'name': 'Oktober'},
      {'id': 11, 'name': 'November'},
      {'id': 12, 'name': 'Desember'},
    ];
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bulan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: months.map((month) {
              final isSelected = month['id'] == _selectedDate.month;
              return ChoiceChip(
                label: Text(month['name']), // ✅ Tidak perlu '!' karena sudah dynamic
                selected: isSelected,
                onSelected: (_) {
                  setState(() {
                    _selectedDate = DateTime(
                      _selectedDate.year,
                      month['id'] as int, // ✅ Cast ke int
                      _selectedDate.day,
                      _selectedTime.hour,
                      _selectedTime.minute,
                    );
                  });
                },
                selectedColor: Theme.of(context).primaryColor,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDaySelector() {
    final daysInMonth = DateUtils.getDaysInMonth(
      _selectedDate.year,
      _selectedDate.month,
    );
    final List<int> days = List.generate(daysInMonth, (index) => index + 1);
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tanggal',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: days.map((day) {
              final isSelected = day == _selectedDate.day;
              return ChoiceChip(
                label: Text(day.toString()),
                selected: isSelected,
                onSelected: (_) {
                  setState(() {
                    _selectedDate = DateTime(
                      _selectedDate.year,
                      _selectedDate.month,
                      day,
                      _selectedTime.hour,
                      _selectedTime.minute,
                    );
                  });
                },
                selectedColor: Theme.of(context).primaryColor,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTimeSelector() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Waktu',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Hour selector
              _buildNumberSelector(
                value: _selectedTime.hour,
                min: 0,
                max: 23,
                label: 'Jam',
                onChanged: (hour) {
                  setState(() {
                    _selectedTime = TimeOfDay(hour: hour, minute: _selectedTime.minute);
                    _selectedDate = DateTime(
                      _selectedDate.year,
                      _selectedDate.month,
                      _selectedDate.day,
                      hour,
                      _selectedTime.minute,
                    );
                  });
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(':', style: TextStyle(fontSize: 24)),
              ),
              // Minute selector
              _buildNumberSelector(
                value: _selectedTime.minute,
                min: 0,
                max: 59,
                step: 5,
                label: 'Menit',
                onChanged: (minute) {
                  setState(() {
                    _selectedTime = TimeOfDay(hour: _selectedTime.hour, minute: minute);
                    _selectedDate = DateTime(
                      _selectedDate.year,
                      _selectedDate.month,
                      _selectedDate.day,
                      _selectedTime.hour,
                      minute,
                    );
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildNumberSelector({
    required int value,
    required int min,
    required int max,
    int step = 1,
    required String label,
    required ValueChanged<int> onChanged,
  }) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: value > min
                  ? () => onChanged(value - step)
                  : null,
              icon: const Icon(Icons.remove),
            ),
            Container(
              width: 60,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                value.toString().padLeft(2, '0'),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            IconButton(
              onPressed: value < max
                  ? () => onChanged(value + step)
                  : null,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black,
              ),
              child: const Text('BATAL'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                widget.onDateSelected(_selectedDate);
                Navigator.pop(context);
              },
              child: const Text('PILIH'),
            ),
          ),
        ],
      ),
    );
  }
  
  String _getFormattedDate() {
    if (widget.showTime) {
      return DateFormat('EEEE, dd MMMM yyyy HH:mm', 'id_ID').format(_selectedDate);
    } else {
      return DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(_selectedDate);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              widget.labelText!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        
        InkWell(
          onTap: _showDateSelector,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Icon(
                  widget.showTime ? Icons.access_time : Icons.calendar_today,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _getFormattedDate(),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      ],
    );
  }
}