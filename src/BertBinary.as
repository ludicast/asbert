package
{
	public class BertBinary
	{
		public var value:Object;
		public function BertBinary(value:Object)
		{
			this.value = value;
		}
		
		public function toString():String {
			return "<<\"" + value.toString() + "\">>";
		};		
		
	}
}