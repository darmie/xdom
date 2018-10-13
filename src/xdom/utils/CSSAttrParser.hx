package xdom.utils;

using StringTools;

class CSSAttrParser {
	var opts:Dynamic;

	public function new() {}

	public function parse(style:String, ?opts:Dynamic):Style {
		this.opts = opts == null ? {}
			: opts;

		var preserveNumbers = opts != null ? opts.preserveNumbers : null;

		var trim = function(s:String) {
			return s.trim();
		};

		var obj = {};

		var chunks = getKeyValueChunks(style).map(trim);
        
		for (item in chunks) {
			// split with `.indexOf` rather than `.split` because the value may also contain colons.
			var pos = item.indexOf(':');
			var key = item.substr(0, pos).trim();
            
			var val = item.substr(pos + 1).trim();

			if (isNumeric(val)) {
                Reflect.setField(obj, key, Std.parseInt(val));
			} else {
                Reflect.setField(obj, key, val);
            }
			
		}
        return obj;
	}

	function isNumeric(n:Dynamic):Bool{
		if ((Std.is(n, Float) || Std.is(n, Int)) && Math.isFinite(n)) {
			return true;
		}
		return false;
	}

	function getKeyValueChunks(raw:String):Array<Dynamic> {
		var chunks = [];
		var offset = 0;
		var sep = ';';
		var hasUnclosedUrl = ~/url\([^\)]+$/;
		var chunk = '';
		var nextSplit:Int;
		while (offset < raw.length) {
			nextSplit = raw.indexOf(sep, offset);
			if (nextSplit == -1) {
				nextSplit = raw.length;
			}

			chunk += raw.substring(offset, nextSplit);

			// data URIs can contain semicolons, so make sure we get the whole thing
			if (hasUnclosedUrl.match(chunk)) {
				chunk += ';';
				offset = nextSplit + 1;
				continue;
			}

			chunks.push(chunk);
			chunk = '';
			offset = nextSplit + 1;
		}

		return chunks;
	}
}
