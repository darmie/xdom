package xdom;

import haxe.macro.Expr;

@:forward(
	addChild,  
	attributes, 
	insertChild,
	exists,
	remove,
	removeChild,
	set,
	get,
	toString,
	parent,
	nodeName)
abstract Root(Xml) from Xml to Xml {


	public inline function new(?name:String) {
		if (name != null) {
			this = Xml.createElement(name);
		} else {
			this = Xml.createElement('root');
		}
	}

	static public function tag(?root:Root, name:String, attr:Dynamic, ?children:Array<Dynamic>):Dynamic {
		
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
					if(Std.is(_child, Xml)){
						child.addChild(_child);
					} else {
						child.addChild(Xml.createPCData(_child));
					}
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

	public inline function addContent(content:String) {
		this.addChild(Xml.createPCData(content));
	}

	public inline function elements():Iterator<Root> {
		return this.elements();
	}

	public inline function elementsNamed(name:String):Iterator<Root> {
		return this.elementsNamed(name);
	}

	public inline function firstChild():Root {
		return this.firstChild();
	}

	public inline function firstElement():Root {
		return this.firstElement();
	}

	public inline function iterator():Iterator<Root> {
		return this.iterator();
	}

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
