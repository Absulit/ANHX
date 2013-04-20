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

package net.absulit.anhx.interfaces.image;
import net.absulit.anhx.events.SimpleImageContainedEvent;
import net.absulit.anhx.interfaces.Container;
import net.absulit.anhx.interfaces.ContainerScaleStates;
import net.absulit.anhx.interfaces.Destroy;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.Lib;

/**
 * ...
 * @author Sebastian Sanabria Diaz
 */

class SimpleImageContained extends SimpleImage, implements Destroy {
	private var _container:Container;
	private var _mask:Sprite;
	private var _borderLine:Sprite;
	private var _border:Bool;
	
	//private var _width:Float;
	//private var _height:Float;
	public function new() {
		super();
	}
	
	override private function init():Void {
		super.init();
		_container = new Container();
		_container.scaleState = ContainerScaleStates.AUTO
		_container.width = 80;
		_container.height = _container.width;
		_mask = new Sprite();
		_mask.graphics.beginFill(0x000000);
		_mask.graphics.drawRect(0, 0, _container.width, _container.height);
		_mask.graphics.endFill();
		_border = false;
	}
	
	override private function onCompleteContentLoaderInfo(e:Event):Void {
		super.onCompleteContentLoaderInfo(e);
		_container.content = this._content;
		//_container.content = this._loader.content;
		_container.centerH = true;
		_container.centerV = true;
		_container.drag = true;
		_container.content.addEventListener(MouseEvent.CLICK, onClickContent);
		addChildAt(_mask,0);
		_container.content.mask = _mask;
		if (_borderLine != null) {
			addChildAt(_borderLine,0);	
		}
		dispatchEvent(new SimpleImageContainedEvent(SimpleImageContainedEvent.COMPLETE_CONTAINER));
	}
	
	private function onClickContent(e:MouseEvent):Void {
		Lib.trace("onClickContent");
	}
	
	private function get_height():Float {
		return _container.height;
	}
	
	private function set_height(value:Float):Float {
		_container.height = value;
		if(_borderLine != null){
			_borderLine.graphics.clear();
			_borderLine.graphics.lineStyle(2, 0xff0000,.5,true);
			_borderLine.graphics.drawRect(0, 0, _container.width, _container.height);
		}
		
		_mask.width = _container.width;
		_mask.height = _container.height;
	}
	
	public var height(get_height, set_height):Float;
	
	private function get_width():Float {
		return _container.height;
	}
	
	private function set_width(value:Float):Float {
		_container.width = value;
		if(_borderLine != null){
			_borderLine.graphics.clear();
			_borderLine.graphics.lineStyle(2, 0xff0000,.5,true);
			_borderLine.graphics.drawRect(0, 0, _container.width, _container.height);
		}
		
		_mask.width = _container.width;
		_mask.height = _container.height;
	}
	
	public var width(get_width, set_width):Float;
	
	
	

	
	
}