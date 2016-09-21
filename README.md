## The Swift 3 chat example + iOS 10 rich push notifications
This sample app built using the Swift 3 language uses the Realtime® Framework Messaging service to send and receive chat messages organized into groups (includes iOS 10+ Rich Push Notifications support).  

![ScreenShot](https://framework.realtime.co/blog/img/ios10-push.png)

###This app is compatible with the Android sample. See [https://github.com/realtime-framework/MessagingAndroidChat](https://github.com/realtime-framework/MessagingAndroidChat)

### Setup project

*	Install [cocoapods](https://guides.cocoapods.org/using/getting-started.html#toc_3) and run command `pod install` on the podfile directory.

> NOTE: For simplicity these samples assume you're using a Realtime® Framework developers' application key with the authentication service disabled (every connection will have permission to publish and subscribe to any channel). For security guidelines please refer to the [Security Guide](http://messaging-public.realtime.co/documentation/starting-guide/security.html). 
> 
> **Don't forget to replace `YOUR_APPLICATION_KEY` and `YOUR_APPLICATION_PRIVATE_KEY` with your own application key. If you don't already own a free Realtime® Framework application key, [get one now](https://accounts.realtime.co/signup/).**


You are ready to go... 

## Sending iOS 10 Rich Push Notifications
Before you dive into the new iOS 10 notifications please have a look at this blog post: [http://framework.realtime.co/blog/ios10-push-notifications-support.html](http://framework.realtime.co/blog/ios10-push-notifications-support.html)

To test the iOS 10 push notifications using this app create a chat room named `ios10` and paste the following cURL command into your terminal (don't forget to enter your Realtime credentials):

	curl -X POST -d '{
	    "applicationKey": "YOUR_REALTIME_APPKEY",
	    "privateKey": "YOUR_REALTIME_PRIVATEKEY",
	    "channel" : "ios10",
	    "message": "Joe: These new iOS 10 Notifications are awesome!",
	    "apns": {
	        "aps":{
	            "alert":{
	                "title":"Realtime Custom Push Notifications",
	                "subtitle":"Now with iOS 10 support!",
	                "body":"Add multimedia content to your notifications"
	            },
	            "sound":"default",
	            "badge": 1,
	            "mutable-content": 1,
	            "category": "realtime",
	            "data":{
	                "attachment-url":"https://framework.realtime.co/blog/img/ios10-video.mp4"
	            }
	        }
	    }
	}' "https://ortc-mobilepush.realtime.co/mp/publish"

When you tap the notification in the device, the message used for the chat is the `message` property, but it's only an example, you can use other ways to have different messages for the notification body and chat message.

## About the Realtime Framework
Part of the [The Realtime® Framework](https://framework.realtime.co), Realtime Cloud Messaging (aka ORTC) is a secure, fast and highly scalable cloud-hosted Pub/Sub real-time message broker for web and mobile apps.

If your website or mobile app has data that needs to be updated in the user’s interface as it changes (e.g. real-time stock quotes or ever changing social news feed) Realtime Cloud Messaging is the reliable, easy, unbelievably fast, “works everywhere” solution.



