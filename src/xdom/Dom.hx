package xdom;

import haxe.DynamicAccess;
import haxe.macro.Expr;

using tink.hxx.Node;

import tink.hxx.Located;

using tink.hxx.Attribute;

#if macro
class Dom extends tink.hxx.Generator {
	var __root:Expr;

	public function new(e) {
		super();
		this.__root = e;
	}

	var childrenType = haxe.macro.ComplexTypeTools.toType(macro:Dynamic);

	override function node(n:tink.hxx.Node, pos:haxe.macro.Expr.Position) {
		var attr:Array<tink.anon.Macro.Part> = [], splats = [];

		for (a in n.attributes)
			switch a {
				case Splat(e):
					splats.push(e);
				case Empty(name):
					attr.push({
						name: name.value,
						pos: name.pos,
						getValue: function(_) return macro @:pos(name.pos) true,
					});
				case Regular(name, value):
					attr.push({
						name: name.value,
						pos: name.pos,
						getValue: function(_) return value,
					});
			}

		var a = tink.anon.Macro.mergeParts(attr, splats, pos, macro:Dynamic);
		var children = switch n.children {
			case null | {value: null | []}: macro null;
			case v: {
			// 		switch v {
			// 			case {pos: p, value: x}: {
			// 					switch (x) {
			// 						case s: {
			// 								for(xs in s){
			// 									switch xs {
			// 										case {pos:p, value:CText(xss)}:{
			// 											trace(xss);
			// 											var type = haxe.macro.ComplexTypeTools.toType(macro:String);
			// 											trace(makeChildren(v, type, false));
			// 										}
			// 										case _:
			// 											// trace(x);
			// 											makeChildren(v, childrenType, false);
			// 									}
			// 								}
			// 								null;
			// 						}
			// 						case _:{
			// 							null;
			// 						}
			// 					}
			// 				}
			// 			case _: {
			// 					makeChildren(v, childrenType, false);
			// 				}
			// 		}
			// 	}
			// case _ => k: {
			// 		trace(k);
			// 		null;
			// 	}
				makeChildren(v, childrenType, false);
			}
		}
		return macro @:pos(pos) Root.tag($__root, $v{n.name.value}, $a, $children);
	}
}
#end
