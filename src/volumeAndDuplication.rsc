module volumeAndDuplication

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
	
	//loc project = |project://softEvolTest|;
    //loc project = |project://hsqldb-2.3.1|;
    loc project = |project://smallsql0.21_src|;
	myProject = getProject(project);
	
	list [str] pureCode = [];
	myCustomVar = customVarInit("","",false); 

	println("visiting project...");
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
						linesOfCode += 1;
					}
				}
			}				
		}
    }          
    
    println("*************");
	println("VOLUME METRIC");
	println("*************");
    
    println("LOC: <linesOfCode>");
    println("Volume rating:<getVolumeRating(linesOfCode)> ");    
	println("ckecking for duplicated code...");	
	println("Duplicated lines (so far): <size(dupLines)>/<linesOfCode> found");	
	for(int i <- [0..linesOfCode]) {
		if(i notin dupLines) {			
			for(int j <- [i+1..linesOfCode]) {				
				if(pureCode[i] == pureCode[j]) {					
					dupFound = checkFor2EqualBlocks(pureCode, i, j, linesOfCode);
					if (dupFound >= 6) {						
						for(int k <- [0..dupFound]) {												
							dupLines += (i+k);
							dupLines += (j+k);			
						}
						println("Duplicated lines (so far): <size(dupLines)>/<linesOfCode> found | i:<i>, j:<j>");
					}
				}			
			}
		}			
	}	
	
	real duplicatedLOC = size(dupLines) + 0.0;	
	
	println("******************");
	println("DUPLICATION METRIC");
	println("******************");	
	
	println("Number of duplicated lines: <duplicatedLOC>"); 
	println("Percentage of duplicated lines: <(duplicatedLOC / linesOfCode) * 100>%"); 
	println("Duplication rating:<getDuplicationRating(linesOfCode, duplicatedLOC)> "); 	
	  	
   	println("*************");
	println("VOLUME METRIC");
	println("*************");
    
    println("LOC: <linesOfCode>");
    println("Volume rating:<getVolumeRating(linesOfCode)> ");
}

str getDuplicationRating (int linesOfCode, real duplicatedLOC) {
	
	real percentage = (duplicatedLOC / linesOfCode)*100;
	
	if (percentage <= 3)
		return "++";
		
	else if (percentage <= 5)
		return "+";
		
	else if (percentage <= 10)
		return "o";		
		
	else if (percentage <= 20)
		return "-";
		
	else return "--";
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
			
			//var.pureLine += var.line[..findFirst(var.line,"//")];
			var.line = var.line[..findFirst(var.line,"//")];
			var.pureLine += getPureCode(var).pureLine;
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

str getVolumeRating(int linesOfCode) {
	if (linesOfCode < 66000)
		return "++";
		
	else if (linesOfCode < 246000)
		return "+";
		
	else if (linesOfCode < 665000)
		return "o";		
		
	else if (linesOfCode < 1310000)
		return "-";
		
	else return "--";
}


int checkFor2EqualBlocks(list[str] codeLines, int i, int j, int linesOfCode) {
	int count = 1;
	for(int k <- [1..linesOfCode-j]) {								
		if (codeLines[i+k] != codeLines[j+k]) {		
			return count;
		}		
		count = count + 1;
	}
	return count;
}