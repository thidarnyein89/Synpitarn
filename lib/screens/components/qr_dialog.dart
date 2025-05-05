import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';

class QRDialog {
  static void showQRDialog(
      BuildContext context, String imageUrl, String fileName) async {
    bool isDownloading = false;
    bool isFinish = false;
    String downloadMessage = "";

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> handleDownload() async {
              setState(() {
                isDownloading = true;
                isFinish = false;
                downloadMessage = "Downloading...";
              });

              try {
                FileDownloader.downloadFile(
                  url: imageUrl,
                  name: fileName,
                  onProgress: (fileName, progress) {
                    setState(() {
                      isDownloading = true;
                    });
                  },
                  onDownloadCompleted: (path) {
                    setState(() {
                      downloadMessage = "Download completed!";
                      isDownloading = false;
                      isFinish = true;
                    });
                  },
                  onDownloadError: (errorMessage) {
                    setState(() {
                      downloadMessage = "Error downloading: $errorMessage";
                      isDownloading = false;
                      isFinish = false;
                    });
                  },
                );
              } catch (e) {
                setState(() {
                  downloadMessage = "Error downloading";
                  isDownloading = false;
                  isFinish = false;
                });
              }
            }

            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FadeInImage(
                    placeholder: AssetImage('assets/images/spinner.gif'),
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.contain,
                    width: 200,
                    height: 200,
                    imageErrorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.broken_image),
                  ),
                  CustomWidget.verticalSpacing(),
                  Text(fileName),
                  CustomWidget.verticalSpacing(),
                  if (downloadMessage != "")
                    Row(
                      spacing: 5,
                      children: [
                        Icon(isFinish
                            ? Icons.done_outlined
                            : Icons.download_outlined),
                        Text(downloadMessage),
                      ],
                    )
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomWidget.elevatedButton(
                        context: context,
                        enabled: !isDownloading,
                        text: 'Download',
                        onPressed: handleDownload,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: CustomWidget.elevatedButton(
                        context: context,
                        text: 'Ok',
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
