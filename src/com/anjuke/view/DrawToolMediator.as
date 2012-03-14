package com.anjuke.view {
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;

	import flash.events.MouseEvent;
	import flash.display.LoaderInfo;
	import flash.display.Stage;
	import flash.net.*;

	import org.aswing.JPanel;
	import org.aswing.JButton;
	import org.aswing.FlowLayout;
	import org.aswing.BorderLayout;
	import org.aswing.LoadIcon;
	import org.aswing.JToggleButton;
	import org.aswing.JCheckBox;
	import org.aswing.event.InteractiveEvent;
	import org.aswing.event.AWEvent;

	import com.anjuke.ApplicationFacade;

	/**
	 * @author phil
	 */
	public class DrawToolMediator extends Mediator implements IMediator {

		// Cannonical name of the Mediator
		public static const NAME : String = 'DrawToolMediator';

		private var resURL : String;

		public var btn_select : JToggleButton;
		public var btn_drag : JToggleButton;
		public var btn_modify : JToggleButton;
		public var btn_line : JToggleButton;
		public var btn_type : JToggleButton;
		public var btn_rule : JToggleButton;
		public var btn_export : JButton;
		public var btn_del : JButton;
		public var btn_eraser:JToggleButton;

		public var btn_help : JButton;

		public function DrawToolMediator(viewComponent : Object) {
			super(NAME, viewComponent);
			resURL = LoaderInfo(stage.loaderInfo).parameters["resURL"];
			if(resURL == null) {
				resURL = "";
			}
		}

		override public function listNotificationInterests() : Array {
			return [ApplicationFacade.STAGE_ADD_SPRITE,
            		ApplicationFacade.DRAWTOOL_SHOW,
            		ApplicationFacade.TOOL_DO_SELECT,
            		ApplicationFacade.TOOL_STOP_DRAW,
            		ApplicationFacade.TOOL_CANCLE_TYPE,
            		ApplicationFacade.TOOL_STOP_DRAWLINE
            		];
		}

		override public function handleNotification( note : INotification ) : void {
			switch ( note.getName() ) {
				case ApplicationFacade.DRAWTOOL_SHOW:
					//var drawtool:DrawTool = new DrawTool();
					var top : JPanel = note.getBody() as JPanel;
            		
					btn_select = new JToggleButton("选择工具", new LoadIcon(resURL + "res/icon/selectTool.swf", 30, 30));
					btn_select.setToolTipText("选择");
					btn_select.addEventListener(AWEvent.ACT, _doSelect);
            		
					btn_drag = new JToggleButton("移动", new LoadIcon(resURL + "res/icon/dragTool.swf", 30, 30));
					btn_drag.setToolTipText("移动");
					btn_drag.addEventListener(AWEvent.ACT, _doDrag);
					btn_drag.visible = false;
            		
					btn_modify = new JToggleButton("矩形工具", new LoadIcon(resURL + "res/icon/draw-rectangle.png", 30, 30));
					btn_modify.setToolTipText("矩形工具");
					btn_modify.addEventListener(AWEvent.ACT, _doDraw);
					
					btn_line = new JToggleButton("画线", new LoadIcon(resURL + "res/icon/wallTool.swf", 30, 30));
					btn_line.setToolTipText("画线");
					btn_line.addEventListener(AWEvent.ACT, _doDrawLine);
            		
					btn_type = new JToggleButton("输入文字", new LoadIcon(resURL + "res/icon/textTool.swf", 30, 30));
					btn_type.setToolTipText("输入文字");
					btn_type.addEventListener(AWEvent.ACT, _doType);
            		
					//btn_rule = new JToggleButton(null, new LoadIcon("res/icon/dimensionTool.swf",30,30));
					//btn_rule.setToolTipText("标尺工具");

					btn_export = new JButton("导出图片", new LoadIcon(resURL + "res/icon/cameraTool.swf", 30, 30));
					btn_export.setToolTipText("导出图片");
					btn_export.addEventListener(MouseEvent.CLICK, _exportjpg);
            		
					btn_del = new JButton("删除", new LoadIcon(resURL + "res/icon/del.png", 30, 30));
					btn_del.setToolTipText("从面板删除");
					btn_del.addEventListener(MouseEvent.CLICK, _doDel);
					
					btn_help = new JButton("新手教程", new LoadIcon(resURL + "res/icon/help.png", 24, 24));
					btn_help.useHandCursor = true;
					btn_help.setToolTipText("教程");
					btn_help.addEventListener(MouseEvent.CLICK, _helpwindow);
					
					btn_eraser = new JToggleButton("橡皮擦",new LoadIcon(resURL + "res/icon/eraser.png",30,30));
					btn_eraser.setToolTipText("橡皮擦");
					btn_eraser.addEventListener(AWEvent.ACT, _doEraser);
            		
					var check : JCheckBox = new JCheckBox("显示网格");
					check.setSelected(true);
            		
					check.addEventListener(InteractiveEvent.STATE_CHANGED, _changeGridShow);
					
					var toolPanel : JPanel = new JPanel();
					toolPanel.setLayout(new FlowLayout())
            		
					top.setLayout(new BorderLayout());
            		
					toolPanel.append(btn_select);
					toolPanel.append(btn_drag);
					toolPanel.append(btn_modify);
					toolPanel.append(btn_line);
					toolPanel.append(btn_type);
					//top.append(btn_rule);
					toolPanel.append(btn_export);
					toolPanel.append(btn_del);	
					toolPanel.append(btn_eraser);				
					toolPanel.append(check);
					
					top.append(toolPanel, BorderLayout.WEST);
					
					top.append(btn_help, BorderLayout.EAST);

					break;
            		
				case ApplicationFacade.TOOL_DO_SELECT:
					_clearChoose();
					btn_select.setSelected(true);
					break;
            		
				case ApplicationFacade.TOOL_STOP_DRAW:
					btn_modify.setSelected(false);
					break;
					
				case ApplicationFacade.TOOL_CANCLE_TYPE:
					btn_type.setSelected(false);
					break;
					
				case ApplicationFacade.TOOL_STOP_DRAWLINE:
					btn_line.setSelected(false);
					break;
					
			}
		}

		private function _changeGridShow(e : InteractiveEvent) : void {
			sendNotification(ApplicationFacade.DRAWPAINT_GRIDSHOW, e.target as JCheckBox);
		}
		
		private function _doEraser(e:AWEvent):void{
			if(btn_eraser.isSelected()){
				btn_drag.setSelected(false);
				btn_modify.setSelected(false);
				btn_type.setSelected(false);
				btn_drag.setSelected(false);
				btn_line.setSelected(false);
				btn_select.setSelected(false);
				sendNotification(ApplicationFacade.TOOL_DO_ERASER);
				sendNotification(ApplicationFacade.TOOL_CANCLE_SELECT);
				sendNotification(ApplicationFacade.TOOL_CANCLE_TYPE);
				sendNotification(ApplicationFacade.TOOL_STOP_DRAW);
				sendNotification(ApplicationFacade.TOOL_STOP_DRAWLINE);
			}else{
				sendNotification(ApplicationFacade.TOOL_CANCLE_ERASER);
			}
		}

		private function _doSelect(e : AWEvent) : void {
			if(btn_select.isSelected()) {
				btn_drag.setSelected(false);
				btn_modify.setSelected(false);
				btn_type.setSelected(false);
				btn_drag.setSelected(false);
				btn_line.setSelected(false);
				sendNotification(ApplicationFacade.TOOL_DO_SELECT);
				sendNotification(ApplicationFacade.TOOL_CANCLE_TYPE);
				sendNotification(ApplicationFacade.TOOL_STOP_DRAW);
				sendNotification(ApplicationFacade.TOOL_STOP_DRAWLINE);
				sendNotification(ApplicationFacade.TOOL_CANCLE_ERASER);
			} else {
				sendNotification(ApplicationFacade.TOOL_CANCLE_SELECT);
			}
		}

		private function _doType(e : AWEvent) : void {
			trace("btn_type:"+btn_type.isSelected());
			if(btn_type.isSelected()) {
				btn_select.setSelected(false);
				btn_drag.setSelected(false);
				btn_modify.setSelected(false);
				btn_line.setSelected(false);
				sendNotification(ApplicationFacade.TOOL_DO_TYPE);
				sendNotification(ApplicationFacade.TOOL_CANCLE_SELECT);
				//sendNotification(ApplicationFacade.TOOL_STOP_DRAW);
				sendNotification(ApplicationFacade.TOOL_STOP_DRAWLINE);
				sendNotification(ApplicationFacade.TOOL_CANCLE_ERASER);
			} else {
				sendNotification(ApplicationFacade.TOOL_CANCLE_TYPE);
			}
		}

		private function _doDraw(e : AWEvent) : void {
			if(btn_modify.isSelected()) {
				btn_select.setSelected(false);
				btn_drag.setSelected(false);
				sendNotification(ApplicationFacade.TOOL_DO_DRAW);
				sendNotification(ApplicationFacade.TOOL_CANCLE_TYPE);
				sendNotification(ApplicationFacade.TOOL_CANCLE_SELECT);
				sendNotification(ApplicationFacade.TOOL_STOP_DRAWLINE);
				sendNotification(ApplicationFacade.TOOL_CANCLE_ERASER);
			} else {
				sendNotification(ApplicationFacade.TOOL_STOP_DRAW);
			}
		}

		private function _doDrawLine(e : AWEvent) : void {
			if(btn_line.isSelected()) {
				btn_select.setSelected(false);
				btn_drag.setSelected(false);
				sendNotification(ApplicationFacade.TOOL_CANCLE_TYPE);
				sendNotification(ApplicationFacade.TOOL_CANCLE_SELECT);
				sendNotification(ApplicationFacade.TOOL_DO_DRAWLINE);
				sendNotification(ApplicationFacade.TOOL_CANCLE_ERASER);
			} else {
				sendNotification(ApplicationFacade.TOOL_STOP_DRAWLINE);
			}
		}

		private function _doDrag(e : AWEvent) : void {
			if(btn_drag.isSelected()) {
				sendNotification(ApplicationFacade.TOOL_DO_DRAG);
			} else {
				sendNotification(ApplicationFacade.TOOL_CANCLE_DRAG);
			}
		}

		private function _clearChoose() : void {
			btn_select.setSelected(false);
			btn_drag.setSelected(false);
			btn_modify.setSelected(false);
			btn_type.setSelected(false);
			btn_eraser.setSelected(false);
			//btn_rule.setSelected(false);
		}

		private function _exportjpg(e : MouseEvent) : void {
			sendNotification(ApplicationFacade.TOOL_EXPORT_IMG);
		}

		private function _doDel(e : MouseEvent) : void {
			sendNotification(ApplicationFacade.TOOL_DEL_SYMBOL);
		}

		private function _helpwindow(e : MouseEvent) : void {
			var req : URLRequest = new URLRequest("http://forum.anjuke.com/thread-125032-1-1.html");
			navigateToURL(req, "_blank");
		}

		protected function get stage() : Stage {
			return viewComponent as Stage;
		}
	}
}