part of 'settings.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyHeader(
          title: "Pengaturan Akun",
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => DashboardPage(initialTab: 4)),
            );
          },
        ),
        Expanded(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _data.length,
            itemBuilder: (context, index) {
              final data = _data[index];
              return ListTile(
                leading: Icon(
                  data['icons'] as IconData,
                  color: Colors.white,
                  size: 32,
                ),
                title: MyText(data['content']),
                onTap: () {
                },
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Mengatur agar teks rata kiri
                  children: [
                    if (data.containsKey('subtitle1'))
                      MyText(
                        data['subtitle1'],
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    if (data.containsKey('subtitle2'))
                      MyText(
                        data['subtitle2'],
                        fontSize: 14,
                        color: Colors.grey[500],
                      )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> get _data => [
    {
      "icons": Icons.manage_accounts_sharp,
      "content": "Email dan Kata Sandi",
      "subtitle1": "gatau@gmail.com",
      "subtitle2": "*************",
    },
    {
      "icons": Icons.attach_email_rounded,
      "content": "Verifikasi Akun",
    },
    {
      "icons": Icons.delete_forever,
      "content": "Hapus Akun",
    },
  ];
}
