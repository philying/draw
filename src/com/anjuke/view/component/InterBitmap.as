package com.anjuke.view.component {
	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	/**
	 * @author philying
	 */
	public class InterBitmap extends Sprite{
		
		private var bitmap:Bitmap;
		private var bitmapdata:BitmapData;
		
		public function InterBitmap(bd:BitmapData){
			this.bitmapdata = bd;
			bitmap = new Bitmap(bd);
			addChild(bitmap);
		}
		
		public function getBD():BitmapData{
			return this.bitmapdata;
		}
		
		public function getBitmap():Bitmap{
			return this.bitmap;
		}
	}
}
