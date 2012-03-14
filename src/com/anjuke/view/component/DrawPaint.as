package com.anjuke.view.component {
			
	import flash.display.Sprite;
	import flash.display.BlendMode;
	import flash.system.Capabilities;
	import flash.display.BitmapData;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * @author phil
	 */
	public class DrawPaint extends Sprite{
		
		private var sp:Sprite;
		
		private var bg:Sprite;
		
		private var w:int =flash.system.Capabilities.screenResolutionX;
        private var h:int =flash.system.Capabilities.screenResolutionY;
        
        private var bmpData:BitmapData;
        
        private var resURL:String;
		
		public function DrawPaint():void{
			super();
			this.resURL = "";
			defaultBgStyle();
		}
		
		public function setRes(url:String):void{
			this.resURL = url;
		}

		public function defaultBgStyle():void{
	         this.sp= new Sprite();
	         this.bg = new Sprite();
	         sp.name = "bg";
	         
	         drawBackground(20);
	         //drawTiledBackground();
	         
	         this.addChild(bg);	
	
	         this.sp.graphics.beginFill(0xff0000,0);
	         this.sp.graphics.drawRect(0,0,this.w,this.h);
	         this.sp.graphics.endFill();
	         this.addChild(sp);
        }
        
        //背景网格
        public function drawBackground(space:int):void{
   			
			this.bg.graphics.clear();
			this.bg.graphics.lineStyle(1, 0xCCCCCC, 1);

			var i : int = space;
			while ( i < w ){
				this.bg.graphics.moveTo( i, 0 );
				this.bg.graphics.lineTo( i, h );
				i += space;
			}   
            i = space;
          	while ( i < h ){
              this.bg.graphics.moveTo( 0, i );
              this.bg.graphics.lineTo( w, i );
              i += space;
          	}        
        }
        
        //添加背景水印
        public function drawTiledBackground():void{     	
        	this.bg.graphics.clear();
        	//this.bmpData.draw(e.target.content);
        	var tc:Sprite = new Sprite();
        	tc.blendMode = BlendMode.LAYER;
			var label:TextField = new TextField();
			var format:TextFormat = new TextFormat();
			format.color = 0xf2f2f2;
			format.size = 16;
			format.font = "Verdana";
			label.width = 100;
			label.height = 25;	
			label.appendText("anjuke.com");
			label.setTextFormat(format);
			tc.addChild(label);
			//tc.rotation = Math.asin(1);
			var bmpData:BitmapData = new BitmapData(tc.width,tc.height);
			bmpData.draw(tc);
        	this.bg.graphics.beginBitmapFill(bmpData,null,true,true);
        	this.bg.graphics.lineTo (this.w, 0);
			this.bg.graphics.lineTo (this.w, this.h);
			this.bg.graphics.lineTo (0, this.h);
			this.bg.graphics.lineTo (0, 0);
			this.bg.graphics.endFill ();
        	
        }
        
        public function clearTiledBackground():void{
        	this.bg.graphics.clear();
        }
        
        public function clearBackground():void{
        	this.bg.graphics.clear();
        }
        
		
	}
}
