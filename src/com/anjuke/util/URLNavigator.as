package com.anjuke.util {

	/**
	 * @author phil
	 */
	import flash.external.ExternalInterface;
	import flash.net.*;

	public class URLNavigator {

		/**
		 * Utility function to wrap up changing pages. Avoids over-aggressive popup blockers.
		 * @param url		The URL to change to. Either a String or a URLRequest
		 * @param window	The target browser window/tab, generally _self, _top, or _blank
		 * @usage URLNavigator.ChangePage("http://www.google.com", "_blank");
		 */
		public static function ChangePage(url : *, window : String = "_self") : void {
			var req : URLRequest = url is String ? new URLRequest(url) : url;
			if (!ExternalInterface.available) {
				navigateToURL(req, window);
			} else {
				var strUserAgent : String = String(ExternalInterface.call("function() {return navigator.userAgent;}")).toLowerCase();
				if (strUserAgent.indexOf("firefox") != -1 || (strUserAgent.indexOf("msie") != -1 && uint(strUserAgent.substr(strUserAgent.indexOf("msie") + 5, 3)) >= 7)) {
					//ExternalInterface.call("window.open", req.url, window);
					navigateToURL(req, window);
				} else {
					navigateToURL(req, window);
				}
			}
		}
	}
}
