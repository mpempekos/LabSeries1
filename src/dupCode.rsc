module dupCode

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import IO;
import Set;
import List;
import String;
import Map;
import util::Resources;
import unitSizeAndComplexity;

void numbDuplicatedLines() {
	int dupFound = 0;
	set[int] dupLines = {};
	list[str] pureCode = [];
	int i = 1;
			
	//loc project = |project://softEvolTest|;
    loc project = |project://smallsql0.21_src|;
    //loc project = |project://hsqldb-2.3.1|;
	myProject = getProject(project);
	
	println("visiting project...");
	visit (myProject) {		
		case file(loc id): {			
			pureCode += checkIfJavaFile(id);			
			println("<i> files analyzed");
			i+= 1;
		}
    }    
	
	int allLines = size(pureCode);
	
	println("ckecking for duplicated code...");	
	for(int i <- [0..size(pureCode)]) {
		if(i notin dupLines) {
			for(int j <- [i+1..size(pureCode)]) {				
				if(pureCode[i] == pureCode[j]) {
					//println("equal lines found: <pureCode[i]> == <pureCode[j]>");	
					dupFound = checkFor2EqualBlocks(pureCode, i, j);
					if (dupFound >= 6) {						
						for(int k <- [0..dupFound]) {												
							dupLines = dupLines + (i+k);
							dupLines = dupLines + (j+k);			
						}
						println("Duplicated lines (so far): <size(dupLines)>/<allLines> found");
					}
				}			
			}
		}			
	}
	
	println("number of duplicated lines: <size(dupLines)>");
	println("Volume (LOC): <size(pureCode)>");
}

list[str] checkIfJavaFile(loc id) {	
	if (id.path[-4..] == "java")  {		
		list[str] fileLines = readFileLines(id);		
		list[str] linesOfCode = [];			
		for(line <- fileLines) {			
			pureLine = getPureCode(line);
			if (size(pureLine) > 0) linesOfCode += pureLine; 	
		}			
		return linesOfCode;
		return fileLines;
	}
	else return [];
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