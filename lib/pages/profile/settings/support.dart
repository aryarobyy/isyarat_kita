part of 'settings.dart';

class Support extends StatefulWidget {
  const Support({super.key});

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        children: [
          MyHeader(
            title: "Bantuan dan dukungan",
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => DashboardPage(initialTab: 4),
                ),
              );
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, index) {
                final data = _data[index];
                return ListTile(
                  leading: Icon(
                    data['icon'] as IconData,
                    color: Colors.white,
                    size: 32,
                  ),
                  title: MyText(data['title'] as String),
                  onTap: () {

                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  final _data = [
    {
      "icon": Icons.question_mark_rounded,
      "title": "Pusat bantuan",
    },
    {
      "icon": Icons.insert_drive_file,
      "title": "Ketentuan dan Kebijakan",
    },
    {
      "icon": Icons.info_outline,
      "title": "Info Aplikasi",
    },
  ];

}
