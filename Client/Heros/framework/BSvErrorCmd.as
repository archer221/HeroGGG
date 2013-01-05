package framework 
{
	/**
	 * ...
	 * @author ...
	 */
	public class BSvErrorCmd extends BCommand 
	{
		public var cmdcode : int;
		public function BSvErrorCmd(tcmd:String,tcmdcode : int) 
		{
			super(tcmd);
			cmdcode = tcmdcode;
		}
		
	}

}