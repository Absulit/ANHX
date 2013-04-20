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

package net.absulit.anhx.data;
import nme.system.Capabilities;

/**
 * Handles pixel convertion between screens devices
 * @author Sebastian Sanabria Diaz
 */

class DPIManager {
	private static var _instance:DPIManager;
	private var _baseDPI:Float;
	private var _ratio:Float;
	public function new(pvt:SingletonEnforcer) {
		init();
	}
	
	private function init() {
		_baseDPI = 72;
		_ratio = _baseDPI / Capabilities.screenDPI;
		Lib.trace("Current DPI", Capabilities.screenDPI);
	}
	
	private function get_instance():DPIManager {
		if ( _instance == null ) {
			_instance = new DPIManager( new SingletonEnforcer() );
		}
		return _instance;
	}
	
	static public var instance(get_instance, null):DPIManager;
	
	private function get_baseDPI():Float {
		return _baseDPI;
	}
	
	private function set_baseDPI(value:Float):Float {
		_baseDPI = value;
		_ratio = _baseDPI / Capabilities.screenDPI;
		return _baseDPI;
	}
	
	public var baseDPI(get_baseDPI, set_baseDPI):Float;
	
	public function ratio(value:Float):Float {
		return value / _ratio;
	}
	
	public function recalibratePxls(value:Float):Float {
		return inToPxls( pxlsToIn(value) );
	}
	
	public function pxlsToIn(value:Float):Float {
		return (value / _baseDPI);
	}
	
	public function inToPxls(value:Float):Float {	
		return Capabilities.screenDPI * value;
	}
	
	public function cmToPxls(value:Float):Float {
		return Capabilities.screenDPI * (value * 0.3937);
	}

	
}

private class SingletonEnforcer{}