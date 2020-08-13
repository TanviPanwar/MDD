//
//  URL.swift
//  QuickSereve
//
//  Created by Sobura on 10/2/2018.
//  Copyright © 2018 Sobura. All rights reserved.
//

import Foundation

var BASE_URL =  "https://www.richness.me/api/service/"

         // "https://www.richness.me/api/services/" //"http://api.richness.me/services/"

var REGISTER_URL = BASE_URL + "adduser"
var LOGIN_URL = BASE_URL + "login";
var GETTIMELINE_URL = BASE_URL + "gettimeline";
var GETSINGLEPOST_URL = BASE_URL + "getsinglepost";
var ADDLIKE_URL = BASE_URL + "addlike";
var ADDIMAGE_URL = BASE_URL + "addimage";
var DELETEPHOTO_URL = BASE_URL + "deleteimage";
var CHANGEAVATA_URL = BASE_URL + "changeimageprofile";
var CHANGEPROFILE_URL = BASE_URL + "modifyuser";
var REPORTPHOTO_URL = BASE_URL + "block_content";
var GETRANKING_URL = BASE_URL + "getranking";
var SOCIALLOGIN_URL = BASE_URL + "add_social_user";
var PURCHASECREDIT_URL = BASE_URL + "addrankuser";
var GETCOMMENTS_URL = BASE_URL + "get_comments";
var ADDCOMMENTS_URL = BASE_URL + "add_comment";
var ADDFOLLOWRES_URL = BASE_URL + "addfollower";
var SEARCHUSERS_URL = BASE_URL + "search_users";
var SEARCHHASHTAGS_URL = BASE_URL + "get_hashtags";
var GETFOLLOWERS_URL = BASE_URL + "getfollowers";
var GETFANS_URL = BASE_URL + "getfans";
var GETUSERDETAIL_URL = BASE_URL + "getuserdetail";
var UPDATEUSERDETAIL_URL = BASE_URL + "updateuserdetail";
var ISNOTIFICATION_URL = BASE_URL + "is_notifications";
var GETNOTIFICATION_URL = BASE_URL + "get_notifications";
var ADDDIAMOND_URL = BASE_URL + "adddiamonds"





var BASE_KEY = "6721zO71bSAXIU3S4NBQeb1a";

struct INSTAGRAM_API{
    static let INSTAGRAM_AUTHURL = "https://api.instagram.com/oauth/authorize/"
    static let INSTAGRAM_CLIENT_ID = "4f69866f48e04769a8b12b0ceed08fe0"
    static let INSTAGRAM_CLIENTSERCRET = "465c07315ba74e68a03977dc65607c57"
    static let INSTAGRAM_REDIRECT_URI = "https://instagram.com/"
    static let INSTAGRAM_ACCESS_TOKEN = "access_token"
    static let INSTAGRAM_SCOPE = "follower_list+public_content"
}

