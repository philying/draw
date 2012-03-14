package com.anjuke.view.component {
	
	import flash.display.Sprite;

	import org.aswing.JPanel;
	import org.aswing.JButton;
	import org.aswing.FlowLayout;
	
	import flash.system.Capabilities;

	/**
	 * @author phil
	 */
	public class DrawTool extends Sprite{
		

		private var sp:Sprite;
		private var w:int =flash.system.Capabilities.screenResolutionX;
        private var h:int =flash.system.Capabilities.screenResolutionY;
		
		private var pane:JPanel;
		 
		
		public function DrawTool(){
			
			super();
			this.pane = new JPanel(new FlowLayout());
        	for(var i:int=0; i<5; i++) {
            	pane.append(new JButton("Btn"+i));
        	}

			
		}
		
		public function getPane():JPanel{
			return this.pane;
		}
		
		
	}
}
