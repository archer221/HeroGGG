package com.ui.drag {

	/**
	 * Inteface Drag Item
	 * 
	 * @author Cafe
	 * @version 20100630
	 */
	public interface IDragItem {
		
		function get name() : String;

		function get count() : int;

		function get max() : int;

		function get place() : int;

		function get gird() : int;
		
		function canmerge(target : IDragItem, count : int) : Boolean;

		function syncMove(s_place : int,s_gird : int,t_place : int,t_gird : int,bSplit : Boolean = false,splitCount : int = 0) : void;

		function syncRemove(count : int = 0, isUse : Boolean = false) : void;
		
		function beginRemove(slabel : String);
	}
}