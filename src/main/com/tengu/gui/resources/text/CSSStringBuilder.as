package com.tengu.gui.resources.text
{
	public class CSSStringBuilder
	{
		public static function wrapInTag (text:String, tag:String, paramString:String = ""):String
		{
			if (paramString.length > 0 && paramString.charAt(0) != " ")
			{
				paramString = " " + paramString;
			}
			return "<" + tag + paramString + ">" + text + "</" + tag + ">";
		}
		
		public static function createSpan (text:String, className:String):String
		{
			if (className.charAt(0) == ".")
			{
				className = className.substr(1);
			}
			return wrapInTag(text, "span", "class='" + className + "'");
		}
		
		private var body:String = "";
		
		public function CSSStringBuilder()
		{
			//Empty
		}
		
		public function clear ():void
		{
			body = "";
		}
		
		public function add (text:String, className:String = null, tagName:String = null):void
		{
			if (className != null)
			{
				body += createSpan(text, className);
			}
			else if (tagName != null)
			{
				body += wrapInTag(text, tagName);
			}
			else
			{
				body += text;
			}
		}
		
		public function wrapIn (tag:String, className:String = null):void
		{
			var params:String = "";
			if (className != null)
			{
				params = 'class="' + className + '"';
			}
			body = wrapInTag(body, tag, params);
		}
		
		public function toString ():String
		{
			return body;
		}
	}
}