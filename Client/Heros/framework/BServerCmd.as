package framework 
{
	/**
	 * ...
	 * @author ...
	 */
	public class BServerCmd extends BCommand 
	{
		public var iServerRet : int;
		public function BServerCmd(tcmd:String,iret : int) 
		{
			super(tcmd);
			iServerRet = iret;
		}
		
	}

}