package xdom;

import openfl.display.Sprite;
/**
 * Base element abstract for UI
 */
@:forward(
    getStyle,
    firstChild,
    firstElement,
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
    update,
	nodeName)
abstract Base(Root) from Root to Root {
    public inline function new(){
        this = new xdom.Root();
    }


    /**
     * Add child
     * @param child 
     */
    public function add(child:Base) {
        this.addChild(child);
    }

    /**
     * Get children
     * @return Iterator<Base>
     */
    public function children():Iterator<Base>{
        return this.elements();
    }

    /**
     * Render DOM to UI view and return it's container sprite
     * @return Sprite
     */
    public inline function render():Sprite {
        var object:Sprite = new Sprite();

        var layout = computeLayout();

        for(child in children()){
            object.addChild(child.render());
        }

        return object;
    }


    /**
     * Yoga layout computation
     * @return Dynamic
     */
    public inline function computeLayout():Dynamic{

        return null;
    }
}