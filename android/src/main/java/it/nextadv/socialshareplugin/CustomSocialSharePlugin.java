package it.nextadv.customsocialshare;

import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.net.Uri;
import android.os.AsyncTask;
import android.util.Log;

import androidx.core.content.FileProvider;

import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;

@CapacitorPlugin(name = "CustomSocialShare")
public class CustomSocialSharePlugin extends Plugin {

    @PluginMethod
    public void shareToInstagramFromUrl(PluginCall call) {
        String fileUrl = call.getString("url");
        String contentUrl = call.getString("content_url");
        String destination = call.getString("destination"); // story, post, reel

        if (fileUrl == null || fileUrl.isEmpty()) {
            call.reject("url is required");
            return;
        }

        if (destination == null || destination.isEmpty()) {
            destination = "post";
        }

        new DownloadAndShareTask(call, contentUrl, destination).execute(fileUrl);
    }

    private class DownloadAndShareTask extends AsyncTask<String, Void, Uri> {
        private final PluginCall call;
        private final String contentUrl;
        private final String destination;
        private String mimeType;
        private File localFile;

        DownloadAndShareTask(PluginCall call, String contentUrl, String destination) {
            this.call = call;
            this.contentUrl = contentUrl;
            this.destination = destination;
        }

        @Override
        protected Uri doInBackground(String... strings) {
            try {
                String urlString = strings[0];
                URL url = new URL(urlString);
                HttpURLConnection connection = (HttpURLConnection) url.openConnection();
                connection.connect();
                InputStream input = connection.getInputStream();

                String extension = urlString.toLowerCase().endsWith(".mp4") ? ".mp4" : ".jpg";
                mimeType = extension.equals(".mp4") ? "video/mp4" : "image/jpeg";

                localFile = new File(getContext().getCacheDir(), "shared_instagram_content" + extension);
                FileOutputStream output = new FileOutputStream(localFile);

                byte[] buffer = new byte[4096];
                int len;
                while ((len = input.read(buffer)) > 0) {
                    output.write(buffer, 0, len);
                }

                output.close();
                input.close();

                return FileProvider.getUriForFile(getContext(), getContext().getPackageName() + ".fileprovider", localFile);
            } catch (Exception e) {
                Log.e("CustomSocialShare", "Download error", e);
                return null;
            }
        }

        @Override
        protected void onPostExecute(Uri uri) {
            if (uri == null) {
                call.reject("Download or file error");
                return;
            }

            try {
                Intent intent;

                if ("story".equalsIgnoreCase(destination)) {
                    intent = new Intent("com.instagram.share.ADD_TO_STORY");
                    intent.setDataAndType(uri, mimeType);
                    intent.setPackage("com.instagram.android");
                    intent.setFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);

                    if (contentUrl != null && !contentUrl.isEmpty()) {
                        intent.putExtra("content_url", contentUrl);
                    }

                    getContext().grantUriPermission("com.instagram.android", uri, Intent.FLAG_GRANT_READ_URI_PERMISSION);
                    getContext().startActivity(intent);
                    call.resolve();
                    return;
                }

                intent = new Intent(Intent.ACTION_SEND);
                intent.setType(mimeType);
                intent.putExtra(Intent.EXTRA_STREAM, uri);
                intent.setPackage("com.instagram.android");
                intent.setFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
                getContext().grantUriPermission("com.instagram.android", uri, Intent.FLAG_GRANT_READ_URI_PERMISSION);

                switch (destination.toLowerCase()) {
                    case "reel":
                        intent.setClassName("com.instagram.android", "com.instagram.share.handleractivity.ReelShareHandlerActivity");
                        break;
                    case "post":
                        intent.setClassName("com.instagram.android", "com.instagram.share.handleractivity.ShareHandlerActivity");
                        break;
                }

                try {
                    getContext().startActivity(intent);
                    call.resolve();
                } catch (ActivityNotFoundException e) {
                    Log.w("CustomSocialShare", "Instagram activity not found, fallback to chooser");
                    intent.setPackage(null);
                    getContext().startActivity(Intent.createChooser(intent, "Condividi con Instagram"));
                    call.resolve();
                }

            } catch (Exception e) {
                Log.e("CustomSocialShare", "Error sharing to Instagram", e);
                call.reject("Sharing error: " + e.getMessage());
            }
        }
    }
}
