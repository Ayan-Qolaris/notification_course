Sample json for Sending Push Notifications

Please add the following in the API header's Authorization: key=AAAA-DA73io:APA91bFwqIm1Qj86CC53jTBwxcUGCaR34r8s3VK3P0gYYezd8AAaHfN3hUamdFEyvKHxgpo9webCdRIGQM0wBQMfhrXUgloSNPdWfMojnBDmJVKij-aqE5Hv3tUlFWw3w2kZdI-asdAv

Please paste the token received in the Debug Console's log for the key "to" in the payload below.

{
"to" : "eaBLiwVtRVOa6zXhH4ePhn:APA91bEDh2TIRooh3vaFH10_xO3z96d1DUGlEnNi8CfCMHgKPOxJbpCX-EgbfEE7q8hR0Oa8VpCX7pc8bC9TGtElRaoYzDZejXAa9i5-KPI0zQ-ZRZabl_xukPAp34sps0rAaeSU00iN",
"priority": "high",
"mutable_content": true,
// "content-available": true,
"notification": {
"badge": 42,
"title": "Houston! The eagle has landed!",
"body": "A small step for a man, but a giant leap to Flutter's community!"
},
"data" : {
"content": {
"id": 1,
"badge": 42,
"channelKey": "basic_channel",
"displayOnForeground": true,
"category": "Call",
"notificationLayout": "BigPicture",
"bigPicture": "https://www.dw.com/image/49519617_303.jpg",
"wakeUpScreen": true,
"fullScreenIntent": true,
"showWhen": true,
"autoDismissible": false,
// "privacy": "Private",
"payload": {
"secret": "Awesome Notifications qRocks!",
"tokenize": "ABCD",
"channelName": "XYZ"
}
},
"actionButtons": [
{
"key": "ACCEPT",
"label": "Acept Call",
"autoDismissible": true
},
{
"key": "REJECT",
"label": "Reject Call",
"actionType": "DismissAction",
"isDangerousOption": true,
"autoDismissible": true
}
],
"Android": {
"content": {
"title": "The eagle has landed!",
"payload": {
"android": "android custom content!"
}
},
// "priority": "max"
},
"iOS": {
"content": {
"title": "The eagle has landed!",
"payload": {
"ios": "ios custom content!"
}
},
// "priority": "max",
"actionButtons": [
{
"key": "ACCEPT",
"label": "Acept Call",
"autoDismissible": true
},
{
"key": "REJECT",
"label": "Reject Call",
"actionType": "DismissAction",
"isDangerousOption": true,
"autoDismissible": true
}
]
}
}
}
