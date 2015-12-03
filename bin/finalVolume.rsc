module finalVolume

import util::Resources;
import IO;
import List;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import String;
import Set;


data CustomVar = customVarInit(str line,str pureLine, bool isCommentOpened);

void countLines() {
	loc project = |project://TestProject2|;
    //loc project = |project://hsqldb-2.3.1|;
    //loc project = |project://smallsql0.21_src|;
	myProject = getProject(project);
	
	linesOfCode = 0;
	myCustomVar = customVarInit("","",false); 

	visit (myProject) {
		case file(loc id): {
		
				if (id.path[-4..] == "java") {
					sourceCode = readFileLines(id);
					
					for(i <- sourceCode) {
					
						myCustomVar.line = i;
						myCustomVar.pureLine = "";
						myCustomVar = getPureCode(myCustomVar);
						
						if (!isEmpty(myCustomVar.pureLine)) {
							linesOfCode += 1;
							println("Pure line is: <myCustomVar.pureLine>");
						}
					}
				}
				
		}
   }
   println("*** Lines Of Code are <linesOfCode> ****");
}

str replaceTabsSpaces(str line) {
		tabsRemoved = replaceAll(line,"\t","");
		spacesRemoved = replaceAll(tabsRemoved," ","");
		return spacesRemoved; 
}

CustomVar getPureCode (CustomVar var) {
	
	//int a; /* ****/   int b; 	//////////// /* //     */
	
	if (var.isCommentOpened) {
		
		if (/\*\// := var.line) {		// comment is terminated in this line
			var.line = var.line[findFirst(var.line,"*/")+2..];
			var.isCommentOpened = false;
			return getPureCode(var);	
		}
		
		else {
			var.pureLine = replaceTabsSpaces(var.pureLine);
			return var ;
		}
		
	}
	
	
	else {		// no open comment...
		
		if(/^[ \t\r\n\s]*$/ := var.line) {	// blank line
			var.pureLine = replaceTabsSpaces(var.pureLine);
			return var;
		}
			
		else if (/^[\t\r\n\s]*\/\// := var.line) {	// single comment in the beginning
			var.pureLine = replaceTabsSpaces(var.pureLine);
			return var;
		}
			
		else if (/\/\// := var.line) {				// single comment somewhere in the middle
			var.pureLine += var.line[..findFirst(var.line,"//")];
			var.pureLine = replaceTabsSpaces(var.pureLine);
			return var;
		}
			
		else if (/\/\*/ := var.line) {				// a comment opens
			
			var.pureLine += var.line[..findFirst(var.line,"/*")];
			var.isCommentOpened = true;
			var.line = var.line[findFirst(var.line,"/*")+2..];
			return getPureCode(var);
		}
			
		else { 	// so far so good.....
			var.pureLine += var.line;
			var.pureLine = replaceTabsSpaces(var.pureLine);
			return var;
		}
	}
	
}