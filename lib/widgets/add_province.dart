import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/data/provinces.dart';
import 'package:weather_app/themes/colors.dart';
import 'package:weather_app/themes/custom_fonts.dart';

class AddProvince extends StatefulWidget {
  final Function(String) onProvinceSelected;
  final List<String> selectedProvinces;

  const AddProvince(
      {Key? key,
      required this.onProvinceSelected,
      required this.selectedProvinces})
      : super(key: key);

  @override
  _AddProvinceState createState() => _AddProvinceState();
}

class _AddProvinceState extends State<AddProvince> {
  List<String> provincesList = provinces.keys.toList();
  List<String> selectedProvinces = [];

  @override
  void initState() {
    super.initState();
    _loadProvinces();
  }

  void _loadProvinces() {
    setState(() {
      selectedProvinces = widget.selectedProvinces;
    });
  }

  void _saveProvinces() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('selectedProvinces', selectedProvinces);
  }

  void _selectProvince(String province) {
    setState(() {
      selectedProvinces.contains(province)
          ? selectedProvinces.remove(province)
          : selectedProvinces.add(province);
    });
  }

  void _submitSelection() {
    for (var province in selectedProvinces) {
      widget.onProvinceSelected(province);
    }
    _saveProvinces();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        shadowColor: Colors.transparent,
        // flexibleSpace: Container(
        //   decoration: const BoxDecoration(
        //     gradient: LinearGradient(
        //       colors: [
        //         AppColors.firstGradientColor,
        //         AppColors.secondGradientColor,
        //         AppColors.thirdGradientColor,
        //         AppColors.fourthGradientColor,
        //       ],
        //       begin: Alignment.topCenter,
        //       end: Alignment.bottomCenter,
        //     ),
        //   ),
        // ),
        title: const Text("Аймаг сонгох"),
        actions: [
          IconButton(
            onPressed: _submitSelection,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.firstGradientColor,
              AppColors.secondGradientColor,
              AppColors.thirdGradientColor,
              AppColors.fourthGradientColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          itemCount: provincesList.length,
          itemBuilder: (context, index) {
            String province = provincesList[index];
            return Theme(
              data: Theme.of(context).copyWith(
                checkboxTheme: const CheckboxThemeData(
                  side: BorderSide(color: Colors.white),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CheckboxListTile(
                  title: Text(
                    province,
                    style: customFonts.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  value: selectedProvinces.contains(province),
                  onChanged: (isSelected) {
                    _selectProvince(province);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
