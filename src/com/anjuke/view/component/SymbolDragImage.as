package com.anjuke.view.component {
	import flash.display.*;

	import org.aswing.*;
	import org.aswing.dnd.DraggingImage;
	import org.aswing.graphics.*;

	public class SymbolDragImage implements DraggingImage {

		private var image : Sprite;
		private var source : Bitmap;
		private var width : int;
		private var height : int;

		public function SymbolDragImage(dragInitiator : Component) {
			width = dragInitiator.width;
			height = dragInitiator.height;
		
			source = new Bitmap(new BitmapData(width, height, true, 0x0));
			source.bitmapData.draw(dragInitiator);
			source.alpha = 0.5;
			image = new Sprite();
			image.addChild(source);
		}

		public function getDisplay() : DisplayObject {
			return image;
		}

		public function switchToRejectImage() : void {
			image.graphics.clear();
			var r : Number = Math.min(width, height) - 2;
			var x : Number = 0;
			var y : Number = 0;
			var g : Graphics2D = new Graphics2D(image.graphics);
			g.drawLine(new Pen(ASColor.RED, 2), x + 1, y + 1, x + 1 + r, y + 1 + r);
			g.drawLine(new Pen(ASColor.RED, 2), x + 1 + r, y + 1, x + 1, y + 1 + r);
		}

		public function switchToAcceptImage() : void {
			image.graphics.clear();
		}
	}
}
