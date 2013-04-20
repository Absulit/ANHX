package net.absulit.anhx.layouts;
import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.actuators.GenericActuator;
import nme.display.DisplayObject;
import nme.display.Stage;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.events.Event;

/**
 * ...
 * @author Sebastian Sanabria Diaz
 */

class LiquidLayoutObject {
	private var _target:DisplayObject;
	private var _alignment:String;
	private var _delay:Float;
	private var _stage:Stage;
	//private var _originalX:Float;
	//private var _originalY:Float;
	private var _ratioX:Float;
	private var _ratioY:Float;
	private var _tweenX:IGenericActuator;
	private var _tweenY:IGenericActuator;
	
	public function new(target:DisplayObject, align:String = "none", delay:Float = 2) {
			_target = target;
			_alignment = align;
			_delay = delay;
			_stage = _target.stage;

			if (_stage != null) {
				init();
			}else {
				_stage.addEventListener(Event.ADDED_TO_STAGE, init);
			}
	}
	
	private function init(e:Event = null):Void {
		_stage.removeEventListener(Event.ADDED_TO_STAGE, init);

		if (_stage.scaleMode != StageScaleMode.NO_SCALE) {
			_stage.scaleMode = StageScaleMode.NO_SCALE;
		}
		if (_stage.align != StageAlign.TOP_LEFT) {
			_stage.align = StageAlign.TOP_LEFT;
		}
		_ratioX = _target.x / _stage.stageWidth;
		_ratioY = _target.y / _stage.stageHeight;
		assignAlign();
		
	}
	
	private function onActivate(e:Event):Void {
		align();
	}
	
	private function onResize(e:Event):Void {
		align();
	}
	
	private function onDeactivate(e:Event):Void {
		align();
	}
	
	public function align():Void {
		switch (_alignment)	{
			case LiquidLayoutAlign.TOP:				top();
			case LiquidLayoutAlign.BOTTOM:			bottom(); 
			case LiquidLayoutAlign.RIGHT:			right();
			case LiquidLayoutAlign.LEFT:			left();
			case LiquidLayoutAlign.CENTER:			center();
			case LiquidLayoutAlign.TOP_CENTER:		topCenter();
			case LiquidLayoutAlign.BOTTOM_CENTER:	bottomCenter();
			case LiquidLayoutAlign.TOP_RIGHT:		topRight();
			case LiquidLayoutAlign.TOP_LEFT:		topLeft();
			case LiquidLayoutAlign.BOTTOM_RIGHT:	bottomRight();
			case LiquidLayoutAlign.BOTTOM_LEFT:		bottomLeft();
			case LiquidLayoutAlign.FLOAT:			float();
			case LiquidLayoutAlign.VERTICAL:		vertical();
			case LiquidLayoutAlign.HORIZONTAL:		horizontal();
			case LiquidLayoutAlign.NONE:			none();
				
			//default:
		}

	}
	
		private function top():Void {
			//_tweenY = new Tween(_target, "y", Strong.easeOut, _target.y, 0, _delay, true);
			_tweenY = Actuate.tween(_target, _delay, {y:0});
			//Actuate.tween(_target, _delay, {y:0});
		}
		
		private function bottom():Void {
			//_tweenY = new Tween(_target, "y", Strong.easeOut, _target.y, _stage.stageHeight - _target.height, _delay, true);
			_tweenY = Actuate.tween(_target, _delay, {y:_stage.stageHeight - _target.height});
			//Actuate.tween(_target, _delay, {y:_stage.stageHeight - _target.height});
		}
		
		private function right():Void {
			//_tweenX = new Tween(_target, "x", Strong.easeOut, _target.x, _stage.stageWidth - _target.width, _delay, true);
			_tweenX = Actuate.tween(_target, _delay, {x:_stage.stageWidth - _target.width});
			//Actuate.tween(_target, _delay, {x:_stage.stageWidth - _target.width});

		}
		
		private function left():Void {
			//_tweenX = new Tween(_target, "x", Strong.easeOut, _target.x, 0, _delay, true);
			_tweenX = Actuate.tween(_target, _delay, {x:0});
			//Actuate.tween(_target, _delay, {x:0});
			
		}
		
		private function center():Void {
			vertical(); horizontal();
		}
		
		private function topCenter():Void {
			center();
			top();
		}
		
		private function bottomCenter():Void {
			center();
			bottom();
		}
		
		private function topRight():Void {
			top(); right();
		}
		
		private function topLeft():Void{
			top(); left();
		}
		
		private function bottomRight():Void {
			bottom(); right();
		}
		
		private function bottomLeft():Void {
			bottom(); left();
		}
		
		private function float():Void {
			//_tweenX = new Tween(_target, "x", Strong.easeOut, _target.x, (_ratioX * _stage.stageWidth), _delay, true);
			_tweenX = Actuate.tween(_target, _delay, {x:(_ratioX * _stage.stageWidth)});
			//Actuate.tween(_target, _delay, {x:(_ratioX * _stage.stageWidth)});
			//_tweenY = new Tween(_target, "y", Strong.easeOut, _target.y, (_ratioY * _stage.stageHeight), _delay, true);
			_tweenY = Actuate.tween(_target, _delay, {y:(_ratioY * _stage.stageHeight)});
			//Actuate.tween(_target, _delay, {y:(_ratioY * _stage.stageHeight)});
		}
		
		private function vertical():Void {
			var pY:Float = (_stage.stageHeight - _target.height) / 2;
			//_tweenY = new Tween(_target, "y", Strong.easeOut, _target.y, pY, _delay, true);
			_tweenY = Actuate.tween(_target, _delay, {y:pY});
			//Actuate.tween(_target, _delay, {y:pY});
		}
		
		private function horizontal():Void {
			var pX:Float = (_stage.stageWidth - _target.width) / 2;
			//_tweenX = new Tween(_target, "x", Strong.easeOut, _target.x, pX, _delay, true);
			_tweenX = Actuate.tween(_target, _delay, {x:pX});
			//Actuate.tween(_target, _delay, {x:pX});
		}
		
		private function none():Void {
			
		}
		
		private function assignAlign():Void {
			/*try {
				_stage.removeEventListener(Event.ACTIVATE, onActivate);
				_stage.removeEventListener(Event.RESIZE, onResize);
				_stage.removeEventListener(Event.DEACTIVATE, onDeactivate);
			}catch (err:Error){

			}*/
			if (_alignment != LiquidLayoutAlign.NONE) {
				_stage.addEventListener(Event.ACTIVATE, onActivate);
				_stage.addEventListener(Event.RESIZE, onResize);
				_stage.addEventListener(Event.DEACTIVATE, onDeactivate);
				align();
			}
		}
		
		private function get_target():DisplayObject {
			return _target;
		}
		
		private function set_target(value:DisplayObject):DisplayObject {
			return _target = value;
		}
		
		public var target(get_target, set_target):DisplayObject;
		
		private function get_alignment():String {
			return _alignment;
		}
		
		private function set_alignment(value:String):String {
			return _alignment = value;
		}
		
		/**
		 * Defined by LiquidLayoutAlign constants
		 */
		public var alignment(get_alignment, set_alignment):String;
		
		private function get_delay():Float {
			return _delay;
		}
		
		private function set_delay(value:Float):Float {
			return _delay = value;
		}
		
		public var delay(get_delay, set_delay):Float;
	
	
	
	
	
	
	
	
}