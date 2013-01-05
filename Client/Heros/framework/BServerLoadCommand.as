package framework 
{
	import com.net.ServerLoadModel;
	/**
	 * ...
	 * @author ...
	 */
	public class BServerLoadCommand extends BCommand 
	{
		public var _loadmodel : ServerLoadModel;
		public function BServerLoadCommand(tcmd:String,loadmodel : ServerLoadModel) 
		{
			super(tcmd);
			_loadmodel = loadmodel;
		}
		
	}

}