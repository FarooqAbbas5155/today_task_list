import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/services.dart';

class WebviewScreen extends StatefulWidget {

  String url;


  @override
  _WebviewScreenState createState() => _WebviewScreenState();

  WebviewScreen({
    required this.url,
  });
}
late InAppWebViewController _webViewController;

class _WebviewScreenState extends State<WebviewScreen> {
  bool bac = false;
  bool far = false;
  final _key = UniqueKey();
  bool isLoading = false;
  Color bacColor = Colors.black;


  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      // print('object');
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }


  void _openWhatsAppChatWithPerson(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:Stack(
            children: [
              WillPopScope(
                onWillPop: () async {
                  if (await _webViewController.canGoBack()) {
                    _webViewController.goBack();
                    return false;
                  }
                  return true;
                },
                 child: InAppWebView(
                    initialUrlRequest: URLRequest(
                      url: WebUri(widget.url.toString()),
                    ),
                    onEnterFullscreen: (controller) async {
                      // Set preferred orientations to only portrait
                      await SystemChrome.setPreferredOrientations([
                        DeviceOrientation.landscapeRight,
                        DeviceOrientation.landscapeLeft
                      ]);
                    },
                    onExitFullscreen: (controller) async {
                      // Restore previous preferred orientations (e.g., all)
                      // Replace with your original orientations list
                      await SystemChrome.setPreferredOrientations([
                        DeviceOrientation.portraitDown,
                        DeviceOrientation.portraitUp,
                        DeviceOrientation.landscapeRight,
                        DeviceOrientation.landscapeLeft
                      ]);
                    },
                    initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                        javaScriptEnabled: true,
                        useOnDownloadStart: true,
                        mediaPlaybackRequiresUserGesture: false,
                        supportZoom: false,
                        useShouldOverrideUrlLoading: true,
                      ),
                      android: AndroidInAppWebViewOptions(
                        safeBrowsingEnabled: false,
                        mixedContentMode: AndroidMixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                      ),
                      ios: IOSInAppWebViewOptions(

                      ),
                    ),
                    onWebViewCreated: (controller) {
                      _webViewController = controller;
                    },
                  onLoadError: (controller,uri,v,error) {
                    isLoading = false;
                  },
                   onLoadStart: (controller,uri){
                     setState(() {
                       isLoading = true;
                     });
                   },
                    onLoadStop: (controller, url) async {
                      setState(() async {
                        isLoading = false;
                        if (await _webViewController.canGoBack()) {
                          setState(() {
                            bac = true;
                          });
                        } else {
                          bac = false;
                        }
                        if (await _webViewController.canGoForward()) {
                          setState(() {
                            far = true;
                          });
                        } else {
                          far = false;
                        }
                      });
                      debugPrint('Page finished loading: $url');
                    },
                    onProgressChanged: (controller, progress) {
                      print('progress ...........'+progress.toString());
                      setState(() {
                        var progres = progress;
                        if (progres == 80) {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      });
                      debugPrint('WebView is loading (progress : $progress%)');
                    },
                    shouldOverrideUrlLoading: (controller, navigationAction) async {
                      final uri = navigationAction.request.url;

                      if (uri != null) {
                        if (uri.scheme == 'mailto') {
                          // print('Opening Email link: ${uri.toString()}');
                          _launchUrl(uri.toString());
                          return NavigationActionPolicy.CANCEL;
                        }
                        else if (uri.scheme == 'whatsapp' && uri.host == 'chat') {
                          // print('Opening WhatsApp link: ${uri.toString()}');
                          _openWhatsAppChatWithPerson(uri.toString());
                          return NavigationActionPolicy.CANCEL;
                        }
                        else if (uri.scheme == 'https' && uri.host == 'm.me') {
                          // print('Opening Email link: ${uri.toString()}');
                          _launchUrl(uri.toString());
                          return NavigationActionPolicy.CANCEL;
                        }
                      }

                      // If none of the conditions are met, you might want to return a different value,
                      // depending on your requirements. The default here is NavigationActionPolicy.CANCEL.
                      return NavigationActionPolicy.ALLOW;
                    },
                  )
              ),
              Visibility(
                visible: isLoading,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.grey[100],
                  child: Shimmer.fromColors(
                    baseColor: Colors.black12,
                    highlightColor:  Colors.white10,
                    enabled: isLoading,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 40,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 20,
                                      width: MediaQuery.of(context).size.width-100,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      height: 20,
                                      margin: EdgeInsets.symmetric(vertical: 10),
                                      width: MediaQuery.of(context).size.width-200,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width-40,
                                  height: 20,
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                Container(
                                  height: 20,
                                  width: MediaQuery.of(context).size.width-100,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                Container(
                                  height: 20,
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  width: MediaQuery.of(context).size.width-200,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 100,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 150,
                            margin: EdgeInsets.all(20),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 150,
                            margin: EdgeInsets.all(20),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 150,
                            margin: EdgeInsets.all(20),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
