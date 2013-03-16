package control 
{
	import framework.BCommand;
	import com.key.KeyData;
	
	/**
	 * ...
	 * @author ...
	 */
	public class BkeyCommand extends BCommand 
	{
		public var keydata : KeyData;
		public function BkeyCommand(tcmd:String,tkeydata : KeyData) 
		{
			super(tcmd);
			keydata = tkeydata;
		}
	}

}