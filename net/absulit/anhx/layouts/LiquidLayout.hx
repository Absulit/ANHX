  /**
	ANHX - HaXe NME multipurpose code
    Copyright (C) 2012  Sebastián Sanabria Díaz - admin@absulit.net

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
   */

package net.absulit.anhx.layouts;
import flash.display.DisplayObject;

/**
 * ...
 * @author Sebastian Sanabria Diaz
 */

class LiquidLayout {
	private var _items:Array<LiquidLayoutObject>;
	public function new() {
		_items = new Array();
	}
	
	public function addDisplayObject(value:DisplayObject, align:String = "none", delay:Float = 2) :LiquidLayoutObject {
		var llo:LiquidLayoutObject = new LiquidLayoutObject(value, align, delay);
		_items.push(llo);
		return llo;
	}
	
	public function addLiquidLayoutObject(value:LiquidLayoutObject):Void {
		/*var exists:Boolean = false;			
		if(_items.length > 0){
			var item:LiquidLayoutObject;
			for (var i:int = _items.length-1; i >= 0 ; i--) {
				item = _items[i];
				if (item.target == value.target) {
					_items.splice(i, 1);
					_items.push(value);
					exists = true;
					break;
				}
			}
		}
		if (!exists) {
			_items.push(value);
		}*/
		_items.push(value);
	}
	
	/*public function removeDisplayObject(value:DisplayObject):Boolean {
		var removed:Boolean = false;
		_items.
	}*/
	
	public function getLiquidLayoutObject(target:DisplayObject):LiquidLayoutObject {
		var llo:LiquidLayoutObject = null;
		var item:LiquidLayoutObject;
		for (item in _items ) {
			if (item.target == target) {
				llo = item;
				break;
			}
		}
		return llo;
	}
	
}