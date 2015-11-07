module cycloComplex

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import IO;
import Set;
import List;
import String;

import dupCode;



void checkCyclomaticComplexity() {

	M3 myModel = createM3FromEclipseProject(|project://softEvolTest|);		
}

/* 
	Cyclomatic Complexity per Method: Number of decision points + number of logical operators + 1

	decision points: if, if … else, switch , for loop, while loop
	logical operators: || and &&
*/
int checkMethodCyclomaticComplexity(list[str] methodLOC) {
	
	int cc = 1;
	
	for(int i <- [0..size(methodLOC)]) {
		if(isIfStatement(methodLOC[i])) cc = cc + 1; 
	}
	return cc;
}