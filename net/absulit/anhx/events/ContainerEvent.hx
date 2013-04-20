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


package net.absulit.anhx.events;
import nme.events.Event;

/**
 * ...
 * @author Sebastian Sanabria Diaz
 */

class ContainerEvent extends Event{

	public static var START_DRAG:String = "startDrag";
	public static var STOP_DRAG:String = "stopDrag";
	
	public function new(type : String, bubbles: Bool = false, cancelable: Bool = false) { 
		super(type, bubbles, cancelable);
	}
	
	override public function clone():Event {
		return new ContainerEvent(type, bubbles, cancelable);
	}
	
	#if flash
	override public function toString():String {
		return formatToString("ContainerEvent", "type", "bubbles", "cancelable", "eventPhase"); 
	}
	#end
}