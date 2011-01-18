package
{
	public class BertAtom
	{
		public var value:String;
		public function BertAtom(value:String)
		{
			this.value = value;
		}
		
		public function toString():String {
			return value;
		};
	}
}