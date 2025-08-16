part of 'settings.dart';

class Account extends StatefulWidget {
  UserModel? userData;
  Account({
    super.key,
    required this.userData
  });

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  void _handleDeleteAccount() {
    MyPopup2.show(
      context,
      title: "Konfirmasi Hapus Akun",
      agreeText: "Ya, Hapus Akun",
      disagreeText: "Batal",
      onAgreePressed: () async {
        try {
          await UserService().deleteUser(widget.userData!);
          MyPopup.show(context, title: "Akun berhasil dihapus", buttonText: "Lanjut");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => Authentication()),
          );
          print("User berhasil dihapus");
        } catch (e) {
          Navigator.of(context).pop();
          print("Error $e");
        }
      },
      onDisagreePressed: () => Navigator.of(context).pop(),
    );
  }


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
                  if (data.containsKey('onTapped')) {
                    data['onTapped']();
                  }
                },
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
      "onTapped": () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => UpdateProfile(userData: widget.userData!),
          ),
        );
      }
    },
    {
      "icons": Icons.attach_email_rounded,
      "content": "Verifikasi Akun",
    },
    {
      "icons": Icons.delete_forever,
      "content": "Hapus Akun",
      "onTapped": _handleDeleteAccount
    },
  ];
}
