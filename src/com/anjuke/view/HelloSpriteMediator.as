package com.anjuke.view {
	
	import flash.events.Event;
	import flash.geom.Rectangle;
	
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.Mediator;
    
    import com.anjuke.ApplicationFacade;
	import com.anjuke.model.SpriteDataProxy;
	import com.anjuke.view.component.HelloSprite;

	/**
	 * @author phil
	 */
	public class HelloSpriteMediator extends Mediator implements IMediator{
			   /**
         * Constructor. 
         */
        public function HelloSpriteMediator( viewComponent:Object ) 
        {
            // pass the viewComponent to the superclass where 
            // it will be stored in the inherited viewComponent property
            //
            // *** Note that the name of the mediator is the same as the
            // *** id of the HelloSprite it stewards. It does not use a
            // *** fixed 'NAME' constant as most single-use mediators do
            super( HelloSprite(viewComponent).id, viewComponent );
    
			// Retrieve reference to frequently consulted Proxies
			spriteDataProxy = facade.retrieveProxy( SpriteDataProxy.NAME ) as SpriteDataProxy;

			// Listen for events from the view component 
            helloSprite.addEventListener( HelloSprite.SPRITE_DIVIDE, onSpriteDivide );
            
        }

        /**
         * List all notifications this Mediator is interested in.
         * <P>
         * Automatically called by the framework when the mediator
         * is registered with the view.</P>
         * 
         * @return Array the list of Nofitication names
         */
        override public function listNotificationInterests():Array 
        {
            return [ 
            		 ApplicationFacade.SPRITE_SCALE,
					 ApplicationFacade.SPRITE_DROP
                   ];
        }

        /**
         * Handle all notifications this Mediator is interested in.
         * <P>
         * Called by the framework when a notification is sent that
         * this mediator expressed an interest in when registered
         * (see <code>listNotificationInterests</code>.</P>
         * 
         * @param INotification a notification 
         */
        override public function handleNotification( note:INotification ):void 
        {
            switch ( note.getName() ) {
                
                case ApplicationFacade.SPRITE_DROP:
					helloSprite.dropSprite();
                    break;

				case ApplicationFacade.SPRITE_SCALE:
					var delta:Number = note.getBody() as Number;
					helloSprite.scaleSprite(delta);
                    break;
            }
        }
		
		/**
		 * Sprite divide.
		 * <P>
		 * User is dragging the sprite, send a notification to create a new sprite
		 * and pass the state the new sprite should inherit.
		 */
		private function onSpriteDivide(event:Event):void
		{
			helloSprite.color=spriteDataProxy.nextSpriteColor( helloSprite.color );
			sendNotification( ApplicationFacade.STAGE_ADD_SPRITE, helloSprite.newSpriteState );
			
		}

        /**
         * Cast the viewComponent to its actual type.
         * 
         * <P>
         * This is a useful idiom for mediators. The
         * PureMVC Mediator class defines a viewComponent
         * property of type Object. </P>
         * 
         * <P>
         * Here, we cast the generic viewComponent to 
         * its actual type in a protected mode. This 
         * retains encapsulation, while allowing the instance
         * (and subclassed instance) access to a 
         * strongly typed reference with a meaningful
         * name.</P>
         * 
         * @return stage the viewComponent cast to HelloSprite
         */
        protected function get helloSprite():HelloSprite
        {
            return viewComponent as HelloSprite;
        }

		private var spriteDataProxy:SpriteDataProxy;
	}
}
