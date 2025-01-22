part of 'auth.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController1 = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();
  final AuthService _auth = AuthService();

  Future<void> createUser () async{
    try{
      if (_emailController.text.isEmpty || _passwordController1.text.isEmpty || _passwordController2.text.isEmpty) {
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
            email: _emailController.text,
            password: password
        );
      } else{
        MySnackbar(title: "Failed", text: "Password 1 and 2 must same", type: "failure").show(context);
      }

      MySnackbar(title: "Success", text: "Register success", type:"success").show(context);
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => DashboardPage())
      );

    } catch(e) {
      print("Cant create user $e");
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
              name: "addsasda",
              prefixIcon: Icons.email,
              inputType: TextInputType.emailAddress,
              hintText: "ilham@gmail.com",
            ),
            SizedBox(height: size.height * 0.02),
            MyTextField(
              controller: _passwordController1,
              name: "Password",
              prefixIcon: Icons.password,
              inputType: TextInputType.visiblePassword,
              hintText: "Aku ganteng",
              obscureText: true,
            ),
            SizedBox(height: size.height * 0.02),
            MyTextField(
              controller: _passwordController2,
              name: "Confirm Password",
              prefixIcon: Icons.password,
              inputType: TextInputType.visiblePassword,
              hintText: "Aku ganteng",
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
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder:
                      (context) => Authentication()
                      )
                    );
                  },
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
                  onTap: createUser,
                  child: Container(
                    width: size.width * 0.4,
                    height: size.height * 0.06,
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05,
                      vertical: size.height * 0.015,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: secondaryColor
                    ),
                    child: Center(
                      child: Text(
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
