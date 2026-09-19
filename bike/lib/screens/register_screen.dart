import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../main.dart'; // To access MainShell

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // Bike details controllers
  final _bikeBrandController = TextEditingController();
  final _bikeModelController = TextEditingController();
  final _bikeCcController = TextEditingController();
  final _bikeYearController = TextEditingController();
  final _bikeRegistrationController = TextEditingController();

  bool _obscurePassword = true;
  String _bikeStatus = 'Don\'t have bike'; // Default selection

  void _register() {
    // Implement actual registration logic here
    // For now, navigate to MainShell
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MainShell()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bikeBrandController.dispose();
    _bikeModelController.dispose();
    _bikeCcController.dispose();
    _bikeYearController.dispose();
    _bikeRegistrationController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        style: TextStyle(color: AppColors.themedText),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: AppColors.themedGrey),
          prefixIcon: Icon(icon, color: AppColors.orange),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.themedGreyBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.themedGreyBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.orange),
          ),
        ),
        obscureText: obscureText,
        keyboardType: keyboardType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.themedBackground,
      appBar: AppBar(
        title: const Text('Register'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.themedText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Join the squad today',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.themedGrey,
                ),
              ),
              const SizedBox(height: 32),
              _buildTextField(
                controller: _nameController,
                label: 'Full Name',
                icon: Icons.person_outline,
              ),
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              _buildTextField(
                controller: _passwordController,
                label: 'Password',
                icon: Icons.lock_outline,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.themedGrey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              
              const SizedBox(height: 10),
              Text(
                'Bike Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.themedText,
                ),
              ),
              const SizedBox(height: 16),
              
              // Dropdown for Bike Status
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.themedGreyBorder),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _bikeStatus,
                    isExpanded: true,
                    dropdownColor: AppColors.themedCard,
                    icon: Icon(Icons.keyboard_arrow_down, color: AppColors.orange),
                    style: TextStyle(color: AppColors.themedText, fontSize: 16),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _bikeStatus = newValue;
                        });
                      }
                    },
                    items: <String>['Have bike', 'Don\'t have bike']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Conditional Bike Details
              if (_bikeStatus == 'Have bike') ...[
                _buildTextField(
                  controller: _bikeBrandController,
                  label: 'Bike Brand (e.g., Yamaha, Honda)',
                  icon: Icons.motorcycle,
                ),
                _buildTextField(
                  controller: _bikeModelController,
                  label: 'Bike Model (e.g., R15, CBR 250R)',
                  icon: Icons.two_wheeler,
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _bikeCcController,
                        label: 'Engine CC',
                        icon: Icons.speed,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller: _bikeYearController,
                        label: 'Year',
                        icon: Icons.calendar_today,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                _buildTextField(
                  controller: _bikeRegistrationController,
                  label: 'Registration Number',
                  icon: Icons.numbers,
                ),
              ],
              
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _register,
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(color: AppColors.themedText),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: AppColors.orange,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
