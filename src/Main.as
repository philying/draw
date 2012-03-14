package {
	
	import flash.display.Sprite;

	import com.anjuke.ApplicationFacade;
	
	import org.aswing.AsWingManager;
	import org.aswing.UIManager;
	import aeon.*;


	/**
	 * @author phil
	 */
	public class Main extends Sprite {
		public function Main():void {
			//AsWingManager.initAsStandard(this);
			UIManager.setLookAndFeel(new AeonLAF());
			//init();
		}
		
		public function init():void{
			AsWingManager.initAsStandard(this);
			UIManager.setLookAndFeel(new AeonLAF());
			ApplicationFacade.getInstance().startup(this.stage);
		}
	}
}
