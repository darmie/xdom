package xdom;

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.DynamicAccess;

abstract AttrVal(String) from String to String {
	@:from static function ofBool(b:Bool):AttrVal
		return if (b) "" else null;
}

abstract Root(Xml) from Xml to Xml {
	public inline function new(?name:String) {
		if(name != null){
			this = Xml.createElement(name);
		} else {
			this = Xml.createElement('root');
		}
	}

	static public function tag(?root:Root, name:String, attr:Dynamic, ?children:Array<Root>):Root {
		if (root == null) {
			root = Xml.createElement(name);

			for (a in Reflect.fields(attr)) {
				root.set(a, Reflect.field(attr, a));
			}

			if (children != null)
				for (child in children) {
					root.addChild(child);
				}

			return root;
		} else {
			var child = Xml.createElement(name);
			for (a in Reflect.fields(attr)) {
				child.set(a, Reflect.field(attr, a));
			}

			if (children != null)
				for (_child in children) {
					child.addChild(_child);
				}

			root.addChild(child);

			return child;
		}
	}


	public inline function getStyle():Style {
		return new xdom.utils.CSSAttrParser().parse('${Std.string(this.get("style"))}');
	}

	public inline function getCurrentElement():Root {
		return this.firstChild();
	}

	public inline function addChild(child:Root) {
		this.addChild(child);
	}

	public inline function elements():Iterator<Root> {
		return this.elements();
	}

	public inline function attributes():Iterator<String> {
		return this.attributes();
	}

	public inline function elementsNamed(name:String):Iterator<Root> {
		return this.elementsNamed(name);
	}

	public inline function exists(attr:String):Bool {
		return this.exists(attr);
	}

	public inline function firstChild ():Root {
		return this.firstChild();
	}

	public inline function firstElement ():Root {
		return this.firstElement();
	}

	public inline function insertChild(child:Root, pos:Int) {
		this.insertChild(child, pos);
	}

	public inline function iterator():Iterator<Root> {
		return this.iterator();
	}

	public inline function remove(attr:String) {
		this.remove(attr);
	}


	public inline function removeChild(child:Root):Bool {
		return this.removeChild(child);
	}
	public inline function set(name:String, attr:String) {
		this.set(name, attr);
	}

	public inline function get(name:String):String {
		return this.get(name);
	}

	public inline function toString():String
		return this.toString();




	public static inline function createCData(data:String):Root {
		return Xml.createCData(data);
	}

	public static inline function createElement(name:String):Root {
		return Xml.createElement(name);
	}

	public static inline function parse(str:String):Root {
		return Xml.parse(str);
	}

	public inline function getParent():Root {
		return this.parent;
	}

	public inline function name():String {
		return this.nodeName;
	}

	macro public function update(ethis, e) {
		return new Dom(ethis).root(tink.hxx.Parser.parseRoot(e, {
			defaultExtension: 'hxx',
			isVoid: function(s) return switch s.value {
				case 'img': true;
				case 'text': true;
				default: false;
			}
		}));
	}
}
