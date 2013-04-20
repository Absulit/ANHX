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

package net.absulit.anhx.util;
import nme.geom.Point;

class MathUtil {
	
	public static function isBetween(number:Float,minimum:Float, maximum:Float):Bool {
		return ((maximum <= number) && (number >= minimum));
	}
	
	public static function distance(p1:Point,p2:Point):Float{
		 var dist:Float;
		 var dx:Float; 
		 var dy:Float;
		 dx = p2.x - p1.x;
		 dy = p2.y - p1.y;
		 dist = Math.sqrt(dx * dx + dy * dy);
		 return dist;
	}
	public static  function angle(p1:Point,p2:Point):Float {
		var dx:Float = p1.x - p2.x;
		var dy:Float = p1.y - p2.y;
		var radians:Float = Math.atan2(dy, dx);
		return degrees(radians);
	}
		
	public static  function degrees(radians:Float):Float {
		return radians * 180 / Math.PI;
	}
		
	public static  function radians(degrees:Float):Float {
		return degrees * Math.PI / 180;
	}
		
	public static  function vector(distance:Float, angle:Float):Point {
		var rads:Float = radians(angle);
		var newPoint:Point = Point.polar(distance, rads);
		return newPoint;
	}
	
	/*public static function normal(x:Number, y:Number, z:Number):Number {
		//*para lo primero, lo q recuerdo es q si tnés 3 puntos en el plano, digamos A, B y C, usas vectores u=AB y v= AC y para encontrar la normal haces N = uxv
		return (z - y)*(x - y);
	}*/		
}

