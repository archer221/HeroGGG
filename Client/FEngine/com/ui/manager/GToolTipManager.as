package com.ui.manager {
	import com.ui.core.UIComponent;
	import flash.events.MouseEvent;
	import flash.geom.Point;


	/**
	 * Game ToolTip Manager
	 * 
	 * @author Cafe
	 * @version 20100708
	 */
	public class GToolTipManager {

		private static function toolTip_rollOverHandler(event : MouseEvent) : void {
			var target : UIComponent = UIComponent(event.target);
			target.initToolTip();
			if(target.toolTip != null && target.toolTip.text.length > 0) {
				var offset : Point = target.localToGlobal(new Point(target.width, target.height));
				if(target.toolTip.data.alginMode == 0) {
					if(offset.x + target.toolTip.width > UIManager.root.stage.stageWidth) {
						offset.x = UIManager.root.stage.stageWidth - target.toolTip.width;//target.width + target.toolTip.width;
					}
					if (offset.y + target.toolTip.height > UIManager.root.stage.stageHeight) {
						offset.y = UIManager.root.stage.stageHeight - target.toolTip.height;
					}
					target.toolTip.moveTo(offset.x, offset.y);
				}else if(target.toolTip.data.alginMode == 1) {
					if(offset.x + target.toolTip.width > UIManager.root.stage.width) {
						offset.x -= target.width + target.toolTip.width;
					}
					offset.y -= target.height + target.toolTip.height;
					target.toolTip.moveTo(offset.x, offset.y);
				}else if (target.toolTip.data.alginMode == 2) {
					//offset.x = target.width * 0.5;
					//offset.y -= target.height * 0.5;
					offset.x -= target.width;
					offset.y -= target.toolTip.height + target.height;
					if(offset.x + target.toolTip.width > UIManager.root.stage.width) {
						offset.x -= target.width + target.toolTip.width;
					}
					target.toolTip.moveTo(offset.x, offset.y);
				}
				else if ( target.toolTip.data.alginMode == 3 ) {
					offset.x = event.stageX;
					offset.y = event.stageY;
					if(offset.x + target.toolTip.width + 32 > UIManager.root.stage.width) {
						offset.x -= target.width + target.toolTip.width - 50;
					}
					else if ( offset.y + target.toolTip.height + 32 > UIManager.root.stage.height )
					{
						offset.y -= target.height + target.toolTip.height - 50;
					}
					else {
						offset.x += 32;
						offset.y += 32;
					}
					target.toolTip.moveTo(offset.x, offset.y);
				}
				else if ( target.toolTip.data.alginMode == 4 )
				{
					offset.x = target.x + target.toolTip.data.offsetX;
					offset.y = target.y + target.toolTip.data.offsetY;
					target.toolTip.moveTo(offset.x, offset.y);
				}
				else if ( target.toolTip.data.alginMode ==5)
				{
					//offset.x = event.stageX;
					//offset.y = event.stageY;
					//var offset : Point = target.localToGlobal(new Point(target.x, target.y));
					var x:int;
					var y:int;
					if (target.toolTip.width + offset.x + target.width > UIManager.root.stage.stageWidth) {
						x = offset.x  - target.width- target.toolTip.width;
					}else {
						x = offset.x;
					}
					if (target.toolTip.height + offset.y < UIManager.root.stage.stageHeight + target.height) {
						y = offset.y -target.height;//+ target.height
					}else {
						if ((target.toolTip.height + target.height + offset.y > UIManager.root.stage.stageHeight) && (offset.y > target.toolTip.height)) {
							y = offset.y - target.toolTip.height;
						}else {
							y = UIManager.root.stage.stageHeight / 2 - target.toolTip.height / 2;
						}
					}
					//if ((offset.x + target.toolTip.width +32 > UIManager.root.stage.stageWidth) && (offset.y + target.toolTip.height +200 > UIManager.root.stage.stageHeight))
					//{
						//offset.x -= target.width*0.5 + target.toolTip.width;
						//offset.y -= target.height * 0.5 + target.toolTip.height;
						//if ( offset.x <= 0 )
						//{
							//offset.x = 10;
						//}
						//if ( offset.y <= 0 )
						//{
							//offset.y = 10;
						//}
					//}
					//else if ( offset.y + target.toolTip.height +200> UIManager.root.stage.stageHeight )
					//{
						//offset.x += 32;
						//offset.y -= target.height * 0.5 + target.toolTip.height;
						//if ( offset.x <= 0 )
						//{
							//offset.x = 10;
						//}
						//if ( offset.y <= 0 )
						//{
							//offset.y = 10;
						//}
					//}
					//else if(offset.x + target.toolTip.width +32> UIManager.root.stage.stageWidth) {
						//offset.x -= target.width * 0.5 + target.toolTip.width;
						//if ( offset.x <= 0 )
						//{
							//offset.x = 10;
						//}
						//if ( offset.y <= 0 )
						//{
							//offset.y = 10;
						//}
					//}
					//else {
						//offset.x += 32;
						//offset.y += 32;
					//}
					//target.toolTip.moveTo(offset.x, offset.y);
					target.toolTip.moveTo(x, y);
				}
				UIManager.root.addChild(target.toolTip);
			}
		}

		private static function toolTip_rollOutHandler(event : MouseEvent) : void {
			var target : UIComponent = UIComponent(event.target);
			if (target.toolTip) {
				target.clearToolTip();
				target.toolTip.hide();	
			}
		}

		public static function registerToolTip(target : UIComponent, usemousemove: Boolean = false) : void {
			if ( usemousemove ) {
				target.addEventListener(MouseEvent.MOUSE_MOVE, toolTip_rollOverHandler);
			}
			else {
				target.addEventListener(MouseEvent.ROLL_OVER, toolTip_rollOverHandler);
			}
			
			target.addEventListener(MouseEvent.ROLL_OUT, toolTip_rollOutHandler);
		}
	}
}