import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iplayer/view/video_player_screen.dart';


class SubscriptionScreen extends StatelessWidget {


  void _subscribe(String planName) {
    Fluttertoast.showToast(
      msg: "Cooming Soon $planName!",
      backgroundColor: Colors.purpleAccent,
      textColor: Colors.white,
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Feature Coming Soon!",style: TextStyle(color: Colors.white),),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.deepPurple.shade300,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> subscriptionPlans = [
      {
        'name': 'Basic Plan',
        'price': '\$9.99/month',
        'description': 'Access to limited features',
        'benefits': [
          'Access to basic content',
          'Limited downloads',
          'Ad-supported viewing'
        ],
      },
      {
        'name': 'Premium Plan',
        'price': '\$19.99/month',
        'description': 'Access to all features',
        'benefits': [
          'Ad-free experience',
          'Unlimited downloads',
          'Access to exclusive content',
          'HD streaming'
        ],
      },
      {
        'name': 'Pro Plan',
        'price': '\$29.99/month',
        'description': 'Advanced tools and analytics',
        'benefits': [
          'Priority support',
          '4K streaming',
          'Access to all premium features',
          'Early access to new releases'
        ],
      },
    ];

// Usage in a widget
    ListView.builder(
      itemCount: subscriptionPlans.length,
      itemBuilder: (context, index) {
        var plan = subscriptionPlans[index];
        var name = plan['name'] ?? '';
        var price = plan['price'] ?? '';
        var description = plan['description'] ?? '';

        return ListTile(
          title: Text(name),
          subtitle: Text(price),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SubscriptionDetailsScreen(
                  plan: name,                        // Plan Name
                  price: price,                       // Price
                  description: description,            // Description
                  benefits: plan['benefits'] ?? [],   // Benefits List
                ),
              ),
            );
          },
        );
      },
    );



    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          FadeInDown(child: _buildCurvedHeader(context)),

          Expanded(
            child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white, Colors.white],
                  ),
                ),
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  children: [
                    ...subscriptionPlans.asMap().entries.map((entry) {
                      int index = entry.key;
                      var plan = entry.value;
                      return FadeInUp(
                        delay: Duration(milliseconds: index * 300),
                        child: _buildSubscriptionCard(
                            context,
                            plan['name']!,
                            plan['price']!,
                            plan['benefits']!, // <-- Change here
                            plan['description']!,
                            "Subscribe Now"
                        ),

                      );
                    }).toList(),
                    SizedBox(height: 20),
                    _buildFeaturesSection(context),
                  ],
                )

            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurvedHeader(BuildContext context) {
    double baseHeight = 812; // Base screen height used for scaling
    double baseWidth = 375;  // Base screen width used for scaling

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: Container(
            height: MediaQuery.of(context).size.height * (190 / baseHeight), // Original 190
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.white10.withOpacity(0.4),
                  blurRadius: MediaQuery.of(context).size.height * (20 / baseHeight), // Original 20
                  spreadRadius: MediaQuery.of(context).size.height * (5 / baseHeight), // Original 5
                  offset: Offset(
                    0,
                    MediaQuery.of(context).size.height * (10 / baseHeight), // Original 10
                  ),
                ),
              ],
            ),
          ),
        ),
        ClipPath(
          clipper: CustomCurveClipper(),
          child: Container(
            height: MediaQuery.of(context).size.height * (180 / baseHeight), // Original 180
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple.shade700, Colors.purpleAccent.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(
                "Subscription Plans",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * (22 / baseWidth), // Original 22
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildSubscriptionCard(BuildContext context, String plan,
      String price, List<String> benefits, String description, String buttonText) {


    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * (20 / 375), // Original 20
        vertical: MediaQuery.of(context).size.height * (10 / 812),  // Original 10
      ),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.purpleAccent.withOpacity(0.1),
                blurRadius: 15,
                spreadRadius: 5,
                offset: Offset(0, 5),
              ),
            ],
            border: Border.all(color: Colors.purple.shade200)),
        child: Card(
          color: Colors.white.withOpacity(0.85),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          elevation: 15,
          child: Padding(
            padding: EdgeInsets.all(
                MediaQuery.of(context).size.width * (16 / 375)), // Original 16
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plan,
                  style: GoogleFonts.lato(
                    fontSize: MediaQuery.of(context).size.height * (20 / 812), // Original 20
                    fontWeight: FontWeight.bold,
                    color: Colors.purpleAccent,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * (10 / 812), // Original 10
                ),
                Text(
                  price,
                  style: GoogleFonts.lato(
                    fontSize: MediaQuery.of(context).size.height * (18 / 812), // Original 18
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * (10 / 812), // Original 10
                ),
                Text(
                  description,
                  style: GoogleFonts.lato(
                    fontSize: MediaQuery.of(context).size.height * (14 / 812), // Original 14
                    color: Colors.black54,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * (20 / 812), // Original 20
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubscriptionDetailsScreen(
                          plan: plan,
                          price: price,
                          description: description,
                          benefits: benefits,    // <-- Pass the list directly
                        ),
                      ),
                    );
                  },




                  // onPressed: () => _subscribe(plan),
                  child: Text(
                    buttonText,
                    style: GoogleFonts.lato(
                      fontSize: MediaQuery.of(context).size.height * (16 / 812), // Original 16
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * (12 / 812), // Original 12
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



  Widget _buildFeaturesSection(BuildContext context) {

    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * (20 / 812), // Original 20
        ),
        Text(
          "Exclusive Features",
          style: GoogleFonts.lato(
            fontSize: MediaQuery.of(context).size.height * (18 / 812), // Original 18
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * (10 / 812), // Original 10
        ),
        FadeInLeft(
          child: _buildFeatureCard(
            context,
            Icons.cloud_upload,
            "Cloud Backup & Restore",
          ),
        ),
        FadeInRight(
          child: _buildFeatureCard(
            context,
            Icons.lock,
            "Private Folders with Face ID & Passcode",
          ),
        ),
      ],
    );

  }

  Widget _buildFeatureCard(BuildContext context, IconData icon, String title) {
    double widthFactor = MediaQuery.of(context).size.width / 375;
    double heightFactor = MediaQuery.of(context).size.height / 812;

    return GestureDetector(
      onTap: () => _showComingSoon(context),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20 * widthFactor,
          vertical: 10 * heightFactor,
        ),
        child: Card(
          color: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12 * widthFactor),
          ),
          child: ListTile(
            leading: Icon(
              icon,
              color: Colors.purpleAccent,
              size: 30 * widthFactor,
            ),
            title: Text(
              title,
              style: GoogleFonts.lato(
                fontSize: 16 * widthFactor,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16 * widthFactor,  // Original 16
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

}




class SubscriptionDetailsScreen extends StatelessWidget {
  final String plan;
  final String price;
  final String description;
  final List<String> benefits;

  SubscriptionDetailsScreen({
    required this.plan,
    required this.price,
    required this.description,
    required this.benefits,
  });

  void _subscribe(String planName) {
    Fluttertoast.showToast(
      msg: "Coming Soon for $planName!",
      backgroundColor: Colors.purpleAccent,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          plan,
          style: GoogleFonts.lato(
            color: Colors.purpleAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.turn_left_sharp, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Gradient Header with Animation
          FadeInDown(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * (20 / 812),
                horizontal: MediaQuery.of(context).size.width * (20 / 375),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple.shade700, Colors.purpleAccent.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purpleAccent.withOpacity(0.4),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan,
                    style: GoogleFonts.lato(
                      fontSize: MediaQuery.of(context).size.height * (28 / 812),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * (10 / 812)),
                  Text(
                    price,
                    style: GoogleFonts.lato(
                      fontSize: MediaQuery.of(context).size.height * (22 / 812),
                      fontWeight: FontWeight.w600,
                      color: Colors.yellowAccent,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * (10 / 812)),
                  Text(
                    description,
                    style: GoogleFonts.lato(
                      fontSize: MediaQuery.of(context).size.height * (16 / 812),
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * (20 / 812)),
          Text(
            "Key Benefits",
            style: GoogleFonts.lato(
              fontSize: MediaQuery.of(context).size.height * (20 / 812),
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple.shade700,
            ),
          ),
          // Animated List of Benefits
          Expanded(
            child: ListView.builder(
              itemCount: benefits.length,
              itemBuilder: (context, index) {
                return FadeInUp(
                  delay: Duration(milliseconds: index * 300),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.purpleAccent.shade700)),
                      child: Card(elevation: 5,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.check_circle, color: Colors.purpleAccent),
                          title: Text(
                            benefits[index],
                            style: GoogleFonts.lato(
                              fontSize: MediaQuery.of(context).size.height * (16 / 812),
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * (20 / 812),
              horizontal: MediaQuery.of(context).size.width * (20 / 375),
            ),
            child: ElevatedButton(
              onPressed: () => _subscribe(plan),
              child: Text(
                "Subscribe Now",
                style: GoogleFonts.lato(
                  fontSize: MediaQuery.of(context).size.height * (18 / 812),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purpleAccent,
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * (14 / 812),
                  horizontal: MediaQuery.of(context).size.width * (40 / 375),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                shadowColor: Colors.purpleAccent.withOpacity(0.5),
                elevation: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}




