import 'dart:io';
import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iplayer/view/video_player_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'SearchBar.dart';
import 'CustomDrawer.dart';
import 'Play_Screen.dart';
import 'login_screen.dart';
import 'dart:typed_data';
class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}
class _LibraryScreenState extends State<LibraryScreen> {

  List<AssetPathEntity> videoFolders = [];
  List<AssetEntity> videoFiles = [];
  bool isFolderView = true;
  bool isGridView = true;
  String sortBy = "Name";
  List<String> sortOptions = ["Name", "Date", "Size", "Resolution"];

  @override
  void initState() {
    super.initState();
    _requestPermissionAndLoadFolders();
  }
  Future<void> _requestPermissionAndLoadFolders() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      _loadVideoFolders();
    } else {
      print("Permission denied");
    }
  }

  Future<void> _loadVideoFolders() async {
    final List<AssetPathEntity> albums =
    await PhotoManager.getAssetPathList(type: RequestType.video);

    List<AssetEntity> allVideos = [];
    for (var album in albums) {
      List<AssetEntity> videos = await album.getAssetListPaged(page: 0, size: 100);
      allVideos.addAll(videos);
    }

    setState(() {
      videoFolders = albums;
      videoFiles = allVideos; // Show all videos initially
      isFolderView = false; // Start with video view
    });
  }

  Future<void> _loadVideosFromFolder(AssetPathEntity folder) async {
    List<AssetEntity> media = await folder.getAssetListPaged(page: 0, size: 100);
    setState(() {
      videoFiles = media;
      isFolderView = false;
    });
  }
  Widget _buildFolderView() {
    return videoFolders.isEmpty
        ? Center(
      child: Text(
        "No video folders found!",
        style: GoogleFonts.poppins(
          fontSize: MediaQuery.of(context).size.width * 0.04, // Responsive text size
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade700,
        ),
      ),
    )
        : ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.04, // Responsive horizontal padding
        vertical: MediaQuery.of(context).size.height * 0.01, // Responsive vertical padding
      ),
      itemCount: videoFolders.length,
      itemBuilder: (context, index) {
        final folder = videoFolders[index];
        return GestureDetector(
          onTap: () => _loadVideosFromFolder(folder),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            transform: Matrix4.identity()..scale(1.0),
            child: Dismissible(
              key: Key(folder.id),
              background: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05, // Responsive padding
                ),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: MediaQuery.of(context).size.width * 0.07, // Responsive icon size
                ),
              ),
              secondaryBackground: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                ),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: MediaQuery.of(context).size.width * 0.07,
                ),
              ),
              onDismissed: (direction) {
                if (direction == DismissDirection.startToEnd) {
                  _deleteFolder(folder);
                } else {
                  _renameFolder(folder);
                }
              },
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white.withOpacity(0.15),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: MediaQuery.of(context).size.width * 0.03, // Responsive blur radius
                              spreadRadius: MediaQuery.of(context).size.width * 0.01, // Responsive spread radius
                              offset: Offset(2, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.035, // Responsive padding
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width * 0.025, // Responsive icon padding
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [Colors.deepPurple, Colors.purpleAccent],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Icon(
                                  Icons.folder,
                                  color: Colors.white,
                                  size: MediaQuery.of(context).size.width * 0.07, // Responsive icon size
                                ),
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width * 0.04), // Responsive spacing
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      folder.name,
                                      style: GoogleFonts.poppins(
                                        fontSize: MediaQuery.of(context).size.width * 0.04, // Responsive text size
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                                    FutureBuilder<int>(
                                      future: _getVideoCount(folder),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return Text(
                                            "Loading...",
                                            style: GoogleFonts.poppins(
                                              fontSize: MediaQuery.of(context).size.width * 0.03, // Responsive text size
                                              color: Colors.grey.shade600,
                                            ),
                                          );
                                        }
                                        return Text(
                                          "${snapshot.data ?? 0} Videos",
                                          style: GoogleFonts.poppins(
                                            fontSize: MediaQuery.of(context).size.width * 0.03,
                                            color: Colors.grey.shade600,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<int> _getVideoCount(AssetPathEntity folder) async {
    List<AssetEntity> assets = await folder.getAssetListRange(start: 0, end: 1000);
    return assets.where((asset) => asset.type == AssetType.video).length;
  }

  void _deleteFolder(AssetPathEntity folder) {
    print("Deleting folder: ${folder.name}");
  }

  void _renameFolder(AssetPathEntity folder) {
    print("Renaming folder: ${folder.name}");
  }

  void _showSettingsDialog(BuildContext context) async {

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(MediaQuery.of(context).size.width * 0.08),
        ),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(MediaQuery.of(context).size.width * 0.08),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: MediaQuery.of(context).size.width * 0.05,
                    spreadRadius: MediaQuery.of(context).size.width * 0.02,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.15,
                      height: MediaQuery.of(context).size.height * 0.008,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * 0.02,
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                    // Title
                    Text(
                      "Exclusive Features",
                      style: GoogleFonts.poppins(
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.015),

                    // Feature Buttons
                    _buildFeatureButton(
                      context,
                      icon: Icons.face_retouching_natural,
                      title: "Generate AI Avatar",
                      onTap: () => _showSubscriptionToast(),
                    ),
                    _buildFeatureButton(
                      context,
                      icon: Icons.video_collection,
                      title: "AI Face Mover & HD Video Downloader",
                      onTap: () => _showSubscriptionToast(),
                    ),
                    _buildFeatureButton(
                      context,
                      icon: Icons.chat,
                      title: "AI ChatBot",
                      onTap: () => _showSubscriptionToast(),
                    ),
                    _buildFeatureButton(
                      context,
                      icon: Icons.subtitles,
                      title: "Language Subtitle",
                      onTap: () => _showSubscriptionToast(),
                    ),
                    _buildFeatureButton(
                      context,
                      icon: Icons.mic,
                      title: "AI Voice Video Voice Changer",
                      onTap: () => _showSubscriptionToast(),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                    // Log Out Button

                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
  Widget _buildFeatureButton(BuildContext context,
      {required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.purpleAccent),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: MediaQuery.of(context).size.width * 0.04,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: MediaQuery.of(context).size.width * 0.05),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FeatureDetailsScreen(
              title: title,
              icon: icon,
            ),
          ),
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.03),
      ),
      tileColor: Colors.grey.shade900,
      contentPadding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.015,
        horizontal: MediaQuery.of(context).size.width * 0.05,
      ),
    );
  }





  void _showSubscriptionToast() {
    Fluttertoast.showToast(
      msg: "feature Cooming Soon!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.purpleAccent,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
  Widget _buildVideoView() {
    return videoFiles.isEmpty
        ? Center(
      child: Text(
        "No videos found!",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
        ),
      ),
    )
        : ListView.builder(
      padding: EdgeInsets.all(8),
      itemCount: videoFiles.length,
      itemBuilder: (context, index) {
        return FutureBuilder<Uint8List?>(
          future: videoFiles[index].thumbnailDataWithSize(ThumbnailSize(300, 200)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmerEffect();
            } else if (snapshot.hasError || !snapshot.hasData) {
              return _buildErrorTile();
            }
            return _buildVideoListTile(context, index, snapshot.data!);
          },
        );
      },
    );
  }
  Widget _buildVideoListTile(BuildContext context,
      int index, Uint8List thumbnail) {
    // Get Screen Size
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Format Duration as MM:SS
    String formatDuration(Duration? duration) {
      if (duration == null) return "00:00";
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      String minutes = twoDigits(duration.inMinutes.remainder(60));
      String seconds = twoDigits(duration.inSeconds.remainder(60));
      return "$minutes:$seconds";
    }

    // Format File Size in KB, MB, GB
    String formatFileSize(int bytes) {
      if (bytes <= 0) return "Unknown Size";

      const int KB = 1024;
      const int MB = KB * 1024;
      const int GB = MB * 1024;

      if (bytes >= GB) {
        return "${(bytes / GB).toStringAsFixed(2)} GB";
      } else if (bytes >= MB) {
        return "${(bytes / MB).toStringAsFixed(2)} MB";
      } else if (bytes >= KB) {
        return "${(bytes / KB).toStringAsFixed(2)} KB";
      } else {
        return "$bytes Bytes";
      }
    }

    // Display Video Resolution
    String getResolution(int? width, int? height) {
      if (width == null || height == null) return "Unknown Resolution";
      return "${width}x${height}";
    }

    // Format Date
    String formatDate(DateTime? date) {
      if (date == null) return "Unknown Date";
      return "${date.day}/${date.month}/${date.year}";
    }

    // Extract Details
    Duration? videoDuration = videoFiles[index].duration != null
        ? Duration(seconds: videoFiles[index].duration!)
        : null;
    String resolution = getResolution(videoFiles[index].width, videoFiles[index].height);
    DateTime? creationDate = videoFiles[index].createDateTime;
    String addedDate = formatDate(creationDate);

    // Get Actual File Size
    Future<int> getFileSize(int index) async {
      try {
        File? videoFile = await videoFiles[index].file;
        if (videoFile != null) {
          return videoFile.lengthSync();
        }
      } catch (e) {
        print("Error getting file size: $e");
      }
      return 0; // Return 0 if file size couldn't be determined
    }

    return GestureDetector(
      onTap: () async {
        File? videoFile = await videoFiles[index].file;
        if (videoFile != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlayScreen(videoPath: videoFile.path),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: Video file not found.")),
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.01,
            horizontal: screenWidth * 0.03
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.memory(
                thumbnail,
                width: screenWidth * 0.2, // Responsive Width
                height: screenHeight * 0.07, // Responsive Height
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: screenWidth * 0.03),

            // Video Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    videoFiles[index].title ?? "Unknown Title",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: screenWidth * 0.035, // Responsive Font Size
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Row(
                    children: [
                      Icon(Icons.access_time,
                          size: screenWidth * 0.035,
                          color: Colors.grey[600]
                      ),
                      SizedBox(width: screenWidth * 0.01),
                      Text(
                        formatDuration(videoDuration),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: screenWidth * 0.03, // Responsive Font Size
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // More Options with Popup Menu
            FutureBuilder<int>(
              future: getFileSize(index),
              builder: (context, snapshot) {
                String fileSizeText = "Loading...";
                if (snapshot.hasData) {
                  fileSizeText = formatFileSize(snapshot.data!);
                }

                return PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.grey[600],
                    size: screenWidth * 0.06,
                  ),
                  onSelected: (value) {},
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: 'resolution',
                      child: Row(
                        children: [
                          Icon(Icons.high_quality,
                              size: screenWidth * 0.045,
                              color: Colors.grey[700]
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          Text("Resolution: $resolution"),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'size',
                      child: Row(
                        children: [
                          Icon(Icons.sd_storage,
                              size: screenWidth * 0.045,
                              color: Colors.grey[700]
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          Text("Size: $fileSizeText"),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'date',
                      child: Row(
                        children: [
                          Icon(Icons.date_range,
                              size: screenWidth * 0.045,
                              color: Colors.grey[700]
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          Text("Added: $addedDate"),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.01,
        horizontal: MediaQuery.of(context).size.width * 0.03,
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Thumbnail Placeholder
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.height * 0.12,
                color: Colors.white,
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.03),

            // Text Placeholder
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Placeholder
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.02,
                    color: Colors.white,
                    margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.005),
                  ),
                  // Subtitle Placeholder 1
                  Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: MediaQuery.of(context).size.height * 0.015,
                    color: Colors.white,
                    margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.005),
                  ),
                  // Subtitle Placeholder 2
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.015,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        color: Colors.red[50],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: ListTile(
          leading: Icon(Icons.error, color: Colors.red, size: 30),
          title: Text("Error loading thumbnail", style: TextStyle(color: Colors.red[700])),
        ),
      ),
    );
  }
  Widget _buildCurvedHeader() {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: Container(
            height: screenHeight * 0.25, // Responsive height
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.4),
                  blurRadius: screenWidth * 0.05, // Responsive blur radius
                  spreadRadius: screenWidth * 0.02, // Responsive spread radius
                  offset: Offset(0, screenHeight * 0.03), // Responsive offset
                ),],
            ),),),
        ClipPath(
          clipper: CustomCurveClipper(),
          child: Container(
            height: screenHeight * 0.23, // Responsive height
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple.shade700, Colors.purpleAccent.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  child: Container(
                      child: CustomSearchBar(),
                  width: MediaQuery.sizeOf(context).width*0.9,
                    height: 60,

                  ),
                  top: MediaQuery.of(context).size.height * 0.03,
                  left: MediaQuery.of(context).size.width * 0.05,
                ),

                Center(
                  child: Text(
                    isFolderView ? "" : "",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.06, // Responsive font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Back Button on Top Left (Only in Video Screen)
                if (!isFolderView)
                  Positioned(
                    top: screenHeight * 0.09, // Responsive position
                    left: screenWidth * 0.04,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white, size: screenWidth * 0.08),
                      onPressed: () {
                        setState(() {
                          isFolderView = true; // Return to folder view
                        });
                      },
                    ),
                  ),

              ],
            ),
          ),
        ),

        // Highlighted Buttons with Glow
        Positioned(
          bottom: -screenHeight * 0.04, // Responsive position
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildGlowingButton(Icons.folder, "Folders", isFolderView, () {
                setState(() => isFolderView = true);
              }),
              _buildGlowingButton(Icons.video_library, "Videos", !isFolderView, () {
                setState(() => isFolderView = false);
              }),
              _buildGlowingButton(
                  Icons.paid_outlined,
                  "Exclusive",
                  false,
                      () => _showSettingsDialog(context) // Passing context using a lambda
              ),

            ],
          ),
        ),
      ],
    );
  }
  Widget _buildGlowingButton(IconData icon, String label,
      bool isSelected,VoidCallback onPressed) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,

              boxShadow: isSelected
                  ? [
                BoxShadow(
                  color: Colors.white.withOpacity(0.8),
                  blurRadius: screenWidth * 0.03, // Responsive blur radius
                  spreadRadius: screenWidth * 0.01, // Responsive spread radius
                ),
              ]
                  : [],
            ),
            child: CircleAvatar(
              radius: screenWidth * 0.08, // Responsive radius
              backgroundColor: isSelected ? Colors.white : Colors.grey.shade300,
              child: Icon(
                icon,
                color: isSelected ? Colors.deepPurple : Colors.grey,
                size: screenWidth * 0.07, // Responsive icon size
              ),
            ),
          ),
        ),
        SizedBox(height: screenWidth * 0.015), // Responsive space
        Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.035, // Responsive font size
          ),
        ),
      ],
    );
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 10,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.white
          ),
        ),
        title: Text('SLEEPLAY',style: TextStyle(fontWeight: FontWeight.w500),),
        actions: [IconButton(onPressed: (){
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>HelpAndSupportScreen()));
        }, icon: Icon(Icons.help_outline))],
      ),
        drawer: CustomDrawer(),
        backgroundColor: Colors.white,
        body:Column(
          children: [
            FadeInDown(
              child: _buildCurvedHeader(),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05), // Responsive height
            Expanded(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                child: isFolderView ? _buildFolderView() : _buildVideoView(),
              ),
            ),
          ],
        ),
    );}
}





class FeatureDetailsScreen extends StatefulWidget {
  final String title;
  final IconData icon;

  const FeatureDetailsScreen({required this.title, required this.icon});

  @override
  _FeatureDetailsScreenState createState() => _FeatureDetailsScreenState();
}

class _FeatureDetailsScreenState extends State<FeatureDetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();

    print("FeatureDetailsScreen loaded with title: ${widget.title}"); // Debugging
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showToast() {
    Fluttertoast.showToast(
      msg: "Feature Coming Soon!",
      backgroundColor: Colors.purpleAccent,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black87, Colors.deepPurpleAccent.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.12),
                Hero(
                  tag: widget.title,
                  child: BounceInDown(
                    child: CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.2,
                      backgroundColor: Colors.white.withOpacity(0.1),
                      child: Icon(
                        widget.icon,
                        color: Colors.white,
                        size: MediaQuery.of(context).size.width * 0.25,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  widget.title,
                  style: GoogleFonts.poppins(
                    fontSize: MediaQuery.of(context).size.width * 0.08,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SlideInUp(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _getFeatureList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            right: 20,
            child: BounceInUp(
              child: FloatingActionButton.extended(
                onPressed: _showToast,
                backgroundColor: Colors.deepPurple,
                label: Text(
                  "Get Started",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                icon: Icon(Icons.play_circle_fill, color: Colors.white, size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }


  List<Widget> _getFeatureList() {
    print("Feature Selected: ${widget.title}");

    String title = widget.title.trim().toLowerCase();

    if (title.contains("avatar")) {
      return [
        _buildFeatureItem(" AI-Powered Face Animation"),
        _buildFeatureItem(" Real-Time Facial Expressions"),
        _buildFeatureItem(" Custom Avatar Creation"),
        _buildFeatureItem(" Smooth Video Rendering"),
      ];
    } else if (title.contains("face mover")) {
      return [
        _buildFeatureItem(" AI Motion Tracking"),
        _buildFeatureItem(" Sync Faces to Audio"),
        _buildFeatureItem(" Auto Face Swap"),
        _buildFeatureItem(" Precision Facial Mapping"),
      ];
    } else if (title.contains("chatbot")) {
      return [
        _buildFeatureItem("  Advanced Natural Conversations"),
        _buildFeatureItem("  AI-Powered Smart Replies"),
        _buildFeatureItem("  Context-Aware Responses"),
        _buildFeatureItem("  Multi-Language Support"),
      ];
    } else if (title.contains("subtitle")) {
      return [
        _buildFeatureItem(" Real-Time Subtitle Generation"),
        _buildFeatureItem(" Multi-Language Translations"),
        _buildFeatureItem(" Speech-to-Text Processing"),
        _buildFeatureItem(" AI-Based Synchronization"),
      ];
    } else if (title.contains("voice video")) {
      return [
        _buildFeatureItem("🎙 AI Voice Cloning"),
        _buildFeatureItem(" Real-Time Voice Transformation"),
        _buildFeatureItem(" Video Lip-Sync AI"),
        _buildFeatureItem(" Custom Voice Effects"),
      ];
    } else {
      return [
        _buildFeatureItem(" Optimized Performance"),
        _buildFeatureItem(" Secure & Private"),
        _buildFeatureItem(" Fast & Responsive"),
        _buildFeatureItem(" Cloud Sync & Backup"),
      ];
    }
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(Icons.check, color: Colors.white, size: 22),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              feature,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
