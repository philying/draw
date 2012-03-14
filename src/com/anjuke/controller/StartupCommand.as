package com.anjuke.controller {
	
	import flash.display.Stage;

	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	import com.anjuke.ApplicationFacade;
	import com.anjuke.model.SpriteDataProxy;
	import com.anjuke.view.StageMediator;
	import com.anjuke.view.DrawPaintMediator;
	import com.anjuke.view.DrawToolMediator;
	import com.anjuke.view.DrawSymbolMediator;

	/**
	 * @author phil
	 */
	public class StartupCommand extends SimpleCommand implements ICommand{
		
		/**
         * Register the Proxies and Mediators.
         * 
         * Get the View Components for the Mediators from the app,
         * which passed a reference to itself on the notification.
         */
        override public function execute( note:INotification ) : void    
        {
			facade.registerProxy(new SpriteDataProxy());
	    	var stage:Stage = note.getBody() as Stage;
	    	
	    	facade.registerMediator(new DrawToolMediator(stage));
            facade.registerMediator( new StageMediator( stage ) );          
            facade.registerMediator(new DrawPaintMediator(stage));
            facade.registerMediator(new DrawSymbolMediator(stage));
            
			//sendNotification( ApplicationFacade.STAGE_ADD_SPRITE );
			sendNotification( ApplicationFacade.DRAWINIT);
		}
        
	}
}
