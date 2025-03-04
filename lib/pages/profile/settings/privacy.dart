part of 'settings.dart';

class Privacy extends StatefulWidget {
  const Privacy({super.key});

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        children: [
          MyHeader(
            title: "Privasi dan Keamanan",
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
              itemCount: _notifData.length,
              itemBuilder: (context, index) {
                final data = _notifData[index];
                return MySwitchTile(
                  title: data['title'] as String,
                  subTitle: data['subTitle'] as String,
                  toggle: data['toggle'] as bool,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  final _notifData = [
    {
      "title": "Foto profil",
      "subTitle": "Disembunyikan",
      "toggle": true,
    },
    {
      "title": "Deskripsi",
      "subTitle": "Perlihatkan deskripsi singkat tentang anda",
      "toggle": true,
    },
    {
      "title": "Grup diblokir",
      "subTitle": "2",
      "toggle": false,
    },

  ];
}
