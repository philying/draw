package com.anjuke.view.component {
	import flash.display.Sprite;

	/**
	 * @author phil
	 */
	public class SymbolSprit extends Sprite {

		public var image : String;
		private var label : String;
		private var type : String;

		public function SymbolSprit(image : String,label : String,type : String = null) : void {
			this.image = image;
			this.label = label;
			this.type = type;
		}

		public function getImage() : String {
			return image;
		}

		public function getLabel() : String {
			return label;
		}

		public function getType() : String {
			return type;
		}

	}
}
