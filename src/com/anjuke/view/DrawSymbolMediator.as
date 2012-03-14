package com.anjuke.view {
	
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.LoaderInfo;

	import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.Mediator;
    
	import org.aswing.JTabbedPane;
	import org.aswing.JPanel;
	import org.aswing.BorderLayout;
	import org.aswing.Component;
	import org.aswing.VectorListModel;
	import org.aswing.JList;
	import org.aswing.border.LineBorder;
	import org.aswing.JScrollPane;
	import org.aswing.ASColor;
	import org.aswing.GeneralListCellFactory;
	import org.aswing.JButton;
	import org.aswing.FlowLayout;
	
	import org.aswing.event.ListItemEvent;
    
    import com.anjuke.ApplicationFacade;
    import com.anjuke.view.component.*;

	/**
	 * @author phil
	 */
	public class DrawSymbolMediator extends Mediator implements IMediator{
		// Cannonical name of the Mediator
        public static const NAME:String = 'DrawSymbolMediator'; 
        
        private var resURL:String;
        
        public function DrawSymbolMediator(viewComponent:Object) {
			super( NAME, viewComponent );
			resURL = LoaderInfo(stage.loaderInfo).parameters["resURL"];
			if(resURL == null){
				resURL = "";
			}
		}
		
		override public function listNotificationInterests():Array 
        {
            return [ 
				ApplicationFacade.DRAWSYMBOL_SHOW
            		];
        }
        
        override public function handleNotification( note:INotification ):void 
        {
            switch ( note.getName() ) {
            	case ApplicationFacade.DRAWSYMBOL_SHOW:
            		var east:JTabbedPane = note.getBody() as JTabbedPane;
					
					var f:JPanel = new Funiture();
					var list:Component = createFunitureList();
					f.append(list,BorderLayout.CENTER);
					//f.setPreferredHeight(100);
					var list2:Component = createStructureList();
					f.append(list,BorderLayout.CENTER);
					var s:JPanel = new Structure();
					s.append(list2,BorderLayout.CENTER);
					east.appendTab(s,"常用工具");
					east.appendTab(f,"更多");
					
            		break;
            }
        }
        
        
        private function createFunitureList():Component{
	        var fdata:Array = [
	        ["res/funiture/bed01.swf","双人床"],
	        ["res/funiture/bed02.swf","双人床"],
	        ["res/funiture/bed03.swf","双人床"],
	        ["res/funiture/chair01.swf","单人沙发"],
	        ["res/funiture/chair02.swf","太师椅"],
	        ["res/funiture/chair03.swf","方形沙发"],
	        ["res/funiture/desk01.swf","桌子"],
	        ["res/funiture/desk02.swf","床头柜"],
	        ["res/funiture/plant01.swf","植物"],
	        ["res/funiture/canzhuo.swf","餐桌"],
	        ["res/funiture/desk.swf","桌子"],
	        ["res/funiture/flower.swf","花"],
	        ["res/funiture/lanpen.swf","脸盆"],
	        ["res/funiture/mt.swf","马桶"],
	        ["res/funiture/shuidou.swf","水盆"],
	        ["res/funiture/yugang.swf","浴缸"]
	        ];
	        var listData:VectorListModel = new VectorListModel();
	        for(var i:int=0; i<fdata.length; i++){
				listData.append(new SymbolSprit(resURL+fdata[i][0],fdata[i][1],"f"));
	        }
	        
	        var list:JList = new JList(listData, new GeneralListCellFactory(IconListCell, false, true,100));
	        list.addEventListener(ListItemEvent.ITEM_CLICK, _listFunitureItemSelect);
	        list.setBorder(new LineBorder(null, ASColor.GRAY, 1));
			return new JScrollPane(list);
		}
		
		private function _listFunitureItemSelect(e:ListItemEvent):void{
			var value:SymbolSprit = e.getValue() as SymbolSprit;
			//sendNotification(ApplicationFacade.DRAWSYMBOL_LOAD, value);
		}
		
		private function createStructureList():Component{
	        var fdata:Array = [
	        ["res/structure/left_swing_door_90.swf","门"],
	        ["res/structure/right_swing_door_90.swf","门"],
	      	["res/structure/window1.swf","窗"],
	      	["res/structure/window2.swf","窗"],
	        ["res/structure/s1.swf","指南箭头"],
	        ["res/structure/s2.swf","指南箭头"],
	        ["res/structure/s3.swf","指南箭头"],
	        ["res/structure/s4.swf","指南箭头"]
	        ];
	        var listData:VectorListModel = new VectorListModel();
	        for(var i:int=0; i<fdata.length; i++){
				listData.append(new SymbolSprit(resURL+fdata[i][0],fdata[i][1],"f"));
	        }
	        
	        var list:JList = new JList(listData, new GeneralListCellFactory(IconListCell, false, true,100));
	        list.addEventListener(ListItemEvent.ITEM_CLICK, _listFunitureItemSelect);
	        list.setBorder(new LineBorder(null, ASColor.GRAY, 1));
			return new JScrollPane(list);
		}
		
		private function _listStructureItemSelect(e:ListItemEvent):void{
			var value:SymbolSprit = e.getValue() as SymbolSprit;
			//sendNotification(ApplicationFacade.DRAWSYMBOL_LOAD, value);
		}
		
		protected function get stage():Stage{
            return viewComponent as Stage;
        }
        
	}
}
