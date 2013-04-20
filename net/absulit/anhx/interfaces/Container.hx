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

package net.absulit.anhx.interfaces;
import com.eclecticdesignstudio.motion.Actuate;
import net.absulit.anhx.events.ContainerEvent;
import nme.display.DisplayObject;
import nme.events.Event;
import nme.events.EventDispatcher;
import nme.events.MouseEvent;
import nme.geom.Point;
import com.eclecticdesignstudio.motion.actuators.GenericActuator;
import nme.ui.Mouse;

/**
 * Creates a virtual container that automatically handles the dynamic and proportional scaling of content, such as Sprites and images
 * @author Sebastian Sanabria Diaz
 */

class Container extends EventDispatcher, implements Destroy {
	private static var MIN_SPEED:Int = 1;
	private var _content:DisplayObject;
	private var _x:Float;
	private var _y:Float;
	private var _width:Float;
	private var _height:Float;
	private var _tweenX:IGenericActuator;
	private var _tweenY:IGenericActuator;
	private var _scaleState:String;
	private var _drag:Bool;
	private var _scroll:Bool;
	private var _centerV:Bool;
	private var _centerH:Bool;
	private var _constraintV:Bool;
	private var _constraintH:Bool;

	private var _lastMouseP:Point;
	private var _speed:Point;
	private var _lastSpeed:Point;
	private var _friction:Float;
	
	private var _mouseDown:Bool;
	private var _mouseLifted:Bool;
	private var _innerW:Bool;
	private var _innerH:Bool;
	
	private var _originalW:Float;
	private var _originalH:Float;
		
	public function new() {
		super();
		init();
	}
	
	private function init() {
		_content = null;
		_x = 0;
		_y = 0;
		_width = 0;
		_height = 0;
		_tweenX = null;
		_tweenY = null;
		_scaleState = null;
		_drag = false;
		_scroll = false;
		_mouseDown = false;
		
		_lastMouseP = new Point();
		_speed = new Point();
		_lastSpeed = new Point();
		_mouseLifted = true;
		_friction = .9;
	}
	

	
	/**
	 * 
	 * @return
	 */
	private function get_scaleState():String {
		return _scaleState;
	}
	
	/**
	 * Set with ContainerScaleStates class
	 * @param	value One of the constant values in ContainerScaleStates
	 * @return
	 */
	private function set_scaleState(value:String):String {
			_scaleState = value;
			if(_content != null){
				if (_scaleState == ContainerScaleStates.AUTO) {
					scaleAuto();
				}else
				if (_scaleState == ContainerScaleStates.WIDTH) {
					scaleWidth();
				}else
				if (_scaleState == ContainerScaleStates.HEIGHT) { 
					scaleHeight();
				}else
				if (_scaleState == ContainerScaleStates.AUTO_REVERSE) {
					scaleAutoReverse() ;
				}else
				if(_scaleState == ContainerScaleStates.NULL) {
					scaleNull();
				}
				
				doCenterH();
				doCenterV();
			}
			return _scaleState;
	}
	
	/**
	 * Get or sets the current scaleState value with ContainerScaleStates constants
	 */
	public var scaleState(get_scaleState, set_scaleState):String;
	
	
	private function get_width():Float {
		return _width;
	}

	private function set_width(value:Float):Float {
		 _width = value;
		 scaleState = _scaleState;
		 return _width;
	}

	public var width(get_width, set_width):Float;


	private function get_height():Float {
		return _height;
	}

	private function set_height(value:Float):Float {
		 _height = value;
		 scaleState = _scaleState;
		 return _height;
	}

	public var height(get_height, set_height):Float;
	
	private function get_content():DisplayObject {
		return _content;
	}
	
	private function set_content(value:DisplayObject):DisplayObject {
		_content = value;
		_x = value.x;
		_y = value.y;
		_originalW = _content.width;
		_originalH = _content.height;
		scaleState = _scaleState;
		return _content;
	}
	
	public var content(get_content, set_content):DisplayObject;
	
	private function get_x():Float {
		return _x;
	}
	
	private function set_x(value:Float):Float {
		return _x = value;
	}
	
	public var x(get_x, set_x):Float;
	
	private function get_y():Float {
		return _y;
	}
	
	private function set_y(value:Float):Float {
		return _y = value;
	}
	
	public var y(get_y, set_y):Float;
	
	private function get_drag():Bool {
		return _drag;
	}
	
	private function set_drag(value:Bool):Bool {
		_drag = value;
		if (_drag) {
			if (!_content.hasEventListener(Event.ENTER_FRAME)) {
				_content.addEventListener(Event.ENTER_FRAME, onEnterFrameDrag);

				_content.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDownDrag);					
				_content.addEventListener(MouseEvent.MOUSE_UP, onMouseUpDrag);
				_content.addEventListener(MouseEvent.MOUSE_OUT, onMouseUpDrag);
			}
		}else {
			if (_content.hasEventListener(Event.ENTER_FRAME)) {
				_content.removeEventListener(Event.ENTER_FRAME, onEnterFrameDrag);

				_content.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDownDrag);					
				_content.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpDrag);
				_content.removeEventListener(MouseEvent.MOUSE_OUT, onMouseUpDrag);
			}
		}
		return _drag;
	}
	
	public var drag(get_drag, set_drag):Bool;
	
	private function get_scroll():Bool {
		return _scroll;
	}
	
	private function set_scroll(value:Bool):Bool {
		_scroll = value;
		if (_scroll) {
			_content.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMoveScroll);
		}else {
			_content.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMoveScroll);
		}		
		return _scroll;
	}
	
	public var scroll(get_scroll, set_scroll):Bool;
	
	private function get_centerH():Bool {
		return _centerH;
	}
	
	private function set_centerH(value:Bool):Bool {
		_centerH = value;
		if(_content != null){
			doCenterH();
		}
		return _centerH;
	}
	
	public var centerH(get_centerH, set_centerH):Bool;
	
	private function doCenterH():Void {
		if (_centerH) {
			_content.x = this.x + ((_width - _content.width) / 2);
		}else {
			_content.x = this.x;
		}
	}
	
	private function get_centerV():Bool {
		return _centerV;
	}
	
	private function set_centerV(value:Bool):Bool {
		_centerV = value;
		if(_content != null){
			doCenterV();
		}
		return _centerV;
	}
	
	public var centerV(get_centerV, set_centerV):Bool;
	
	private function get_constraintV():Bool {
		return _constraintV;
	}
	
	private function set_constraintV(value:Bool):Bool {
		return _constraintV = value;
	}
	
	public var constraintV(get_constraintV, set_constraintV):Bool;
	
	private function get_constraintH():Bool {
		return _constraintH;
	}
	
	private function set_constraintH(value:Bool):Bool {
		return _constraintH = value;
	}
	
	public var constraintH(get_constraintH, set_constraintH):Bool;
	
	private function doCenterV():Void {
		if (_centerV) {
			_content.y = this.y + ((_height - _content.height) / 2);
		}else {
			_content.y = this.y;
		}	
	}
	
	private function onMouseMoveScroll(e:MouseEvent):Void {
		//TODO: version simplificada en SelectionStrip
		var enX:Bool = (_content.parent.mouseX > this._x) && (_content.parent.mouseX < (this._x + this._width));
		var enY:Bool = (_content.parent.mouseY > this._y) && (_content.parent.mouseY < (this._y + this._height));
		if (enX && enY) {
			var px:Float = (_content.parent.mouseX - this._x) / this._width;
			var py:Float = (_content.parent.mouseY - this._y) / this._height;
			var nx:Float = this._x - (px * ((_content.width - this._width - 1)));
			var ny:Float = this._y - (py * ((_content.height - this._height - 1)));
			///
			//_tweenX = new Tween(_content, "x", Strong.easeOut, _content.x, nx, 1, true);
			_tweenX = Actuate.tween(_content, 1, { x:nx });
			//_tweenY = new Tween(_content, "y", Strong.easeOut, _content.y, ny, 1, true);
			_tweenY = Actuate.tween(_content, 1, { x:ny });
		} else {
			
		}
	}
	
	/*private function getTween(prop:String,begin:Float, end:Float, duration:Float=.1):IGenericActuator {
		//return new Tween(_content, prop, Regular.easeOut, begin, end, duration, true);
		_content[prop] = begin;
		return Actuate.tween(_content, duration, { prop:end } );
	}*/
	
	private function onMouseDownDrag(e:Event):Void {
		//e.stopPropagation();
		_mouseDown = true;
		
	}

	private function onMouseUpDrag(e:Event):Void {
		_mouseDown = false;
		_mouseLifted = true;
		/****************************/

		/****************************/
		dispatchEvent(new ContainerEvent(ContainerEvent.STOP_DRAG));
	}
	
	private function onEnterFrameDrag(e:Event):Void {
		var enX:Bool = (_content.parent.mouseX > this._x) && (_content.parent.mouseX  < (this._x + this._width));
		var enY:Bool = (_content.parent.mouseY > this._y) && (_content.parent.mouseY < (this._y + this._height));
		if (!(enY && enX)) {
			//Mouse.cursor = MouseCursor.ARROW;
			#if flash
				Mouse.cursor = "arrow";
			#end
		} else{ 
			//Mouse.cursor = MouseCursor.HAND;
			#if flash
			Mouse.cursor = "hand";
			#end
			if (_mouseDown) {
				var _mouseP:Point = new Point(_content.parent.mouseX, _content.parent.mouseY);
				
				
				var ml:Bool = false;
				if (_mouseLifted) {
					_mouseLifted = false;
					_lastMouseP.x = _mouseP.x;
					_lastMouseP.y = _mouseP.y;
					ml = true;
				}
				
				_speed.x = _mouseP.x - _lastMouseP.x;
				_speed.y = _mouseP.y - _lastMouseP.y;
				
				//trace(_lastSpeed);
				//trace(_speed);
				
				if ((_speed.x == 0) && !ml) {
					_speed.x = _lastSpeed.x;
				}
				if ((_speed.y == 0) && !ml) {
					_speed.y = _lastSpeed.y;
				}
				
				if(allowMovement()){
					_content.x += _speed.x;
					_content.y += _speed.y;
					
					if (_constraintH) {
						if ((_content.x < _x) || (_content.x > _x)) {
							_content.x = _x;
						}
					}
					if (_constraintV) {
						if ((_content.y < _y) || (_content.y > _y)) {
							_content.y = _y;
						}
					}
					
					dispatchEvent(new ContainerEvent(ContainerEvent.START_DRAG));
				}
				

				
				


				
				
				//
				_lastMouseP.x = _mouseP.x;
				_lastMouseP.y = _mouseP.y;
				
				_lastSpeed.x = _speed.x;
				_lastSpeed.y = _speed.y;
			}else {

			}
			
		}
		if (!_mouseDown) {
				_speed.x *= _friction;
				_speed.y *= _friction;
				var ts:Float = .3;
				if (_content.width >= _width) {
					if (  (_content.x > this._x) ) {
						//_tweenX = new Tween(_content, "x", Strong.easeOut, _content.x, this._x, 1, true);
						if (!_innerW) {
							//trace("_innerW");
							_speed.x *= -1;
							_innerW = true;
							//_tweenX = new Tween(_content, "x", Regular.easeInOut, _content.x, this._x, ts, true);
							//_tweenX = getTween("x", _content.x, _x, ts);
							_tweenX = Actuate.tween(_content, ts, { x:_x } ).onComplete(onMotionFinishTweenXInnerW);
							//_tweenX.addEventListener(TweenEvent.MOTION_FINISH, onMotionFinishTweenXInnerW);
						}
						
					}
					if (   ((_content.x + _content.width) < (this._x + this._width))   ) {
						//_tweenX = new Tween(_content, "x", Strong.easeOut, _content.x, _x - (_content.width - this._width), 1, true);
						if (!_innerW) {
							//trace("_innerW");
							_speed.x *= -1;
							_innerW = true;
							//_tweenX = new Tween(_content, "x", Regular.easeInOut, _content.x, _x - (_content.width - this._width), ts, true);
							//_tweenX = getTween("x", _content.x, _x - (_content.width - _width), ts);
							_tweenX = Actuate.tween(_content, ts, { x:_x - (_content.width - _width) } ).onComplete(onMotionFinishTweenXInnerW);
							//_tweenX.addEventListener(TweenEvent.MOTION_FINISH, onMotionFinishTweenXInnerW);
						}
						
					}
				}
				//trace("_content.height > _height",_content.height > _height,_content.height , _height);
				if(_content.height >= _height){
					if (_content.y > this._y) {
						//_tweenY = new Tween(_content, "y", Strong.easeOut, _content.y, this._y, 1, true);
						if (!_innerH) {
							//trace("_innerH");
							_speed.y *= -1;
							_innerH = true;
							//_tweenY = new Tween(_content, "y", Regular.easeInOut, _content.y, this._y, .1, true);
							//_tweenY = getTween("y", _content.y, _y, ts);
							_tweenY = Actuate.tween(_content, ts, { y:_y } ).onComplete(onMotionFinishTweenYInnerH);
							//_tweenY.addEventListener(TweenEvent.MOTION_FINISH, onMotionFinishTweenYInnerH);
						}
					}
					if ((_content.y + _content.height) < (this._y + this._height)) {
						//_tweenY = new Tween(_content, "y", Strong.easeOut, _content.y, _y - (_content.height - this._height), 1, true);
						if (!_innerH) {
							//trace("_innerH");
							_speed.y *= -1;
							_innerH = true;
							//_tweenY = getTween("y", _content.y,  _y - (_content.height - _height), ts);
							_tweenY = Actuate.tween(_content, ts, { y:_y - (_content.height - _height) } ).onComplete(onMotionFinishTweenYInnerH);
							//_tweenY.addEventListener(TweenEvent.MOTION_FINISH, onMotionFinishTweenYInnerH);
						}
					}					
				}
				if(/*!_innerW &&*/  !_constraintH){
					_content.x += _speed.x;
				}
				if(/*!_innerH &&*/ !_constraintV){
					_content.y += _speed.y;	
				}
		}
	}
	
	private function allowMovement():Bool {			
		return ((_speed.x > MIN_SPEED) || (_speed.y > MIN_SPEED) || (_speed.x < -MIN_SPEED) || (_speed.y < -MIN_SPEED)  );
	}
	
	private function onMotionFinishTweenYInnerH(/*e:TweenEvent*/):Void {
		_innerH = false;
	}
	
	private function onMotionFinishTweenXInnerW(/*e:TweenEvent*/):Void {
		_innerW = false;
	}

	private function scaleWidth():Void {
		var ratio:Float = _content.width / _width;
		_content.width /= ratio;
		_content.height /= ratio;		
	}
	
	private function scaleHeight():Void {
		var ratio:Float = _content.height / _height;
		_content.width /= ratio;
		_content.height /= ratio;
	}
	
	private function scaleAuto():Void {
		var containerRatio:Float = _width / _height;
		var contentRatio:Float = _content.width / _content.height;
		var ratio:Float = containerRatio / contentRatio;
		if (ratio > 1) {
			scaleWidth();
		}else {
			scaleHeight();
		}
	}
	
	private function scaleAutoReverse():Void {
		var containerRatio:Float = _width / _height;
		var contentRatio:Float = _content.width / _content.height;
		var ratio:Float = containerRatio / contentRatio;
		if (ratio > 1) {
			scaleHeight();				
		}else {
			scaleWidth();
		}
	}
	
	private function scaleNull():Void {
		_content.width = _originalW;
		_content.height = _originalH;
	}
	
	/* INTERFACE net.absulit.anhx.interfaces.Destroy */
	
	public function destroy():Void {
		if(_content != null){
			_content.removeEventListener(MouseEvent.MOUSE_UP,onMouseUpDrag);
			_content.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDownDrag);
			_content.removeEventListener(MouseEvent.MOUSE_OUT, onMouseUpDrag);
			_content.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveScroll);
			_content.removeEventListener(Event.ENTER_FRAME, onEnterFrameDrag);
			_content = null;
		}
		
		_x = _y = _width = _height = Math.NaN;
		_tweenX = _tweenY = null;
		_scaleState = null;
		_drag = _scroll = _centerV = _centerH = false;

		_mouseDown = false;
		
		
		
		_lastMouseP = null;
		_speed = null;
		_lastSpeed = null;
		_mouseLifted = false;
		_friction = Math.NaN;
	}
	
}

