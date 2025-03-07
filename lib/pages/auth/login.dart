part of 'auth.dart';

class Login extends StatefulWidget {
  final void Function()? onTap;

  const Login({super.key, required this.onTap});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> loginUser() async{
    setState(() {
      isLoading = true;
    });
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
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
    try{
      await UserService().loginUser(email: _emailController.text.toLowerCase(), password: _passwordController.text);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardPage()));
      MyPopup.show(
        context,
        title: "Login Berhasil",
        content: "Selamat datang!",
        buttonText: "Masuk",
      );
    } catch (e) {
      MySnackbar(
        title: "Failed",
        text: "password or email wrong",
        type: "failure",
      ).show(context);
      print("Error in login $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: SingleChildScrollView(
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
              controller: _passwordController,
              name: "Password",
              prefixIcon: Icons.password,
              inputType: TextInputType.visiblePassword,
              hintText: "Aku ganteng",
              obscureText: true,
            ),
            SizedBox(height: size.height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Lupa kata sandi?",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: size.width * 0.035,
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.05),
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
                  onTap: isLoading ? null : loginUser,
                  child: Container(
                    width: size.width * 0.4,
                    height: size.height * 0.06,
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05,
                      vertical: size.height * 0.015,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color:  isLoading ? Colors.grey : secondaryColor
                    ),
                    child:Center(
                      child: isLoading
                          ? CircularProgressIndicator(
                        color: whiteColor,
                      )
                          : Text(
                        "Masuk",
                        style: TextStyle(
                          fontSize: size.width * 0.04,
                          color: whiteColor,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Belum punya akun?",
                      style: TextStyle(
                        fontSize: size.width * 0.038,
                        color: whiteColor
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: widget.onTap,
                        child: Text(
                          "DAFTAR",
                          style: TextStyle(
                            fontSize: size.width * 0.039,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}