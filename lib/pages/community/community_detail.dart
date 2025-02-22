part of 'community.dart';

class CommunityDetail extends StatefulWidget {
  final RoomModel roomData;
  CommunityDetail({
    super.key,
    required this.roomData,
  });

  @override
  State<CommunityDetail> createState() => _CommunityDetailState();
}

class _CommunityDetailState extends State<CommunityDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(child: _build(context)),
    );
  }

  Widget _build(BuildContext context) {
    return Stack(
      children: [
        // Tombol back di pojok kiri atas
        Positioned(
          top: 16,
          left: 16,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              "assets/images/back-button.png",
              width: 40,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: widget.roomData.image.isNotEmpty
                  ? NetworkImage(widget.roomData.image)
                  : const AssetImage("assets/images/profile.png") as ImageProvider,
              radius: 120,
            ),
            const SizedBox(height: 20),
            Text(
              widget.roomData.title,
              style: TextStyle(
                fontSize: 32,
                color: whiteColor,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Divider(),
            Text(
              widget.roomData.description ?? "Deskripsi",
              style: TextStyle(
                fontSize: 22,
                color: whiteColor,
              ),
            ),
            const Divider(),
            Stack(
              alignment: Alignment.center,
              children: [
                const Center(
                  child: Text(
                    "Media dan dokumen",
                    style: TextStyle(
                      fontSize: 18,
                      color: whiteColor,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_forward_ios, color: whiteColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 7,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: InkWell(
                      onTap: () {},
                      child: SizedBox(
                        width: 120,
                        height: 70,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            "assets/images/launch1.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            Stack(
              alignment: Alignment.center,
              children: [
                const Center(
                  child: Text(
                    "Total anggota",
                    style: TextStyle(
                      fontSize: 18,
                      color: whiteColor,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search, color: whiteColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 8,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: const AssetImage("assets/images/profile.png"),
                        ),
                        title: const Text(
                          "Ilham",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
