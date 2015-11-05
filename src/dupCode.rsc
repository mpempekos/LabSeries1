module dupCode

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import IO;
import Set;
import List;
import String;

void DetectDuplicatedCode() {
	M3 myModel = createM3FromEclipseProject(|project://softEvolTest|);	
	list[str] codeLines = code2listLines(myModel);	
	println(codeLines);
	
	//TODO: remove \t from codeLines
	
	int count = 0;	
	int dupFound = 0;
	set[int] lines = {};
	//count = (0 | it + 1 | int i <- [0 .. size(codeLines)], int j <- [i+1..size(codeLines)],  codeLines[i] == codeLines[j]);
	for(int i <- [0..size(codeLines)]) {	
		if(i notin lines) {
			for(int j <- [i+1..size(codeLines)]) {
			//println("<i>, <j>");
				if(codeLines[i] == codeLines[j]) {
					//println("<codeLines[i]> == <codeLines[j]>");			
					count = count + 1;						
					dupFound = checkFor2EqualBlocks(codeLines, i, j);
					//println(dupFound);
					if (dupFound >= 6) {
						for(int k <- [0..dupFound]) {						
							lines = lines + (i+k);				
						}
						//println("<i>,<j>, <dupFound>");								
					}
				}			
			}
		}	
		
		//println("<codeLines[i]>");
	}	
	
	// for those found as duplicated, now check for blocks for each
	//println("number of duplicated lines: <size(lines)>");

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


list[str] code2listLines(M3 model) {
	myClasses = classes(model);
	//println(myClasses);	
	c = toList(myClasses);
	classSrc = readFileLines(c[0]);
	return classSrc;
}


void abc() {
	
	myMethods = methods(myModel);
	//println(myMethods);
	l = toList(myMethods);
	
	
	//println(l[0]);
	methodAST = getMethodASTEclipse(l[0], model=myModel);
	//iprintln(methodAST);
	methodSrc = readFile(l[0]);
	//println(methodSrc);
}

