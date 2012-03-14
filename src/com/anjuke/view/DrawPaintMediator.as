package com.anjuke.view {
	import flash.net.navigateToURL;
	import flash.net.URLRequestMethod;
	import flash.net.URLRequestHeader;
	import flash.display.Stage;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.display.LoaderInfo;
	import flash.display.DisplayObject;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.Matrix;

	import com.adobe.images.JPGEncoder;
	import flash.utils.ByteArray;

	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;

	import com.anjuke.ApplicationFacade;
	import com.anjuke.view.component.*;
	import com.anjuke.util.*;

	import org.aswing.JPanel;
	import org.aswing.ASColor;
	import org.aswing.border.LineBorder;
	import org.aswing.JCheckBox;
	import org.aswing.JFrame;
	import org.aswing.event.DragAndDropEvent;
	import org.aswing.JLoadPane;
	import org.aswing.CursorManager;

	import ui.*;

	/**
	 * @author phil
	 */
	public class DrawPaintMediator extends Mediator implements IMediator {
		// Cannonical name of the Mediator
		public static const NAME : String = 'DrawPaintMediator';

		private var drawpaint : DrawPaint;
		private var drawpaint_outer : DrawPaint

		private var symbolPool : Array;
		private var txtPool : Array;
		private var linePool : Array;
		private var recPool:Array;
		private var symbolKey : int;
		//private var selectCursor : Sprite;
		private var typeCursor:Sprite;
		private var eraserCursor:Sprite;
		private var freetran : FreeTran;
		private var format : TextFormat;
		private var startX : Number;
		private var startY : Number;
		private var endX:Number;
		private var endY:Number;
		private var fontX:Number;
		private var fontY:Number;
		private var draw : Rectangle;
		private var outputURL : String;
		private var resURL:String;
		private var focusSymbol : Sprite;
		private var pane:CreateTextPane;
		private var txtframe:JFrame;
		private var drawlineStart:Boolean;
		private var eraseArea:Sprite;

		public function DrawPaintMediator(viewComponent : Object) {
			super(NAME, viewComponent);
			symbolPool = new Array();
			symbolKey = 0;
			txtPool = new Array();
			linePool = new Array();
			recPool = new Array();
			var cursorLoader : Loader = new Loader();
			var cursorLoader_2 : Loader = new Loader();
			//cursorLoader.load(new URLRequest("res/icon/dragTool.swf"));
			//selectCursor = new Sprite();
			//selectCursor.addChild(cursorLoader);
			format = new TextFormat();
			
			outputURL = LoaderInfo(stage.loaderInfo).parameters["resURL"];
			if(outputURL == null) {
				outputURL = "jpg_encoder_download.php?name=draw.jpg";
			}
			resURL = LoaderInfo(stage.loaderInfo).parameters["resURL"];
			if(resURL == null) {
				resURL = "";
			}
			typeCursor = new Sprite();
			cursorLoader.load(new URLRequest(resURL + "res/icon/type.png"));
			typeCursor.addChild(cursorLoader);
			eraserCursor = new Sprite();
			cursorLoader_2.load(new URLRequest(resURL + "res/icon/eraser_cursor.png"));
			eraserCursor.addChild(cursorLoader_2);
			drawlineStart = false;
		}

		
		override public function listNotificationInterests() : Array {
			return [ApplicationFacade.DRAWPAINT_SHOW,
				ApplicationFacade.DRAWPAINT_GRIDSHOW,
				ApplicationFacade.DRAWSYMBOL_LOAD,
				ApplicationFacade.TOOL_DO_SELECT,
				ApplicationFacade.TOOL_CANCLE_SELECT,
				ApplicationFacade.TOOL_CANCLE_TYPE,
				ApplicationFacade.TOOL_DO_TYPE,
				ApplicationFacade.TOOL_DO_DRAW,
				ApplicationFacade.TOOL_DO_DRAG,
				ApplicationFacade.TOOL_EXPORT_IMG,
				ApplicationFacade.TOOL_DEL_SYMBOL,
				ApplicationFacade.TOOL_DO_DRAWLINE,
				ApplicationFacade.TOOL_STOP_DRAWLINE,
				ApplicationFacade.TOOL_DO_ERASER,
				ApplicationFacade.TOOL_CANCLE_ERASER];
		}

		override public function handleNotification( note : INotification ) : void {
			switch ( note.getName() ) {
            	//画布初始化
				case ApplicationFacade.DRAWPAINT_SHOW:        	
					var c : JPanel = note.getBody() as JPanel;           		
					this.drawpaint = new DrawPaint();
					this.drawpaint.setRes(this.resURL);
					this.drawpaint_outer = new DrawPaint();
					c.setOpaque(true);
					c.setPreferredWidth(550);
					c.setPreferredHeight(400);
					c.setBackground(new ASColor(0xffffff));
					c.setBorder(new LineBorder(null, ASColor.LIGHT_GRAY, 1));
					//具有拖拽可侦测属性
					c.setDropTrigger(true);
					c.setDragAcceptableInitiatorAppraiser(_dropAppraiser);
					c.addEventListener(DragAndDropEvent.DRAG_ENTER, _dragEnter);
					c.addEventListener(DragAndDropEvent.DRAG_EXIT, _dragExit);
					c.addEventListener(DragAndDropEvent.DRAG_DROP, _dragDrop);
					c.setOpaque(true);
            		
					c.addChild(drawpaint);
					freetran = new FreeTran();
					drawpaint.addChild(freetran);
					drawpaint.addEventListener(MouseEvent.MOUSE_DOWN, _paintListener);
					drawpaint.addEventListener(KeyboardEvent.KEY_DOWN, _paintkeyevent);
					break;
            		
            	//清除背景网格
				case ApplicationFacade.DRAWPAINT_GRIDSHOW:
					var box : JCheckBox = note.getBody() as JCheckBox;
					if(box.isSelected()) {
						this.drawpaint.drawBackground(20);
					} else {
						this.drawpaint.clearBackground();
					}
					break;
            		
            	//加载元素到画布
				case ApplicationFacade.DRAWSYMBOL_LOAD:
					var v : Loader = note.getBody() as Loader;
					//var myLoader:Loader=new Loader();
					//myLoader.load(new URLRequest(v.getImage()));
					//myLoader.name = v.getType() + symbolPool.length;
					var s : Sprite = new Sprite();
					//s.addChild(myLoader);
					s.addChild(v);
					//s.width = 200;
					//s.height = 200;
					symbolPool.push(s);
					//mouseChild是为了让drag事件之间作用在容器上
					s.mouseChildren = false;
					s.addEventListener(MouseEvent.MOUSE_DOWN, _mouseDown);
					s.addEventListener(KeyboardEvent.KEY_DOWN, _dokeyevent);
					drawpaint.addChild(s);
					s.x = drawpaint.mouseX - 10;
					s.y = drawpaint.mouseY - 20;
					s.scaleX = 0.8;
					s.scaleY = 0.8;
					drawpaint.swapChildren(s, freetran);
					break;
            		
				case ApplicationFacade.TOOL_CANCLE_SELECT:
					_clearSelect();
					break;
            		
				//开始画线
				case ApplicationFacade.TOOL_DO_TYPE:
					_startType();
					break;
            		
				case ApplicationFacade.TOOL_DO_SELECT:
					_doCancleType();
					sendNotification(ApplicationFacade.TOOL_CANCLE_ERASER);
					break;
					
				case ApplicationFacade.TOOL_CANCLE_TYPE:
					_doCancleType();
					break;
            		
				case ApplicationFacade.TOOL_DO_DRAW:
					var drawcontainer : Sprite = new Sprite();
					drawpaint.addChild(drawcontainer);
					drawpaint.addEventListener(MouseEvent.MOUSE_DOWN, _startDraw);
					break;
					
				case ApplicationFacade.TOOL_DO_DRAWLINE:
					var drawlinecontainer:Sprite = new Sprite();
					drawpaint.addChild(drawlinecontainer);
					drawpaint.addEventListener(MouseEvent.MOUSE_DOWN, _startDrawLine);
					break;
            		
				case ApplicationFacade.TOOL_STOP_DRAW:
					break;
					
				case ApplicationFacade.TOOL_STOP_DRAWLINE:
					_stopDrawLine();
					break;
            		
				case ApplicationFacade.TOOL_DO_DRAG:
					//drawpaint.addEventListener(MouseEvent.MOUSE_DOWN,_startDrag);
					//drawpaint.addEventListener(MouseEvent.MOUSE_UP,_stopDrag);
					break;
					
				case ApplicationFacade.TOOL_CANCLE_DRAG:
					//drawpaint.removeEventListener(MouseEvent.MOUSE_DOWN, _startDrag);
					//drawpaint.removeEventListener(MouseEvent.MOUSE_UP,_stopDrag);
					break;
            		
				case ApplicationFacade.TOOL_EXPORT_IMG:
					//trace(drawpaint.width + "," + drawpaint.height);
					freetran.pic = null;
					var jpgSource : BitmapData = new BitmapData(750, 550);
					//复制drawpaint
					drawpaint.clearBackground();
					drawpaint.drawTiledBackground();
					jpgSource.draw(drawpaint);
					var jpgEncoder : JPGEncoder = new JPGEncoder(85);
            		
					var jpgStream : ByteArray = jpgEncoder.encode(jpgSource);
            		
					var header : URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
					var jpgURLRequest : URLRequest = new URLRequest("outputURL");
					jpgURLRequest.requestHeaders.push(header);
					jpgURLRequest.method = URLRequestMethod.POST;
					jpgURLRequest.data = jpgStream;
					navigateToURL(jpgURLRequest,"_blank");
            		drawpaint.drawBackground(20);
					break;
            		
				case ApplicationFacade.TOOL_DEL_SYMBOL:
					freetran.pic = null;
					if(this.focusSymbol != null) {
						drawpaint.removeChild(this.focusSymbol);
					}
					break;
					
				//橡皮擦工具
				case ApplicationFacade.TOOL_DO_ERASER:
					//do something
					trace("eraser here?");
					CursorManager.getManager().showCustomCursor(eraserCursor,true);
					eraseArea = new Sprite();
					drawpaint.addEventListener(MouseEvent.MOUSE_DOWN, _Eraser);
					break;
				//取消橡皮擦工具	
				case ApplicationFacade.TOOL_CANCLE_ERASER:
					CursorManager.getManager().hideCustomCursor(eraserCursor);
					drawpaint.removeEventListener(MouseEvent.MOUSE_DOWN, _Eraser);
					break;
			}
		}

		//是否接受这个被拖入的组件
		private function _dropAppraiser(initiator : JLoadPane) : Boolean {
			//是否允许拖入
			return true;
		}

		//被接受的组件被拖入时,改变Panel背景色
		private function _dragEnter(e : DragAndDropEvent) : void {
			//var initiator:JLoadPane = e.getDragInitiator() as JLoadPane;
			//this.drawpaint.setBackground(new ASColor(0x0000FF, 0.2));
		}

		//组件被拖出时,恢复原来的背景色
		private function _dragExit(e : DragAndDropEvent) : void {
		}

		//组件被释放时,如果是被接受的,那么把它加入此面板
		private function _dragDrop(e : DragAndDropEvent) : void {
			trace("accept drag:)");
			var initiator : JLoadPane = e.getDragInitiator() as JLoadPane;
			if(this._dropAppraiser(initiator)) {
				var myLoader:Loader=new Loader();
				myLoader.load(new URLRequest(initiator.name));
				//myLoader.scaleX = 0.7;
				//myLoader.scaleY = 0.7;
				sendNotification(ApplicationFacade.DRAWSYMBOL_LOAD, myLoader);
			}
		}

		public function duplicateDisplayObject(target : DisplayObject, autoAdd : Boolean = false) : DisplayObject {
			// create duplicate
			var targetClass : Class = Object(target).constructor;
			var duplicate : DisplayObject = new JLoadPane();
        
			// duplicate properties
			duplicate.transform = target.transform;
			duplicate.filters = target.filters;
			duplicate.cacheAsBitmap = target.cacheAsBitmap;
			duplicate.opaqueBackground = target.opaqueBackground;
			if (target.scale9Grid) {
				var rect : Rectangle = target.scale9Grid;
				// WAS Flash 9 bug where returned scale9Grid is 20x larger than assigned
				// rect.x /= 20, rect.y /= 20, rect.width /= 20, rect.height /= 20;
				duplicate.scale9Grid = rect;
			}
        
			// add to target parent's display list
			// if autoAdd was provided as true
			if (autoAdd && target.parent) {
				target.parent.addChild(duplicate);
			}
			return duplicate;
		}	

		/*private function _startDrag(e:MouseEvent):void{
		CursorManager.showCustomCursor(selectCursor,true);
		var target:Sprite = drawpaint.getChildByName("bg") as Sprite;
		target.startDrag();
		}
        
		private function _stopDrag(e:MouseEvent):void{
		CursorManager.hideCustomCursor(selectCursor);
		var target:Sprite = drawpaint.getChildByName("bg") as Sprite;
		target.stopDrag();
		}*/

		private function _paintListener(e : MouseEvent) : void {
			trace("name is:" + e.target.name);
			if(e.target.name == "bg") {
				freetran.pic = null;
				focusSymbol = null;
				sendNotification(ApplicationFacade.TOOL_CANCLE_TYPE);      		
			}
		}

		private function _startDraw(e : MouseEvent) : void {
			this.startX = drawpaint.mouseX;
			this.startY = drawpaint.mouseY;
			drawpaint.addEventListener(MouseEvent.MOUSE_MOVE, _DrawingRect);
			drawpaint.addEventListener(MouseEvent.MOUSE_UP, _EndDrawRect); 
		}

		private function _DrawingRect(e : MouseEvent) : void {
        	
			trace("startx:" + startX + ",starty:" + startY);
			trace("mousex:" + e.target.mouseX + ",mousey:" + e.target.mouseY);
			this.draw = new Rectangle(this.startX, this.startY, e.target.mouseX - this.startX, e.target.mouseY - this.startY);
			
			drawpaint.graphics.clear();

			drawpaint.graphics.lineStyle(3, 0x0099FF, 1);  
			drawpaint.graphics.beginFill(0x0099FF, 0.1);
			trace("draw.width:" + this.draw.width + ",draw.height:" + this.draw.height);  
			drawpaint.graphics.drawRect(draw.x, draw.y, draw.width, draw.height);  
			drawpaint.graphics.endFill();   
               
			e.updateAfterEvent();  
		}

		private function _EndDrawRect(e : MouseEvent) : void {
			drawpaint.removeEventListener(MouseEvent.MOUSE_DOWN, _startDraw);  
			drawpaint.removeEventListener(MouseEvent.MOUSE_MOVE, _DrawingRect);  
			drawpaint.removeEventListener(MouseEvent.MOUSE_UP, _EndDrawRect);
			var rec : Sprite = new Sprite();
			rec.graphics.lineStyle(3, 0x000000, 1);
			rec.graphics.beginFill(0xFFFFFF,0);
			rec.graphics.drawRect(draw.x, draw.y, draw.width, draw.height);
			rec.graphics.endFill();
			rec.width = draw.width;
			rec.height = draw.height;
			drawpaint.graphics.clear();
			
			var bd:BitmapData = new BitmapData(draw.width+4, draw.height+4, true, 0x000000);
			var ma:Matrix = new Matrix();
			ma.tx = -draw.x+2;
			ma.ty = -draw.y+2;
			bd.draw(rec,ma);
			var bd_rec:InterBitmap = new InterBitmap(bd);
			drawpaint.addChild(bd_rec);		
			bd_rec.x = draw.x;
			bd_rec.y = draw.y;
			
			drawpaint.swapChildren(bd_rec, freetran);
			recPool.push(bd_rec);
			//rec.addEventListener(MouseEvent.MOUSE_DOWN, _mouseDown);
			//rec.addEventListener(KeyboardEvent.KEY_DOWN, _dokeyevent);
			sendNotification(ApplicationFacade.TOOL_STOP_DRAW);
		}
		
		private function _Eraser(e:MouseEvent):void{
			eraseArea.graphics.clear();
			eraseArea.graphics.lineStyle(8,0xff0000,1,false);
			eraseArea.graphics.moveTo(drawpaint.mouseX, drawpaint.mouseY);
			drawpaint.addEventListener(MouseEvent.MOUSE_MOVE, _DoEraser);
			drawpaint.addEventListener(MouseEvent.MOUSE_UP, _EndEraser);
		}
		
		//橡皮擦开始
		private function _DoEraser(e:MouseEvent):void{
			CursorManager.getManager().showCustomCursor(eraserCursor,true);
			trace("do eraser!");
			eraseArea.graphics.lineTo(drawpaint.mouseX, drawpaint.mouseY);
			e.updateAfterEvent();
			for(var k : int = 0;k < linePool.length;k++) {
				//var line : Sprite = linePool[k] as Sprite;
				var line : InterBitmap = linePool[k] as InterBitmap;
				var bmd:BitmapData = line.getBD();
				var ma:Matrix=new Matrix();
				ma.tx=-line.x;
				ma.ty=-line.y;
				bmd.draw(eraseArea,ma,null,BlendMode.ERASE);
			}
			for(var j:int=0;j<recPool.length;j++){
				var rec : InterBitmap = recPool[j] as InterBitmap;
				var bmd2:BitmapData = rec.getBD();
				var ma2:Matrix=new Matrix();
				ma2.tx=-rec.x;
				ma2.ty=-rec.y;
				bmd2.draw(eraseArea,ma2,null,BlendMode.ERASE);
			}
		}
		
		//橡皮擦结束
		private function _EndEraser(e:MouseEvent):void{
			trace("end eraser");
			drawpaint.removeEventListener(MouseEvent.MOUSE_MOVE, _DoEraser);
			drawpaint.removeEventListener(MouseEvent.MOUSE_UP, _EndEraser);
		}
		
		private function _startDrawLine(e:MouseEvent):void{
			//开始画线
			this.startX = drawpaint.mouseX;
			this.startY = drawpaint.mouseY;
			this.endX  = 0;
			this.endY = 0;
			drawlineStart = true;
			drawpaint.addEventListener(MouseEvent.MOUSE_MOVE, _DrawingLine);
			drawpaint.addEventListener(MouseEvent.MOUSE_UP, _EndDrawLine); 			
		}
		
		private function _stopDrawLine():void{
			this.startX = 0;
			this.startY = 0;
			this.endX = 0;
			this.endY = 0;
			drawpaint.removeEventListener(MouseEvent.MOUSE_DOWN, _startDrawLine);
			drawpaint.removeEventListener(MouseEvent.MOUSE_MOVE, _DrawingLine);
		}

		private function _EndDrawLine(e:MouseEvent):void{
			drawpaint.removeEventListener(MouseEvent.MOUSE_MOVE, _DrawingLine);
			if(this.endX != 0 && this.endY != 0) {
				var line:Sprite = new Sprite();
				line.graphics.lineStyle(4,0x000000,1,false);
				//line.graphics.moveTo(this.startX,this.startY);
				//line.graphics.lineTo(this.endX,this.endY);
				var area_width:int = Math.abs(this.endX - this.startX)>1?Math.abs(this.endX - this.startX):5;
				var area_height:int = Math.abs(this.endY - this.startY)>1?Math.abs(this.endY - this.startY):5;
				line.graphics.moveTo(this.startX+2,this.startY+2);
				line.graphics.lineTo(this.endX+2,this.endY+2);
				drawpaint.graphics.clear();
				var bd:BitmapData = new BitmapData(area_width, area_height, true, 0x000000);
				var ma:Matrix = new Matrix();
				if(this.startX < this.endX) {
					ma.tx = -this.startX;
				}else{
					ma.tx = -this.endX;
				}
				if(this.startY < this.endY) {
					ma.ty = -this.startY;
				}else{
					ma.ty = -this.endY;
				}
				bd.draw(line,ma);
				var bd_line:InterBitmap = new InterBitmap(bd);
				drawpaint.addChild(bd_line);
				if(this.startX < this.endX) {
					bd_line.x = this.startX;
				}else{
					bd_line.x = this.endX;
				}
				if(this.startY < this.endY) {
					bd_line.y = this.startY;
				}else{
					bd_line.y = this.endY;
				}
				drawpaint.swapChildren(bd_line, freetran);
				linePool.push(bd_line);
				//drawpaint.addChild(line);
				//drawpaint.swapChildren(line, freetran);
				//linePool.push(line);
				//line.addEventListener(MouseEvent.MOUSE_DOWN, _mouseDown);
				//line.addEventListener(KeyboardEvent.KEY_DOWN, _dokeyevent);
			}
		}
		
		private function _DrawingLine(e:MouseEvent):void{
			//trace(this.TransXY(e.target.mouseX, e.target.mouseY));	
			if(TransXY(drawpaint.mouseX, drawpaint.mouseY)){
				drawpaint.graphics.clear();
				drawpaint.graphics.lineStyle(4,0x000000,0.5,false);
				drawpaint.graphics.moveTo(this.startX,this.startY);
				//drawpaint.graphics.lineTo(e.target.mouseX,e.target.mouseY);
				drawpaint.graphics.lineTo(this.endX, this.endY);
			}
			e.updateAfterEvent();
		}
		
		//以15度为单位，锁定角度移动。
		private function TransXY(targetx:Number,targety:Number):Boolean{
			//var jd:Number = Math.atan2((targetx - this.startX), (targety - this.startY)) * 180 / Math.PI - 90;
			var r:Number = Math.sqrt((targetx - this.startX)*(targetx - this.startX) + (targety - this.startY)*(targety - this.startY));
			//trace("degree:"+jd);
			var arc:Number = 0;
			var targetarc:Number = 0;
			//第一象限
			if(targety < this.startY && targetx > this.startX){
				arc = Math.asin((this.startY - targety)/r)  * 180 / Math.PI;
				targetarc = Math.round(arc/15) * 15 * Math.PI / 180;
				this.endX = this.startX + Math.abs(r * Math.cos(targetarc));
				this.endY = this.startY - Math.abs(r * Math.sin(targetarc));
			}
			//90C
			if(targety < this.startY && targetx == this.startX){
				arc = 90;
				targetarc = Math.round(arc/15) * 15 * Math.PI / 180;
				this.endX = this.startX;
				this.endY = this.startY - r;
				trace("90c");
			}
			//第二象限
			if(targety < this.startY && targetx < this.startX){
				arc = 180 - Math.asin((this.startY - targety)/r)  * 180 / Math.PI;
				targetarc = Math.round(arc/15) * 15 * Math.PI / 180;
				this.endX = this.startX - Math.abs(r * Math.cos(targetarc));
				this.endY = this.startY - Math.abs(r * Math.sin(targetarc));
				trace("in two");
			}
			//180c
			if(targety == this.startY && targetx < this.startX){
				arc = 180;
				targetarc = Math.round(arc/15) * 15 * Math.PI / 180;
				this.endX = this.startX - r;
				this.endY = this.startY;
				trace("180c");
			}
			//第三象限
			if(targety > this.startY && targetx < this.startX){
				arc = 180 + Math.asin((targety - this.startY)/r)  * 180 / Math.PI;
				targetarc = Math.round(arc/15) * 15 * Math.PI / 180;
				this.endX = this.startX - Math.abs(r * Math.cos(targetarc));
				this.endY = this.startY + Math.abs(r * Math.sin(targetarc));
				trace("in three");
			}			
			//270c
			if(targety > this.startY && targetx == this.startX){
				arc = 270;
				targetarc = Math.round(arc/15) * 15;
				this.endX = this.startX;
				this.endY = this.startY + r;
				trace("270c");
			}
			//第四象限
			if(targety > this.startY && targetx > this.startX){
				arc = 360 - Math.asin((targety - this.startY)/r)  * 180 / Math.PI;
				targetarc = Math.round(arc/15) * 15 * Math.PI / 180;
				this.endX = this.startX + Math.abs(r * Math.cos(targetarc));
				this.endY = this.startY + Math.abs(r * Math.sin(targetarc));
				trace("in four");
			}
			//0度
			if(targety == this.startY && targetx >= this.startX){
				arc = 0;
				this.endX = this.startX + r;
				this.endY = this.startY;
				trace("0c");
			}
			return true;
		}
		
		private function _mouseDownBmp(e : MouseEvent) : void {
			var target : InterBitmap = e.target as InterBitmap;
			trace("i was click!");
			sendNotification(ApplicationFacade.TOOL_STOP_DRAWLINE);
			//trace(key + ":"+symbolPool[key]);
			if(target != null) {
				//替换光标
				//CursorManager.showCustomCursor(selectCursor,true);
				//stage.focus = target;
				this.focusSymbol = target;
				sendNotification(ApplicationFacade.TOOL_DO_SELECT);
				//drawpaint.swapChildren(freetran,target);
				freetran.dragPic(target);
			}
		}

		private function _mouseDown(e : MouseEvent) : void {
			var target : Sprite = e.target as Sprite;
			sendNotification(ApplicationFacade.TOOL_STOP_DRAWLINE);
			//trace(key + ":"+symbolPool[key]);
			if(target != null) {
				//替换光标
				//CursorManager.showCustomCursor(selectCursor,true);
				stage.focus = target;
				this.focusSymbol = target;
				sendNotification(ApplicationFacade.TOOL_DO_SELECT);
				//drawpaint.swapChildren(freetran,target);
				freetran.dragPic(target);
			}
		}

		private function _dokeyevent(e : KeyboardEvent) : void {
			var target : Sprite = e.target as Sprite;
			if(e.keyCode == Keyboard.DELETE) {
				/*var jop:JOptionPane = JOptionPane.showMessageDialog("提示","确认删除?",
				function(result:int):void{
				if(result == JOptionPane.YES){
				freetran.pic = null;
				drawpaint.removeChild(target);
				}
				},
				null,false,null,JOptionPane.YES|JOptionPane.NO);*/

				freetran.pic = null;
				drawpaint.removeChild(target);
        		//trace(target);
			}
		}
		
		private function _paintkeyevent(e : KeyboardEvent):void{
			if(this.focusSymbol != null){
				if(e.keyCode == Keyboard.LEFT){
					freetran.x --;
					this.focusSymbol.x --;
				}
				if(e.keyCode == Keyboard.RIGHT){
					freetran.x ++;
					this.focusSymbol.x ++;
				}
				if(e.keyCode == Keyboard.UP){
					freetran.y --;
					this.focusSymbol.y --;
				}
				if(e.keyCode == Keyboard.DOWN) {
					freetran.y ++;
					this.focusSymbol.y ++;
				}
			}
		}

		private function _txtmouseDown(e : MouseEvent) : void {
			var target : Sprite = e.target as Sprite;
			sendNotification(ApplicationFacade.TOOL_STOP_DRAWLINE);
			stage.focus = target;
			this.focusSymbol = target;
			sendNotification(ApplicationFacade.TOOL_DO_SELECT);
			drawpaint.swapChildren(target, freetran);
			freetran.dragPic(target);
		}
		
		private function _startType():void{
			CursorManager.getManager().showCustomCursor(typeCursor,true);
			drawpaint.addEventListener(MouseEvent.MOUSE_DOWN, _doType);
		}

		private function _doType(e:MouseEvent) : void {
			txtframe = new JFrame(null, "输入文本");
			pane = new CreateTextPane();
			txtframe.setContentPane(pane);
			txtframe.pack();
			txtframe.x = stage.stageWidth/2 - 200;
			txtframe.y = stage.stageHeight/2 - 100;
			this.fontX = drawpaint.mouseX;
			this.fontY = drawpaint.mouseY;
			txtframe.setResizable(false);
			txtframe.setClosable(false);
			txtframe.show();
			pane.getOkButton().addActionListener(_textok);
			pane.getCancelButton().addActionListener(_textCancel);
			drawpaint.removeEventListener(MouseEvent.MOUSE_DOWN, _doType);
			CursorManager.getManager().hideCustomCursor(typeCursor);
		}
		
		private function _textok(e:Event):void{
			var txt:String = pane.getInputText().getText();
			if(txt != "" && txt != null){
				var tc:Sprite = new Sprite();
				var label:TextField = new TextField();
				label.width = 100;
				label.height = 25;	
				label.text = txt;
				format.font = "Verdana";
            	format.size = 16;
            	label.x = this.fontX;
				label.y = this.fontY;
            	label.setTextFormat(format);
            	tc.addChild(label);
            	txtPool.push(tc);
            	tc.mouseChildren = false;
				//tc.addEventListener(MouseEvent.MOUSE_DOWN, _txtmouseDown);
				//tc.addEventListener(KeyboardEvent.KEY_DOWN, _dokeyevent);
				drawpaint.addChild(tc);
				drawpaint.swapChildren(tc,freetran);
			}
			sendNotification(ApplicationFacade.TOOL_CANCLE_TYPE);
			txtframe.hide();
		}
		
		private function _textCancel(e:Event):void{
			sendNotification(ApplicationFacade.TOOL_CANCLE_TYPE);
			txtframe.hide();
		}

		private function _doCancleType() : void {
			for(var i : int = 0;i < txtPool.length;i++) {
				var tc : Sprite = txtPool[i] as Sprite;
				tc.mouseChildren = false;
				tc.addEventListener(MouseEvent.MOUSE_DOWN, _txtmouseDown);
				tc.addEventListener(KeyboardEvent.KEY_DOWN, _dokeyevent);
			}
			for(var j : int = 0;j < symbolPool.length;j++) {
				var tc2 : Sprite = symbolPool[j] as Sprite;
				tc2.addEventListener(MouseEvent.MOUSE_DOWN, _mouseDown);
				tc2.addEventListener(KeyboardEvent.KEY_DOWN, _dokeyevent);
			}
			for(var k : int = 0;k < linePool.length;k++) {
				//var line : Sprite = linePool[k] as Sprite;
				var line : InterBitmap = linePool[k] as InterBitmap;
				line.addEventListener(MouseEvent.MOUSE_DOWN, _mouseDownBmp);
				line.addEventListener(KeyboardEvent.KEY_DOWN, _dokeyevent);
			}
			for(var l : int = 0;l < recPool.length;l++) {
				var rec : Sprite = recPool[l] as Sprite;
				rec.addEventListener(MouseEvent.MOUSE_DOWN, _mouseDown);
				rec.addEventListener(KeyboardEvent.KEY_DOWN, _dokeyevent);
			}
			CursorManager.getManager().hideCustomCursor(typeCursor);
			drawpaint.removeEventListener(MouseEvent.MOUSE_DOWN, _doType);
		}

		private function _clearSelect() : void {
			freetran.pic = null;
			for(var i : int = 0;i < txtPool.length;i++) {
				var t : Sprite = txtPool[i] as Sprite;
				t.mouseChildren = true;
				t.removeEventListener(MouseEvent.MOUSE_DOWN, _txtmouseDown);
				t.removeEventListener(KeyboardEvent.KEY_DOWN, _dokeyevent);
			}
			for(var j : int = 0;j < symbolPool.length;j++) {
				var t2 : Sprite = symbolPool[j] as Sprite;
				t2.removeEventListener(MouseEvent.MOUSE_DOWN, _mouseDown);
				t2.removeEventListener(KeyboardEvent.KEY_DOWN, _dokeyevent);
			}
			for(var k : int = 0;k < linePool.length;k++) {
				var line : InterBitmap = linePool[k] as InterBitmap;
				line.removeEventListener(MouseEvent.MOUSE_DOWN, _mouseDownBmp);
				line.removeEventListener(KeyboardEvent.KEY_DOWN, _dokeyevent);
			}
			for(var l : int = 0;l < recPool.length;l++) {
				var rec : Sprite = recPool[l] as Sprite;
				rec.removeEventListener(MouseEvent.MOUSE_DOWN, _mouseDown);
				rec.removeEventListener(KeyboardEvent.KEY_DOWN, _dokeyevent);
			}
		}
		

		protected function get stage() : Stage {
			return viewComponent as Stage;
		}
	}
}
