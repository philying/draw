package com.anjuke {
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;

	import com.anjuke.controller.StartupCommand;

	/**
	 * @author phil
	 */
	public class ApplicationFacade extends Facade{
		
		// Notification name constants
		// application
        public static const STARTUP:String 					= "startup";
        public static const SHUTDOWN:String 				= "shutdown";
        public static const STAGE_ADD_SPRITE:String	= "stageAddSprite";
        public static const SPRITE_SCALE:String 	= "spriteScale";
		public static const SPRITE_DROP:String		= "spriteDrop";
		
		//drawtool
		public static const DRAWINIT:String = "drawInit";
		public static const DRAWTOOL_SHOW:String = "drawtoolShow";
		public static const DRAWPAINT_SHOW:String = "drawpaintShow";
		public static const DRAWSYMBOL_SHOW:String = "drawsymbolShow";
		public static const DRAWSYMBOL_LOAD:String = "drawsymbolLoad";
		
		public static const TOOL_DO_SELECT:String = "doselect";
		public static const TOOL_CANCLE_SELECT:String = "cancleeselect";
		public static const TOOL_DO_TYPE:String = "dotype";
		public static const TOOL_CANCLE_TYPE:String = "cancletype";
		public static const TOOL_DO_RULE:String = "dorule";
		public static const TOOL_CANCLE_RULE:String = "canclerule";
		public static const TOOL_DO_DRAW:String = "dodraw";
		public static const TOOL_DO_DRAWLINE:String = "dodrawline";
		public static const TOOL_STOP_DRAW:String = "stopdraw";
		public static const TOOL_STOP_DRAWLINE:String = "stopdrawline";
		public static const TOOL_DO_DRAG:String = "startdrag";
		public static const TOOL_CANCLE_DRAG:String = "cancledrag";
		
		public static const TOOL_EXPORT_IMG:String = "exportimg";
		
		public static const TOOL_DEL_SYMBOL:String = "delsymbol";
		
		public static const TOOL_ERASER:String = "eraser";
		public static const TOOL_DO_ERASER:String = "doeraser";
		public static const TOOL_CANCLE_ERASER:String = "stoperaser";
		
		public static const DRAWPAINT_GRIDSHOW:String = "drawtoolGridshow";
        
        /**
         * Singleton ApplicationFacade Factory Method
         */
        public static function getInstance():ApplicationFacade 
		{
            if ( instance == null ) instance = new ApplicationFacade();
            return instance as ApplicationFacade;
        }
        
        /**
         * Register Commands with the Controller 
         */
        override protected function initializeController():void 
        {
            super.initializeController(); 
            registerCommand( STARTUP, StartupCommand );
        }
        
        /**
		 * Start the application
		 */
		public function startup(stage:Object):void
		{
			sendNotification( STARTUP, stage );
		}    
        
		
	}
}
