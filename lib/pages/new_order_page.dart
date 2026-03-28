import 'package:flutter/material.dart';

class NewDesign extends StatefulWidget {
  const NewDesign({super.key});

  @override
  State<NewDesign> createState() => _NewDesignState();
}

class _NewDesignState extends State<NewDesign> {

  int _selectedIndex = 1;
    //PrimaryColor
  final Color primaryDark = const Color(0xFF4A3B52);
  final Color primaryOrange = const Color.fromARGB(232, 202, 86, 44);
  final Color bgColor = const Color(0xFFF8F8F8);

  //collect files
  String? _selectedFileName;
  String  _selectedMaterial = 'PLA';
  String  _selectedQuality = 'Low';
  String  _selectedScrub = 'No';
  String  _SelectedColor = 'Filament Color';
  String  _selectedRequestFile = 'No';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: 48,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text('Import Deign', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryDark),
                    ),
                    Positioned(
                      left: 0,
                      child: IconButton(onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back, color: primaryDark, size: 28,)))
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              // UPLOAD BOX
              _buildUploadBox(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(onPressed: (){
                    setState(() {
                      _selectedFileName = null;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryOrange,
                    side: BorderSide(color: primaryOrange),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                  ),
                  child: const Text('Clear'),
                  ),
                  const SizedBox(width: 12,),
                  ElevatedButton(
                    onPressed: (){

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryOrange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      elevation: 0,
                    ),
                    child: const Text('Submit'),
                    ),
                ],
              ),
              const SizedBox(height: 32,),

              Text('Input Model Detail', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryDark),),
              const SizedBox(height: 20,),
              _buildOptionRow(title: 'Material', options: ['PLA', 'TPU', 'ABS', 'Resin'], currentValue: _selectedMaterial,
              onChanged: (val) => setState(() => _selectedMaterial = val),
              ),
              const SizedBox(height: 16,),
              _buildOptionRow(title: 'Quality', options: ['Low', 'Mid', 'High'], currentValue: _selectedQuality,
              onChanged: (val) => setState(() => _selectedQuality = val)),

              const SizedBox(height: 16,),
              _buildOptionRow(title: 'Scrub', options: ['Yes', 'No'], currentValue: _selectedScrub,
              onChanged: (val) => setState(() => _selectedScrub = val)),

              const SizedBox(height: 16,),
              _buildOptionRow(title: 'Color', options: ['Filament Color', 'Spray Color'], currentValue: _SelectedColor,
              onChanged: (val) => setState(() => _SelectedColor = val)),

              const SizedBox(height: 16,),
              _buildOptionRow(title: 'Request File', options: ['Yes', 'No'], currentValue: _selectedRequestFile,
              onChanged: (val) => setState(() => _selectedRequestFile = val)),

              const SizedBox(height: 16,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 90,
                  child: Text('Other', style: TextStyle(color: primaryDark, fontSize: 16)),
                  ),
                  Expanded(child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: primaryDark),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Optional...',
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.only(bottom: -13)
                      ),
                    ),
                  ))
                ],
              )

            ],
          ),
        ),
        ),
    );
  }
  Widget _buildUploadBox(){
    return GestureDetector(
      onTap: () {
        print("Tapped Upload Box");
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: primaryOrange, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.insert_drive_file_outlined, color: primaryOrange, size: 48,),
            const SizedBox(width: 16,),

            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                _selectedFileName ?? 'Import 3D Files\n Here',
                textAlign: TextAlign.center,
                style: TextStyle(
                color: primaryOrange,
                fontSize: 18,
                fontWeight: FontWeight.w500
              ),
            ),
            const SizedBox(height: 8,),
            const Text('(.stl and .obj file are allowed)', style: TextStyle(color: Colors.grey, fontSize: 12),)
          ],
        )
          ],
        ),
      ),
    );
  }

  Widget _buildOptionRow({
    required String title,
    required List<String> options,
    required String currentValue,
    required Function(String) onChanged,
  }){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Padding(padding: const EdgeInsets.only(top: 6.0),
          child: Text(
            title,
            style: TextStyle(color: primaryDark, fontSize: 16),
          ),
          ),
        ),
        Expanded(child: Wrap(
          spacing: 12,
          runSpacing: 10,
          children: options.map((options){
            final isSelected = currentValue == options;
            return GestureDetector(
              onTap: () => onChanged(options),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? primaryDark.withOpacity(0.05) : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? primaryDark : Colors.grey.shade400,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  options, style: TextStyle(
                    color: isSelected ? primaryDark : Colors.grey.shade600,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
                  ),
                ),
              ),
            );
          }).toList()
        ))
      ],
    );
  }

}