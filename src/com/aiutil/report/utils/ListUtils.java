package com.aiutil.report.utils;

import java.util.Iterator;
import java.util.List;
import java.util.Map;

public class ListUtils {
	/**
	 * list的toString方法
	 */
	public static void listToString(List<Map<String, Object>> list){
		if(list.size() > 0){
			Iterator<Map<String, Object>> itr = list.iterator();
			while(itr.hasNext()){
				Map<String, Object> map = (Map<String, Object>) itr.next();
				for(Map.Entry<String, Object> entry:map.entrySet()){
					System.out.println("key======="+entry.getKey()+"         value========"+entry.getValue());
				}
			}
		}
	}
}
