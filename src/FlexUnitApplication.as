package
{
	import Array;
	
	import flash.display.Sprite;
	
	import flexUnitTests.AsbertTest;
	
	import flexunit.flexui.FlexUnitTestRunnerUIAS;
	
	import org.flexunit.runner.Request;
	
	public class FlexUnitApplication extends Sprite
	{
		public function FlexUnitApplication()
		{
			onCreationComplete();
		}
		
		private function onCreationComplete():void
		{
			var testRunner:FlexUnitTestRunnerUIAS=new FlexUnitTestRunnerUIAS();
			this.addChild(testRunner); 
			testRunner.runWithFlexUnit4Runner(currentRunTestSuite(), "asbert");
		}
		
		public function currentRunTestSuite():Array
		{
			var testsToRun:Array = new Array();
			testsToRun.push(Request.methods(flexUnitTests.AsbertTest,["shouldEncodeBinary",
				"shouldEncodeNegativeFiveThousand",
				"shouldEncodeFourtyTwo",
				"shouldEncodeAtom",
				"shouldEncodeZero",
				"shouldEncodeFiveThousand",
				"shouldEncodeLargeNegativeNumbers",
				"shouldEncodeNegativeOne",
				"shouldEncodeBoolean",
				"shouldEncodeNull",
				"shouldEncodeLargeNumbers"]));
			
			return testsToRun;
		}
	}
}