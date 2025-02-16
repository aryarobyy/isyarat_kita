part of 'kamus.dart';

class AddKamus extends StatefulWidget {
  const AddKamus({super.key});

  @override
  State<AddKamus> createState() => _AddKamusState();
}

class _AddKamusState extends State<AddKamus> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  String? _selectedType;
  File? _selectedImage;
  bool _isEnabled = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> handleUploadImage() async {
    try {
      File? imageFile = await ImageService().pickImage();
      if (imageFile != null) {
        setState(() {
          _selectedImage = imageFile;
        });
      }
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  void addVocab() async {
    final signCode = _selectedType ?? "";

    VocabService().addVocab(
      name: _nameController.text.trim(),
      signCode: signCode,
      imageFile: _selectedImage
    );
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage(initialTab: 1,)
        )
    );
    MySnackbar(title: "Success", text: "Community telah dibuat", type: "success").show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Vocab")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: handleUploadImage,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      _selectedImage!,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  )
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, size: 40, color: Colors.grey[700]),
                      SizedBox(height: 8),
                      Text(
                        "Add Image",
                        style: TextStyle(color: Colors.grey[700], fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30,),
              MyTextField(
                controller: _nameController,
                name: "name",
                inputType: TextInputType.text,
              ),
            SizedBox(
              width: 400,
              height: 60,
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  onMenuStateChange: (isOpen) {
                    setState(() {
                      _isEnabled = isOpen;
                    });
                  },
                  hint: Text(
                    'Select Item',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  value: _selectedType,
                  items: <String>['BISINDO', 'SIBI'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedType = newValue!;
                    });
                  },
                  buttonStyleData: ButtonStyleData(
                    height: 50,
                    width: 420,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.black26),
                      color: Colors.white,
                    ),
                    elevation: 2,
                  ),
                  iconStyleData: IconStyleData(
                    icon: _isEnabled ? Icon(Icons.arrow_drop_up) : Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    iconEnabledColor: Colors.yellow,
                    iconDisabledColor: Colors.grey,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 200,
                    width: 400, // Same width as button
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.white,
                    ),
                    offset: const Offset(0, 0),
                    scrollbarTheme: ScrollbarThemeData(
                      radius: const Radius.circular(40),
                      thickness: MaterialStateProperty.all(6),
                      thumbVisibility: MaterialStateProperty.all(true),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
              MyButton(
                onPressed: addVocab,
                text: "Add Vocab",
              ),
            ],
          ),
        ),
      ),
    );
  }

}
