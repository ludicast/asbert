package
{
	import org.osmf.utils.BinarySearch;

	public class Bert
	{
		public static const BERT_START:String = String.fromCharCode(131);
		public static const SMALL_ATOM:String = String.fromCharCode(115);
		public static const ATOM:String = String.fromCharCode(100);
		public static const BINARY:String = String.fromCharCode(109);
		public static const SMALL_INTEGER:String = String.fromCharCode(97);
		public static const INTEGER:String = String.fromCharCode(98);
		public static const SMALL_BIG:String = String.fromCharCode(110);
		public static const LARGE_BIG:String = String.fromCharCode(111);
		public static const FLOAT:String = String.fromCharCode(99);
		public static const STRING:String = String.fromCharCode(107);
		public static const LIST:String = String.fromCharCode(108);
		public static const SMALL_TUPLE:String = String.fromCharCode(104);
		public static const LARGE_TUPLE:String = String.fromCharCode(105);
		public static const NIL:String = String.fromCharCode(106);
		public static const ZERO:String = String.fromCharCode(0);		
		
		
		public static function binaryToList(binary:String):Array {
			var ret:Array = [];
			for (var i:Number = 0; i < binary.length; i++)
				ret.push(binary.charCodeAt(i));
			return ret;
		}
			
		public static function encodeAtom(atom:BertAtom):String {
			return ATOM + intToBytes(atom.value.length, 2) + atom.value;
		}	
		
		public static function encodeBinary(binary:BertBinary):String {
			return BINARY + intToBytes(binary.value.toString().length, 4) + binary.value;
		}
		
		public static function encodeBoolean(bool:Boolean):String {
			if (bool) {
				return encodeInner(new BertAtom("true"));
			} else {
				return encodeInner(new BertAtom("false"));
			}
				
			
		}
		public static function encode(obj:Object):String
		{
			return BERT_START + encodeInner(obj);
		}
		
		public static function encodeInner(obj:Object):String {
			if (obj is BertAtom) {
				return encodeAtom(BertAtom(obj));
			}
			if (obj is BertBinary) {
				return encodeBinary(BertBinary(obj));
			}			
			if (obj is Boolean) {
				return encodeBoolean(Boolean(obj));
			}
			if (obj is Number) {
				return encodeNumber(Number(obj));
			}
			
			return "";
		}
		
		
		
		/**********
		 * 
		 *  NEED TO EXAMINE 
		 * 
		 */
		
		// Encode an integer to a big-endian byte-string of length Length.
		// Throw an exception if the integer is too large
		// to fit into the specified number of bytes.
		public static function intToBytes(Int:int, Length:int):String {
			var isNegative, OriginalInt, i, Rem, s = "";
			isNegative = (Int < 0);
			if (isNegative) {
				Int = - Int - 1;
			}
			OriginalInt = Int;
			for (i = 0; i < Length; i++) {
				Rem = Int % 256;
				if (isNegative) {
					Rem = 255 - Rem;
				}
				s = String.fromCharCode(Rem) + s;
				Int = Math.floor(Int / 256);
			}
			if (Int > 0) {
				throw ("Argument out of range: " + OriginalInt);
			}
			return s;
		};

		public static function encodeNumber (Obj:Number):String {
			var s, isInteger = (Obj % 1 === 0);
			
			// Handle floats...
			if (!isInteger) {
				return encodeFloat(Obj);
			}
			
			// Small int...
			if (isInteger && Obj >= 0 && Obj < 256) {
				return SMALL_INTEGER + intToBytes(Obj, 1);
			}
			
			// 4 byte int...
			if (isInteger && Obj >= -134217728 && Obj <= 134217727) {
				return INTEGER + intToBytes(Obj, 4);
			}
			
			// Bignum...
			s = bignumToBytes(Obj);
			if (s.length < 256) {
				return SMALL_BIG + intToBytes(s.length - 1, 1) + s;
			} else {
				return LARGE_BIG + intToBytes(s.length - 1, 4) + s;
			}
		};
		
		public static function encodeFloat (Obj:Number) :String{
			// float...
			var s = Obj.toExponential();
			while (s.length < 31) {
				s += ZERO;
			}
			return FLOAT + s;
		};		
		
		public static function bignumToBytes(Int:Number):String {
			var isNegative, Rem, s = "";
			isNegative = Int < 0;
			if (isNegative) {
				Int *= -1;
				s += String.fromCharCode(1);
			} else {
				s += String.fromCharCode(0);
			}
			
			while (Int !== 0) {
				Rem = Int % 256;
				s += String.fromCharCode(Rem);
				Int = Math.floor(Int / 256);
			}
			
			return s;
		};
		
		
	}
}