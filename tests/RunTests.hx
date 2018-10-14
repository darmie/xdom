package;

import xdom.Root;
import dom4.*;

using StringTools;
using xdom.Root;

class RunTests extends haxe.unit.TestCase {
	function testUpdate() {
		var root = new xdom.Root();

		var backgroundImageUrl = 'http://placehold.it/350x150';

		var x:Root = cast root.update
			('
      <div class="test" style=${'background-image: url("${backgroundImageUrl}")'}>Hello HXX !!!</div>
    ');
		assertTrue(x.toString() == root.firstElement().toString());
	}

	function testStyle() {
		var root = new xdom.Root();
		root.update('<div style="height:32%; width:34%">style test</div>');

		assertTrue(root.firstChild().getStyle().height == '32%');
	}

	function testColspan() {
		var root = new xdom.Root();

		root.update('<td colspan=${1}>colspan test</td>');

		assertTrue(Std.parseInt(root.firstChild().get('colspan')) == 1);
	}

	#if tink_hxx
	function testChildSpread() {
		var children = [for (i in 0...5) new xdom.Root('div')];
		var root = new xdom.Root();

		root.update('
      <section>
        <for {child in children}>
          {child}
        </for>
      </section>
    ');
		var _children = [];
		for (child in root.firstElement().elementsNamed('div')) {
			_children.push(child);
		}

		assertEquals(5, _children.length);
	}
	#end

	function testRowspan() {
		var root = new xdom.Root();

		var x = root.update('<td rowspan=${1}>colspan test</td>');

		assertTrue(Std.parseInt(root.firstChild().get('rowspan')) == 1);
	}

	static function main() {
		var runner = new haxe.unit.TestRunner();
		runner.add(new RunTests());
		travix.Logger.exit(if (runner.run()) 0 else 500);
	}
}
