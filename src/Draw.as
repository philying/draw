package {
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;

	import flash.events.*;
	import flash.text.*;
	import flash.display.Sprite;
	import flash.display.GradientType;
	import flash.display.LoaderInfo;

	/**
	 * @author phil
	 * @desc 预加载类
	 */
	public class Draw extends Sprite {

		public var loader : BulkLoader;

		public var txt : TextField;

		public var stgb : Sprite;

		public var stg : Sprite;

		public function Draw() : void {
			
			txt = new TextField();
			//创建文本文件 txt

			txt.autoSize = TextFieldAutoSize.CENTER;
			//文本文件自适应大小并且居中显示

			txt.text = "加载中...";
			txt.textColor = 0x000000;
			txt.antiAliasType = AntiAliasType.ADVANCED;
			//设置文本颜色

			txt.selectable = false;
			//文本设置为不可选

			txt.x = this.stage.stageWidth / 2 - txt.width / 2;
			txt.y = this.stage.stageHeight / 2 - txt.height / 2;
			//txt.embedFonts=true;

			var textform : TextFormat = new TextFormat();
			//textform.font="微软雅黑";
			//textform.propertyIsEnumerable("微软雅黑");		
			textform.color = 0x808080;
			textform.size = 12;
			
			txt.defaultTextFormat = textform;
			
			this.addChild(txt);
			
			stgb = new Sprite();
			//stgb.graphics.lineStyle(1,0x000000,3);
			stgb.graphics.beginFill(0xff0000, .5);
			//采用单色填充，红色透明50%（.5）			
			stgb.graphics.drawRect(0, 0, this.stage.stageWidth, 3);
			stgb.graphics.endFill();
			stgb.x = this.stage.stageWidth / 2 - stgb.width / 2;
			stgb.y = txt.y + txt.height + 5;
			
			this.addChild(stgb);
			
			stg = new Sprite();
			//stg.graphics.lineStyle(1,0x000000,.5);

			stg.graphics.beginGradientFill(GradientType.LINEAR, [0xff0000,0xffffff], [100,100], [0,255]);
			//采用渐变填充 红--黄		
			stg.graphics.drawRect(0, 0, this.stage.stageWidth, 3);
			stg.graphics.endFill();
			stg.x = this.stage.stageWidth / 2 - stg.width / 2;
			stg.y = txt.y + txt.height + 5;
			
			this.addChild(stg);
			
			var URL:String = LoaderInfo(stage.loaderInfo).parameters["resURL"];
			if(URL == null){
				URL = "";
			}
			loader = new BulkLoader("main-app");
			//loader.logLevel = BulkLoader.LOG_INFO;
			loader.add(URL+"Main.swf", {id:"main"});
		 	
			// dispatched when ALL the items have been loaded:
			loader.addEventListener(BulkLoader.COMPLETE, onAllItemsLoaded);
            
			// dispatched when any item has progress:
			loader.addEventListener(BulkLoader.PROGRESS, onAllItemsProgress);
            
			// now start the loading
			loader.start();
		}

		public function onAllItemsLoaded(evt : Event) : void {
			this.removeChild(txt);
			this.removeChild(stgb);
			this.removeChild(stg);
			var main : * = loader.getSprite("main"); 
			this.addChild(main);
			main.init();
		}

		public function onAllItemsProgress(evt : BulkProgressEvent) : void {
			//trace(evt.loadingStatus());
			//trace(Math.floor(evt._percentLoaded * 100));
			txt.text = Math.floor(evt._percentLoaded * 100) + " % 已完成";
			stg.scaleX = evt._percentLoaded;
		}
	}
}
