import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dice_bear/dice_bear.dart';



class Header extends StatelessWidget {
  final String name;
  final bool isDarkTheme;
  final Function onThemeToggle;

  const Header({required this.name, required this.isDarkTheme, required this.onThemeToggle});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: isDarkTheme ? Color(0xFF1A1A2E) : Colors.white, // Match header color
        statusBarIconBrightness: isDarkTheme ? Brightness.light : Brightness.dark, // Adjust icon colors
      ),
    );
    Avatar avatar = DiceBearBuilder.withRandomSeed().build();
    String avatarUrl = avatar.svgUri.toString();

    return SafeArea(  
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        color: isDarkTheme ? const Color(0xFF1A1A2E) : Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
            width: 40, // Set width for the avatar
            height: 40, // Set height for the avatar
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black12,
            ),
            child: SvgPicture.network(
              avatarUrl
              // placeholder: (context) => const Center(child: CircularProgressIndicator()), // Loading indicator
              // errorWidget: (context, url, error) => Icon(Icons.error), // Handle errors
            ),
          ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hi, $name',
                  style: GoogleFonts.raleway(
                    textStyle: TextStyle(
                      fontSize: 17,
                      // fontWeight: FontWeight.bold,
                      color: isDarkTheme ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              icon: Icon(isDarkTheme ? Icons.light_mode : Icons.dark_mode),
              color: isDarkTheme ? Colors.white : Colors.black87,
              onPressed: () => onThemeToggle(),
            ),
          ],
        ),
      ),
    );
  }
}