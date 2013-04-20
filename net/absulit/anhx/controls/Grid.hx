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

package net.absulit.anhx.controls;
import net.absulit.anhx.interfaces.Destroy;
import nme.display.DisplayObject;
import nme.display.Sprite;
import nme.errors.Error;
import nme.events.Event;

/**
 * ...
 * @author Sebastian Sanabria Diaz
 */

class Grid extends Sprite, implements Destroy{
	private var _width:Int;
	private var _height:Int;
	private var _rows:Array<Array<DisplayObject>>;
	public function new() {
		super();
		init();			
		if (stage != null){
			addedToStage();
		}else{
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
	}

	
	private function init() {
		_width = 400;
		_height = 400;
		_rows = new Array();
	}

	
	private function addedToStage(e:Event):Void {
		removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
	}
	
	public function sort():Void {
		if (numChildren == 0) {
			throw new Error("You must add at least one DisplayObjet with addChild or addChildAt");
		}
		var previousX:Int = 0;
		var previousY:Int = 0;
		var previousW:Int = 0;
		var previousH:Int = 0;
		
		var newX:Int = 0;
		var newY:Int = 0;
		var item:DisplayObject;
		_rows = new Array();
		var row:Array<DisplayObject> = new Array();
		var k:Int = 0;
		while(k < this.numChildren) {
			item = this.getChildAt(k);
			if (item.visible) {
				//the new item's position based on the previous item x and width
				newX = previousX + previousW;		
				//if the new item to be sorted overpass the width limit
				//it corresponds to the new row
				if ((newX + item.width) > _width) {
					newX = 0;
					newY = previousY + previousH;
					//finished line, push new row and create new empty one
					_rows.push(row);
					row = new Vector.<DisplayObject>();
					row.push(item);
				}else {
					//
					row.push(item);
				}
				item.x = newX;
				item.y = newY;
				previousX = item.x;
				previousY = item.y;
				previousW = item.width;
				previousH = item.height;			
			}
			k++;
		}
		if (row.length > 0) {
			//trace("item despues de breakline");
			_rows.push(row);
		}
		
		
	}
	
	/* INTERFACE net.absulit.anhx.interfaces.Destroy */
	
	public function destroy():Void {
		_width = NaN;
		_height = NaN;
		_rows = null;
	}
	
	private function get_height():Int {
		return _height;
	}
	
	private function set_height(value:Int):Int {
		return _height = value;
	}
	
	public var height(get_height, set_height):Int;
	
	private function get_width():Int {
		return _width;
	}
	
	private function set_width(value:Int):Int {
		return _width = value;
	}
	
	public var width(get_width, set_width):Int;
	
	
}