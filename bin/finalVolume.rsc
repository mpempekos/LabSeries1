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

map[str,bool] getPureCode (map[str,bool] args) {
	commentOpened = head ([args[k] | k <- args]);
	line = head( [k| _:k <- args]);
	//println("I have string <line> and bool <commentOpened>");
	
	if (commentOpened) {
		
		if (/\*\// := line) {		// comment is terminated in this line
		
			line = line[findFirst(line,"*/")+2..];
			commentOpened = false;
			return getPureCode((line:commentOpened));	
		}
		
		else 
			return ("":commentOpened);
		
	}
	
	else {		// no open comment...
	
		if(/^[ \t\r\n\s]*$/ := line)	// blank line
			return ("":commentOpened);
			
		else if (/^[\t\r\n\s]*[\/\/]/ := line)	// single comment
			return ("":commentOpened);
			
		else 
			return (line:commentOpened);	// for now just return line...
	}
}