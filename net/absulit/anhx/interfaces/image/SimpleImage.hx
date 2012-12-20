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
import nme.display.Bitmap;
import nme.display.DisplayObject;
import nme.display.DisplayObject;
import nme.display.Loader;
import nme.display.MovieClip;
import nme.events.Event;
import nme.events.IOErrorEvent;
import nme.events.ProgressEvent;
import nme.events.SecurityErrorEvent;
import nme.net.URLRequest;
/**
 * ...
 * @author Sebastian Sanabria Diaz
 */

class SimpleImage extends MovieClip {
	private var _path:String;
	private var _smoth:Bool;
	private var _loader:Loader;
	private var _content:DisplayObject;
	private var _loadComplete:Bool;
	
	public function new() {
		super();
		init();
	}
	
	private function init():Void {
		
	}
	
	private function get_path():String {
		return _path;
	}
	
	private function set_path(value:String):String {
		while (numChildren > 0) {
			removeChildAt(0);
		}
		_path = value;
		_loadComplete = false;
		_loader = new Loader();
		_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteContentLoaderInfo);
			_loader.contentLoaderInfo.addEventListener(Event.INIT, onInitContentLoaderInfo);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressContentLoaderInfo);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorContentLoaderInfo);
			_loader.contentLoaderInfo.addEventListener(Event.OPEN, onOpenContentLoaderInfo);
			_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorContentLoaderInfo);
		
		_loader.load(new URLRequest(_path));
		
		return _path;
	}
	
		private function onSecurityErrorContentLoaderInfo(e:SecurityErrorEvent):Void {
			//security listener is removed at onCompleteContentLoaderInfo
			dispatchEvent(e);
		}
		
		private function onOpenContentLoaderInfo(e:Event):Void {
			e.target.removeEventListener(Event.OPEN, onOpenContentLoaderInfo);
			dispatchEvent(e);
		}
		
		private function onIOErrorContentLoaderInfo(e:Event):Void {
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorContentLoaderInfo);
			dispatchEvent(e);
		}
		
		private function onProgressContentLoaderInfo(e:ProgressEvent):Void {
			//progress listener is removed at onCompleteContentLoaderInfo
			dispatchEvent(e);
		}
		
		private function onInitContentLoaderInfo(e:Event):Void {
			e.target.removeEventListener(Event.INIT, onInitContentLoaderInfo);
			dispatchEvent(e);
		}
		
		private function onCompleteContentLoaderInfo(e:Event):Void {
			e.target.removeEventListener(Event.COMPLETE, onCompleteContentLoaderInfo);
			e.target.removeEventListener(ProgressEvent.PROGRESS, onProgressContentLoaderInfo);
			e.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorContentLoaderInfo);
			_content = _loader.content;
			/*if (_path.indexOf(".swf") == -1) {
				nme.display.Bitmap(_content).smoothing = _smooth;
			}*/
			addChild(_content);
			//addChild(_loader);
			//_loader = null;
			_loadComplete = true;
			dispatchEvent(e);
		}
	
	public var path(get_path, set_path):String;
	
	private function get_content():DisplayObject {
		return _content;
	}
	
	public var content(get_content, null):DisplayObject;
	
	private function get_smoth():Bool {
		return _smoth;
	}
	
	private function set_smoth(value:Bool):Bool {
		return _smoth = value;
	}
	
	public var smoth(get_smoth, set_smoth):Bool;
	
}