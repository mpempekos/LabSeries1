module finalVolume

import util::Resources;
import IO;
import List;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import String;
import Set;

/*** @Andre...So far works pretty nice and i like it...take a look...
so far it's ok for simple cases, as u asked...recursion works ok if u have an open comment,
and also works ok to catch an empty line or a single line comment... 2nd boolean is not
needed...all we have to do in the main method is to check if the string returned is
empty or not....the method will be completed tomorrow....;)
***/


data CustomVar = customVarInit(str line,str pureLine, bool isCommentOpened);


CustomVar getPureCode (CustomVar var) {
	
	//int a; /* ****/   int b; 
	
	if (var.isCommentOpened) {
		
		if (/\*\// := var.line) {		// comment is terminated in this line
			var.line = var.line[findFirst(var.line,"*/")+2..];
			var.isCommentOpened = false;
			return getPureCode(var);	
		}
		
		else 
			return var ;
		
	}
	
	
	else {		// no open comment...
	
		if(/^[ \t\r\n\s]*$/ := var.line)	// blank line//
			return var;
			
		else if (/^[\t\r\n\s]*[\/\/]/ := var.line)	// single comment//
			return ("":commentOpened);
			
		else if (/\/\*/ := var.line) {				// a comment opens
			
			var.pureLine += var.line[..findFirst(var.line,"/*")];
			var.isCommentOpened = true;
			var.line = var.line[findFirst(var.line,"/*")+2..];
			return getPureCode(var);
		}
			
		else 	// so far so good.....
			return var;
	}
}