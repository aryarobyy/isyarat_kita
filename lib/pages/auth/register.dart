part of 'auth.dart';

class Register extends StatefulWidget {
  final void Function()? onTap;
  const Register({super.key, required this.onTap});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController1 = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final AuthService _auth = AuthService();
  bool isLoading = false;

  Future<void> createUser () async{
    setState(() {
      isLoading = true;
    });
    try{
      if (_emailController.text.isEmpty || _passwordController1.text.isEmpty || _passwordController2.text.isEmpty) {
        setState(() {
          isLoading = false;
        });
        MySnackbar(
          title: "Failed",
          text: "Email and password empty",
          type: "failure",
        ).show(context);
        return;
      }
      if (_passwordController1.text == _passwordController2.text) {
        String password = _passwordController1.text;
        await _auth.registerUser(
          name: _nameController.text,
          email: _emailController.text.toLowerCase(),
          password: password,
        );

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => DashboardPage())
        );
        MyPopup.show(
          context,
          title: "Akun Berhasil Dibuat!",
          content: "Silakan masuk untuk melanjutkan.",
          buttonText: "Lanjut",
        );
      } else{
        MySnackbar(title: "Failed", text: "Password 1 and 2 must same", type: "failure").show(context);
      }
    } catch(e) {
      MySnackbar(title: "Error", text: e.toString(), type: 'failure').show(context);;
      print("Cant create user $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.02,
          vertical: size.height * 0.03,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 0.1),
            MyTextField(
              controller: _emailController,
              name: "Email",
              prefixIcon: Icons.email,
              inputType: TextInputType.emailAddress,
              hintText: "ilham@gmail.com",
            ),
            SizedBox(height: size.height * 0.02),
            MyTextField(
              controller: _nameController,
              name: "Nama",
              prefixIcon: Icons.person,
              inputType: TextInputType.name,
              hintText: "ilham",
              obscureText: false,
            ),
            SizedBox(height: size.height * 0.02),
            MyTextField(
              controller: _passwordController1,
              name: "Password",
              prefixIcon: Icons.password,
              inputType: TextInputType.visiblePassword,
              hintText: "",
              obscureText: true,
            ),
            SizedBox(height: size.height * 0.02),
            MyTextField(
              controller: _passwordController2,
              name: "Confirm Password",
              prefixIcon: Icons.password,
              inputType: TextInputType.visiblePassword,
              hintText: "",
              obscureText: true,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Sudah punya akun?",
                  style: TextStyle(
                    color: blackColor,
                    fontSize: size.width * 0.035,
                  ),
                ),
                SizedBox(width: size.width * 0.01),
                InkWell(
                  onTap: widget.onTap,
                  child: Text(
                    "Masuk",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: size.width * 0.038,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: size.height * 0.01),
            Row(
              children: [
                const Expanded(child: Divider(color: Colors.grey)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                  child: Text(
                    "ATAU",
                    style: TextStyle(fontSize: size.width * 0.035),
                  ),
                ),
                const Expanded(child: Divider(color: Colors.grey)),
              ],
            ),
            SizedBox(height: size.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Image.asset(
                      "assets/images/google.png",
                      width: size.width * 0.12
                  ),
                ),
                SizedBox(width: size.width * 0.02),
                GestureDetector(
                  child: Image.asset(
                    "assets/images/facebook.png",
                    width: size.width * 0.12,
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.1),
            Column(
              children: [
                GestureDetector(
                  onTap: isLoading ? null : createUser,
                  child: Container(
                    width: size.width * 0.4,
                    height: size.height * 0.06,
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05,
                      vertical: size.height * 0.015,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: isLoading ? Colors.grey : secondaryColor,
                    ),
                    child: Center(
                      child: isLoading
                          ? CircularProgressIndicator(
                        color: whiteColor,
                      )
                          : Text(
                        "Daftar",
                        style: TextStyle(
                          fontSize: size.width * 0.04,
                          color: whiteColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
