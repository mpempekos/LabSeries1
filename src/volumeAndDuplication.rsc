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
	
	set[int] dupLines = {};
	int linesOfCode = 0;
	
	loc project = |project://TestProject|;
    //loc project = |project://hsqldb-2.3.1|;
    //loc project = |project://smallsql0.21_src|;
	myProject = getProject(project);
	
	list [str] pureCode = [];
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
						pureCode += myCustomVar.pureLine;
						//println("Pure line is: <myCustomVar.pureLine>");
						linesOfCode += 1;
					}
				}
			}				
		}
    }   
    
    //int allLOC = size(pureCode); //Y THE FUCK U DO DIS??????
    
    println("*** Lines Of Code are <linesOfCode> ****");
    	
	println("ckecking for duplicated code...");	
	//for(int i <- [0..size(pureCode)]) {
	for(int i <- [0..linesOfCode]) {
		if(i notin dupLines) {
			//for(int j <- [i+1..size(pureCode)]) {
			for(int j <- [i+1..linesOfCode]) {				
				if(pureCode[i] == pureCode[j]) {
					//println("equal lines found: <pureCode[i]> == <pureCode[j]>");	
					dupFound = checkFor2EqualBlocks(pureCode, i, j);
					if (dupFound >= 6) {						
						for(int k <- [0..dupFound]) {												
							dupLines = dupLines + (i+k);
							dupLines = dupLines + (j+k);			
						}
						//println("Duplicated lines (so far): <size(dupLines)>/<allLOC> found");
					}
				}			
			}
		}			
	}	
	
	println("number of duplicated lines: <size(dupLines)>");
   	//println("*** Lines Of Code are <allLOC> ****");
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


int checkFor2EqualBlocks(list[str] codeLines, int i, int j) {
	int count = 1;
	for(int k <- [1..size(codeLines)-j]) {								
		if (codeLines[i+k] != codeLines[j+k]) {		
			return count;
		}		
		count = count + 1;
	}
	return count;
}