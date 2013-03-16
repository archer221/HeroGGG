package control 
{
	import framework.BztcFacade;
	import framework.BztcModel;
	import com.ui.manager.CallBackFuntion;
	import framework.EventEnum;
	import com.ui.mediator.IMediator;
	import flash.events.MouseEvent;
	import FKPP.Item.ItemType;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.system.IME;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import com.frame.ExactTimer;
	import com.ui.manager.UIManager;
	import com.key.HotKey;
	import com.key.IKeyFliter;
	import com.key.KeyData;
	import framework.MediatorMgr;
	/**
	 * ...
	 * @author ...
	 */
	public class GameControl implements IKeyFliter
	{	
		private var _stage : Stage;
		
		private var _hotKey : HotKey;

		private var _weaponKeys : Array;

		private var _itemKeys : Array;
		
		private function hot_left(data : KeyData) : void {
			if(data.isKeyDown) {
				_hotKey.setActive(Keyboard.RIGHT, false);
			} else {
				_hotKey.setActive(Keyboard.RIGHT, true);
			}
			BztcFacade.Instance.AddCommand(new BkeyCommand(EventEnum.Keycommand, data));
		}

		private function hot_right(data : KeyData) : void {
			if (data.isKeyDown) {
				_hotKey.setActive(Keyboard.LEFT, false);
			} else {
				_hotKey.setActive(Keyboard.LEFT, true);
			}
			BztcFacade.Instance.AddCommand(new BkeyCommand(EventEnum.Keycommand, data));
			//_myrole.GameState.ReceiveKeyCode(data);
		}

		private function up_handler(data : KeyData) : void {
			BztcFacade.Instance.AddCommand(new BkeyCommand(EventEnum.Keycommand, data));
			//_myrole.GameState.ReceiveKeyCode(data);
		}

		private function down_handler(data : KeyData) : void {
			BztcFacade.Instance.AddCommand(new BkeyCommand(EventEnum.Keycommand, data));
			//_myrole.GameState.ReceiveKeyCode(data);	
		}

		private function hot_space(data : KeyData) : void {
			BztcFacade.Instance.AddCommand(new BkeyCommand(EventEnum.Keycommand, data));
			//_myrole.GameState.ReceiveKeyCode(data);
		}
		
		private function hot_r(data : KeyData) : void
		{
			if (data.isKeyDown)
			{
				BztcFacade.Instance.AddCommand(new BkeyCommand(EventEnum.Keycommand, data));
				//_myrole.GameState.ReceiveKeyCode(data);
			}
		}
		
		private function hot_escape(data : KeyData) : void
		{
			if (data.isKeyDown)
			{
				BztcFacade.Instance.AddCommand(new BkeyCommand(EventEnum.Keycommand, data));
				//_myrole.GameState.ReceiveKeyCode(data);
			}
		}
		


		private function hot_229( data : KeyData ):void
		{
			BztcFacade.Instance.AddCommand(new BkeyCommand(EventEnum.Keycommand, data));
			//if (data.isKeyDown && _view.IsShow()) {
				//if (BztcUIManager.friendmsgpanel.parent != null) return;
				//if (_view.battleView._chatinput.parent == null)
				//{
					//IME.enabled = false;
				//}
				//else
				//{
					//IME.enabled = true;
				//}
			//}
		}
		
		private function hot_enter(data : KeyData) : void {
			BztcFacade.Instance.AddCommand(new BkeyCommand(EventEnum.Keycommand, data));

//			if (data.isKeyDown &&  MediatorMgr.Instance.commonmainMediator.myShowType == 1) {
//				if (MediatorMgr.Instance.commonmainMediator.ifGamePutinShow())
//				{
//					IME.enabled = true;
//					MediatorMgr.Instance.commonmainMediator.showGamePutin();
//				}
//				else
//				{
//					if (_stage.focus == null)
//					{
//						IME.enabled = true;
//						MediatorMgr.Instance.commonmainMediator.showGamePutinFocus();
//					}
//					else
//					{
//						IME.enabled = false;
//						MediatorMgr.Instance.commonmainMediator.hideGamePutin();
//					}
//				}
//			}
		}

		private function hot_selectWeapon(data : KeyData) : void {
			if( data.isKeyDown )
				BztcFacade.Instance.AddCommand(new BkeyCommand(EventEnum.Keycommand, data));
			//if(data.isKeyDown) {
				//if (data.keyCode == HotKey.K_Z)
				//{
					//if ( _myrole.canUseWeapon(ItemType.Gun) )
					//{
						//_myrole.StartChangeWeapon(ItemType.Gun, 0);
						//_view.battleview.onSelectWeapon(0);
					//}
				//}
				//else if (data.keyCode == HotKey.K_X)
				//{
					//if ( _myrole.canUseWeapon(ItemType.BigGun) )
					//{
						//_myrole.StartChangeWeapon(ItemType.BigGun, 0);
						//_view.battleview.onSelectWeapon(1);
					//}
				//}
				//else if (data.keyCode == HotKey.K_C)
				//{
					//if ( _myrole.canUseWeapon(ItemType.Grenade) )
					//{
						//_myrole.StartChangeWeapon(ItemType.Grenade, 0);
						//_view.battleview.onSelectWeapon(2);
					//}
				//}
			//}
		}
		
		private function hot_MDown(data : KeyData) : void
		{
			if (!BztcModel.bCanSuperMan) return;
			BztcFacade.Instance.AddCommand(new BkeyCommand(EventEnum.Keycommand, data));
		}

		private function hot_useItem(data : KeyData) : void {
			if( data.isKeyDown )
				BztcFacade.Instance.AddCommand(new BkeyUseItemCmd(EventEnum.Keyuseitemcommand, data));
			//var level:int = BztcModel.myUserData.roleData.roleInfo.baseInfo.Level;
			//var isvip:Boolean = BztcModel.myUserData.roleData.roleInfo.baseInfo.is_yellow_vip;
			//if (data.isKeyDown) {
				//if (data.keyCode == HotKey.K_V)
				//{
					//_myrole.StartChangeWeapon(0, 13);
					//_view.battleview.onSelectTempItem(0);
				//}
				//else if (data.keyCode == HotKey.K_B)
				//{
					//_myrole.StartChangeWeapon(0, 14);
					//_view.battleview.onSelectTempItem(1);
				//}
				//else if (data.keyCode == HotKey.K_N)
				//{
					//_myrole.StartChangeWeapon(0, 15);
					//_view.battleview.onSelectTempItem(2);
				//}
				//else if (data.keyCode == HotKey.K_T) {
					//if (isvip) {
						//_myrole.StartChangeWeapon(0, 7);
						//_view.battleview.onSelectItemBag(0);
					//}else {
						//if (level >= 2) {
							//_myrole.StartChangeWeapon(0, 7);
							//_view.battleview.onSelectItemBag(0);
						//}
					//}
				//}
				//else if (data.keyCode == HotKey.K_Y) {
					//if (isvip) {
						//_myrole.StartChangeWeapon(0, 8);
						//_view.battleview.onSelectItemBag(1);
					//}else {
						//if (level >= 3) {
							//_myrole.StartChangeWeapon(0, 8);
							//_view.battleview.onSelectItemBag(1);
						//}
					//}
				//}
				//else if (data.keyCode == HotKey.K_U) {
					//if (isvip) {
						//_myrole.StartChangeWeapon(0, 9);
						//_view.battleview.onSelectItemBag(2);
					//}else {
						//if (level >= 4) {
							//_myrole.StartChangeWeapon(0, 9);
							//_view.battleview.onSelectItemBag(2);
						//}
					//}
				//}
				//else if (data.keyCode == HotKey.K_I) {
					//if (isvip) {
						//_myrole.StartChangeWeapon(0, 10);
						//_view.battleview.onSelectItemBag(3);
					//}else {
						//if (level >= 5) {
							//_myrole.StartChangeWeapon(0, 10);
							//_view.battleview.onSelectItemBag(3);
						//}
					//}
				//}
				//else if (data.keyCode == HotKey.K_O) {
					//if (isvip) {
						//_myrole.StartChangeWeapon(0, 11);
						//_view.battleview.onSelectItemBag(4);
					//}else {
						//if (level >= 6) {
							//_myrole.StartChangeWeapon(0, 11);
							//_view.battleview.onSelectItemBag(4);
						//}
					//}
				//}
				//else if (data.keyCode == HotKey.K_P) {
					//if (isvip) {
						//_myrole.StartChangeWeapon(0, 12);
						//_view.battleview.onSelectItemBag(5);
					//}else {
						//if (level >= 7) {
							//_myrole.StartChangeWeapon(0, 12);
							//_view.battleview.onSelectItemBag(5);
						//}
					//}
				//}
				//else
				//{
					//_myrole.StartChangeWeapon(0, data.keyCode - 48);
					//_view.battleview.OnSelectItem(data.keyCode - 48);
				//}
			//}
		}

		private function hot_skip(data : KeyData) : void {
			if (data.isKeyDown) {
				BztcFacade.Instance.AddCommand(new BkeyCommand(EventEnum.Keycommand, data));
				//_myrole.GameState.ReceiveKeyCode(data);
			}
		}

		private function hot_exit(data : KeyData) : void {
			if (data.isKeyDown) {
				BztcFacade.Instance.AddCommand(new BkeyCommand(EventEnum.Keycommand, data));
				//_myrole.GameState.ReceiveKeyCode(data);
			}
		}

		public function GameControl() : void {
			_stage = UIManager.root.stage;
			_hotKey = new HotKey(_stage, this);
			_hotKey.setHotKey(Keyboard.LEFT, hot_left);
			_hotKey.setHotKey(Keyboard.RIGHT, hot_right);
			_hotKey.setHotKey(Keyboard.UP, up_handler);
			_hotKey.setHotKey(Keyboard.DOWN, down_handler);
			_hotKey.setHotKey(Keyboard.SPACE, hot_space);
			_hotKey.setHotKey(HotKey.K_R, hot_r);
			_hotKey.setHotKey(Keyboard.ESCAPE, hot_escape);
			_hotKey.setHotKey(Keyboard.ENTER, hot_enter, KeyData.ONLY_DOWN);
			_hotKey.setHotKey(Keyboard.M, hot_MDown, KeyData.ONLY_DOWN);
			_hotKey.setHotKey(HotKey.K_229, hot_229,KeyData.ONLY_DOWN);
			_weaponKeys = [HotKey.K_Z,HotKey.K_X,HotKey.K_C];
			
			var keyCode : uint;
			for each(keyCode in _weaponKeys) {
				_hotKey.setHotKey(keyCode, hot_selectWeapon, KeyData.ONLY_DOWN);
			}
			_itemKeys = [HotKey.K_1, HotKey.K_2, HotKey.K_3, HotKey.K_4, HotKey.K_5, HotKey.K_6, HotKey.K_V, HotKey.K_B, HotKey.K_N,
						HotKey.K_T, HotKey.K_Y, HotKey.K_U, HotKey.K_I, HotKey.K_O, HotKey.K_P];
			for each(keyCode in _itemKeys) {
				_hotKey.setHotKey(keyCode, hot_useItem, KeyData.ONLY_DOWN);
				_hotKey.setActive(keyCode, false);
			}
			_hotKey.setHotKey(HotKey.K_E, hot_skip, KeyData.ONLY_DOWN);
			_hotKey.setHotKey(HotKey.K_Q, hot_exit, KeyData.ONLY_DOWN);
		}

		public function convertKeyCode(keyCode : uint) : uint {
			if(keyCode == HotKey.K_A)return Keyboard.LEFT;
			else if(keyCode == HotKey.K_D)return Keyboard.RIGHT;
			else if(keyCode == HotKey.K_W)return Keyboard.UP;
			else if(keyCode == HotKey.K_S)return Keyboard.DOWN;
			return keyCode;
		}
		
		public function checkKeyCode(keyCode : uint) : Boolean
		{
			if (_hotKey.keyStateMap.containsKey(keyCode)) return true;
			return false;
		}
		
		public function ClearKeyCode() : void
		{
			_hotKey.clearKeyState();
		}
		
		public var callbackFilterFunc : CallBackFuntion;
		
		public function keyDownFliter(keyCode : uint) : Boolean {
			if (keyCode == Keyboard.ENTER) return false;
			if ( callbackFilterFunc != null )
			{
				callbackFilterFunc.setparam([keyCode,0]);
				var result = callbackFilterFunc.ExecR();
				if ( result )
				{
					return result;
				}
			}
			return _stage.focus != null;
		}

		public function set active(value : Boolean) : void {
			_hotKey.setActive(Keyboard.LEFT, value);
			_hotKey.setActive(Keyboard.RIGHT, value);
			_hotKey.setActive(Keyboard.UP, value);
			_hotKey.setActive(Keyboard.DOWN, value);
			_hotKey.setActive(Keyboard.SPACE, value);
			_hotKey.setActive(HotKey.K_R, value);
			_hotKey.setActive(Keyboard.ESCAPE, value);
			_hotKey.setActive(Keyboard.M, value);
			var keyCode : uint;
			for each(keyCode in _weaponKeys) {
				_hotKey.setActive(keyCode, value);
			}
			for each(keyCode in _itemKeys) {
				_hotKey.setActive(keyCode, value);
			}
			_hotKey.setActive(HotKey.K_E, value);
			_hotKey.setActive(HotKey.K_Q, value);
			
			//_hotKey.active = value;
		}

		public function start() : void {
			_hotKey.setActive(Keyboard.LEFT, true);
			_hotKey.setActive(Keyboard.RIGHT, true);
			_hotKey.setActive(Keyboard.UP, true);
			_hotKey.setActive(Keyboard.DOWN, true);
			_hotKey.setActive(Keyboard.SPACE, true);
			_hotKey.setActive(HotKey.K_Q, true);
			_hotKey.setActive(HotKey.K_1, true);
			_hotKey.setActive(HotKey.K_2, true);
			_hotKey.setActive(HotKey.K_3, true);
			_hotKey.setActive(HotKey.K_4, true);
			_hotKey.setActive(HotKey.K_5, true);
			_hotKey.setActive(HotKey.K_6, true);
			_hotKey.setActive(HotKey.K_Z, true);
			_hotKey.setActive(HotKey.K_X, true);
			_hotKey.setActive(HotKey.K_C, true);
			_hotKey.setActive(Keyboard.F12, true);
			_hotKey.setActive(HotKey.K_R, true);
			_hotKey.setActive(Keyboard.ESCAPE, true);
			_hotKey.setActive(Keyboard.M, true);
			_hotKey.active = true;
		}

		public function end() : void {
			_hotKey.active = false;
		}
		
	}

}
