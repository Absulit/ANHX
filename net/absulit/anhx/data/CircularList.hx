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
import net.absulit.anhx.interfaces.Destroy;

/**
 * Extendeds the Array Class with paging functions and other new methods
 * @author Sebastian Sanabria Diaz
 */
class CircularList implements Destroy {
	
	private var _items:Array<Dynamic>;
	
	private var _item:Dynamic;
	private var _page:Array<Dynamic>;
	private var _pages:Array<Dynamic>;
	private var _numPages:Int;
	private var _numPageItems:Int;
	
	private var _itemIndex:Int;
	private var _pageIndex:Int;
		
	public function new() {
		//super();
		init();
	}
	
	private function init() {
		_items = new Array();
		_item = null;
		_page = null;
		_pages = null;
		_numPages = 0;
		_numPageItems = 0;
		_itemIndex = 0;
		_pageIndex = 0;
	}
	
	private function get_item():Dynamic {
		return this._items[_itemIndex];
	}
	
	private function set_item(value:Dynamic):Dynamic {
		return this._items[_itemIndex] = _item = value;
	}
	
	/**
	 * The current item defined by itemIndex
	 */
	public var item(get_item, set_item):Dynamic;
	
	private function get_pages():Array<Dynamic> {
		return _pages;
	}
	
	private function set_pages(value:Array<Dynamic>):Array<Dynamic> {
		return _pages = value;
	}
	
	/**
	 * Array with pages (each page with items)
	 */
	public var pages(get_pages, set_pages):Array<Dynamic>;
	
	private function get_numPages():Int {
		return _numPages;
	}
	
	private function set_numPages(value:Int):Int {
		_numPages = value;
		//TODO: arreglar esto
		_numPageItems = value;
		_numPages = Std.int(this._items.length / _numPageItems);
		if (this._items.length % _numPageItems != 0){
			_numPages++;
		}		
		return _numPages;
	}
	
	/**
	 * The number of pages stablished by the user
	 */
	public var numPages(get_numPages, set_numPages):Int;
	
	private function get_itemIndex():Int {
		return _itemIndex;
	}
	
	private function set_itemIndex(value:Int):Int {
		_itemIndex = value;
		//TODO:cambiar por _itemIndex = _itemIndex % this.length
		if (_itemIndex > this._items.length - 1) {
			while (_itemIndex > this._items.length - 1) {
				_itemIndex -= this._items.length;
			}
		}else if(_itemIndex < 0){
			while (_itemIndex < 0 && _itemIndex < this._items.length) {
				_itemIndex += this._items.length;
			}
		}			
		//_item = this[_itemIndex];			
		return _itemIndex;
	}
	
	/**
	 * Current item index that can be lower from zero, or greater than length;
	 * the index is self-correcting
	 */
	public var itemIndex(get_itemIndex, set_itemIndex):Int;
	
	private function get_pageIndex():Int {
		return _pageIndex;
	}
	
	private function set_pageIndex(value:Int):Int {
		_pageIndex = value;
		
		if (_pageIndex > _numPages - 1) {
			while (_pageIndex > _numPages- 1) {
				_pageIndex -= _numPages;
			}
		}else if(_pageIndex < 0){
			while (_pageIndex < 0 && _pageIndex < _numPages) {
				_pageIndex += _numPages;
			}
		}
		
		itemIndex = _pageIndex * _numPageItems;

		
		return _pageIndex;
	}
	
	/**
	 * Current page index
	 */
	public var pageIndex(get_pageIndex, set_pageIndex):Int;
	
	private function get_page():Array<Dynamic> {
		_page = new Array();
		var initIndex:Int = _pageIndex * _numPageItems;
		var finalIndex:Int = initIndex + _numPageItems;
		var k:Int = initIndex;
		while (k < finalIndex) {			
			_page.push(this._items[k]);
			k++;
		}
		return _page;
	}
	
	private function set_page(value:Array<Dynamic>):Array<Dynamic> {
		return _page = value;
	}
	/**
	 * The current page defined by pageIndex
	 */
	public var page(get_page, set_page):Array<Dynamic>;
	
	private function get_numPageItems():Int {
		return _numPageItems;
	}
	
	private function set_numPageItems(value:Int):Int {
		_numPageItems = value;
		_numPages = Std.int(this._items.length / _numPageItems);
		if (this._items.length % _numPageItems != 0){
			_numPages++;
		}
		return _numPageItems;
	}
	
	/**
	 * The number of items per page stablished by the user
	 */
	public var numPageItems(get_numPageItems, set_numPageItems):Int;
	
	/**
	 * The next item and updates itemIndex
	 * @return the item in the next position
	 */
	public function next():Dynamic {
		return this._items[++itemIndex];
	}
	
	/**
	 * The previous item and updates itemIndex
	 * @return the item in the previous position
	 */
	public function previous():Dynamic {
		return this._items[--_itemIndex];
	}
	
	/**
	 * Return the first item
	 * @return the item in the first position
	 */
	public function first():Dynamic{
		return this._items[0];
	}
	
	/**
	 * Returns the last item in CircularList
	 * @return the iten in the last position
	 */
	public function last():Dynamic{
		return this._items[this._items.length - 1];
	}
	
	/**
	 * Returns the index of param value
	 * @param	value item to find index
	 * @return -1 if not exists or the index of value
	 */
	public function indexOfItem(value:Dynamic):Int {
		var item:Dynamic;
		var index:Int = -1;
		var k:Int = 0;
		while (k < this._items.length) {
			item = this._items[k];
			if (item == value) {
				index = k;
				break;
			}
			k++;
		}
		return index;
	}
	
	/**
	 * Checks if item already exists in the List
	 * @param	value item to find
	 * @return true if exists
	 */
	public function hasItem(value:Dynamic):Bool {
		var exists:Bool = false;
		var item:Dynamic;
		for (item in this._items) {
			if (item == value) {
				exists = true;
				break;
			}
		}
		
		
		return exists;
	}
	
	/**
	 * 
	 * @param	value
	 * @return
	 */
	public function push(value:Dynamic):Int {
		return _items.push(value);
	}
	
	/* INTERFACE net.absulit.anhx.interfaces.Destroy */
	
	public function destroy():Void {
		_item = null;
		_page = null;
		_pages = null;
		_numPages = 0;
		_numPageItems = 0;
		_itemIndex = 0;
		_pageIndex = 0;
	}
	
	
	
}


