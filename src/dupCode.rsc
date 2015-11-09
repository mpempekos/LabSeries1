module dupCode

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import IO;
import Set;
import List;
import String;

// currently being tested with project "softEvolTest"

list[str] myReplace(list[str] codeLines) {
	finalList = [];
	for (i <- codeLines) {
		finals = replaceAll(i,"\t","");
		finals = replaceAll(finals," ","");
		finalList += finals; 
	}
	
	return finalList;
}
void numbDuplicatedLines() {
	int dupFound = 0;
	set[int] dupLines = {};
		
	//M3 myModel = createM3FromEclipseProject(|project://softEvolTest|);	
	M3 myModel = createM3FromEclipseProject(|project://TestProject|);	
	list[str] codeLines = code2listLines(myModel);
	//println("Here <codeLines>");
	finalList = myReplace(codeLines);
	
	//println("Final list: <finalList>");
	
	//TODO: remove \t from codeLines
	
	for(int i <- [0..size(codeLines)]) {	
		if(i notin dupLines) {
			for(int j <- [i+1..size(codeLines)]) {
				//println("<codeLines[i]>, <codeLines[j]>");
				if(codeLines[i] == codeLines[j]) {
					println("<i> and <j>");												
					dupFound = checkFor2EqualBlocks(finalList, i, j);
					//println(dupFound);
					if (dupFound >= 6) {
						for(int k <- [0..dupFound]) {												
							dupLines = dupLines + (i+k);				
						}
						//println("<i>,<j>, <dupFound>");								
					}
				}			
			}
		}			
		//println("<codeLines[i]>");
	}	
	println("number of duplicated lines: <size(dupLines)>");

}

int checkFor2EqualBlocks(list[str] codeLines, int i, int j) {
	//println("Found 2 equal lines");
	//println("i is <i> and j is <j>");
	//println("Equal lines are <codeLines[i]> and <codeLines[j]>");
	int count = 1;
	println("i is <i> and j is <j>");
	for(int k <- [1..size(codeLines)-j]) {	
		iprintln("<codeLines[i+k]> kai <codeLines[j+k]>");
		if (codeLines[i+k] != codeLines[j+k]) {
			return count;
		}		
		println("Found another line!");
		count = count + 1;
	}
	return count;
}


list[str] code2listLines(M3 model) {
	myClasses = classes(model);
	//println(myClasses);	
	c = toList(myClasses);
	
	/* ineseert a lloop */
	classSrc = readFileLines(c[1]); // WARNING: JUST RETURNIG FIRST CLASS
	//println("Here2: <classSrc>");
	return classSrc;
}

/*
void abc() {
	
	myMethods = methods(myModel);
	//println(myMethods);
	l = toList(myMethods);
	
	
	//println(l[0]);
	methodAST = getMethodASTEclipse(l[0], model=myModel);
	//iprintln(methodAST);
	methodSrc = readFile(l[0]);
	//println(methodSrc);
} */

