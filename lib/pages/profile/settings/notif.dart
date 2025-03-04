part of 'settings.dart';

class Notif extends StatefulWidget {
  const Notif({super.key});

  @override
  State<Notif> createState() => _NotifState();
}

class _NotifState extends State<Notif> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        children: [
          MyHeader(
            title: "Notifikasi",
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => DashboardPage(initialTab: 4),
                ),
              );
            },
          ),
          MySwitchTile(
            title: "Notifikasi Percakapan",
            subTitle: "Putar suara untuk pesan masuk dan keluar",
            toggle: true,
          ),
          const SizedBox(height: 25),
          const Divider(),
          const SizedBox(height: 20),

          Expanded(
            child: ListView.builder(
              itemCount: _notifData.length,
              itemBuilder: (context, index) {
                final data = _notifData[index];
                return MySwitchTile(
                  title: data['title'] as String,
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
      "title": "Nada Notifikasi",
      "toggle": false,
    },
    {
      "title": "Getar",
      "toggle": true,
    },
    {
      "title": "Notifikasi Pop-up",
      "toggle": true,
    },

  ];
}
