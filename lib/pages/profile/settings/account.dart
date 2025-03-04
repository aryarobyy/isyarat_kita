part of 'settings.dart';

class Account extends StatelessWidget {
  const Account ({super.key});

  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        MyHeader(
            title: "Pengaturan Akun",
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardPage(initialTab: 4,)));
            }
        ),
        ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          itemCount: _settingData.length,
          separatorBuilder: (context, index) => Divider(
            color: Colors.grey.shade400,
            height: 1,
          ),
          itemBuilder: (context, index) {
            final data = _settingData[index];
          },
        )
      ],
    );
  }

  List<Map<String, dynamic>> get _settingData => [
    {
      "icons": Icons.manage_accounts,
      "content": "Pengaturan Akun",
    },
    {
      "icons": Icons.notifications,
      "content": "Notifikasi",
    },
    {
      "icons": Icons.security,
      "content": "Privasi dan Keamanan",
    },
    {
      "icons": Icons.language,
      "content": "Bahasa dan Aksesibilitas",
    },
    {
      "icons": Icons.headset_mic_rounded,
      "content": "Bantuan dan Dukungan",
    },
    {
      "icons": Icons.output,
      "content": "Log Out",
    }
  ];
}
