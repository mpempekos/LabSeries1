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
	
	int moderateRiskLOC = 0;
	int highRiskLOC = 0;	
	int veryhighRiskLOC = 0;	

	M3 myModel = createM3FromEclipseProject(|project://softEvolTest|);	
	
	myMethods = methods(myModel);
	//println(myMethods);
	list[loc] methodsList = toList(myMethods);
	for(int i <- [0..size(methodsList)]) {
		methodLOC = readFileLines(methodsList[i]);
		int mcc = checkMethodCyclomaticComplexity(methodLOC);
		println("<methodsList[i]> ::::::: <mcc>");
 		
 		if(mcc > 10) {
 			if (mcc > 20) {
 				if (mcc > 50) {
 					veryhighRiskLOC = veryhighRiskLOC + size(methodLOC);
 				}
 				else {
 					highRiskLOC = highRiskLOC + size(methodLOC); 
 				}
			}
			else {
				moderateRiskLOC = moderateRiskLOC + size(methodLOC); 
			}
		}
	}
	
	println("moderateRiskLOC: <moderateRiskLOC>");
	println("highRiskLOC: <highRiskLOC>");
	println("veryhighRiskLOC: <veryhighRiskLOC>");
	
}

/* 
	Cyclomatic Complexity of a Method: Number of decision points + number of logical operators + 1

	decision points: if, if … else, switch , for loop, while loop
	logical operators: || and &&
*/
int checkMethodCyclomaticComplexity(list[str] methodLOC) {
	
	int cc = 1;
	int lo = 0;
	
	for(int i <- [0..size(methodLOC)]) {
		println(methodLOC[i]); 
		// ISSUE: why methodLOC[i] only have some LOC of the method and not all of them?

		if(isIfStatement(methodLOC[i])) {
			cc = cc + 1; 			
			/*lo = countLogicalOperators(methodLOC[i]);
			cc = cc + lo;
			lo = 0;*/			
		}
		
		if(isElseStatement(methodLOC[i])) cc = cc + 1; 
		
		//if(isForLoop(methodLOC[i])) ... 
		
		//if(isWhileLoop(methodLOC[i])) ...
		
		//if(isSwitch(methodLOC[i])) ...
	}
	return cc;
}

bool isIfStatement(str line) {	
	return contains(line, "if(");
}

bool isElseStatement(str line) {	
	return contains(line, "else");
}

list[str] purifyText(list[str] source) {
	list [str] pureList = [];
	bool commentOpened = false;
	singleCommentLines=0;	totalLines =0;	blankLines =0; multiCommentLines =0;
	
	for (i <- source) {
			
		if (commentOpened) {
			if(/^[ \t\r\n]*$/ := i)				// it's a blank line
	 		   blankLines +=1;
	 		else if (/^.*\*\/[\s\t\n]*$/ := i) {	// it's a comment that finishes...
	 			commentOpened = false;
	 			multiCommentLines +=1;
	 		}
	 		else if (/^.*\*\/[\w]*$/ := i)	 {			// it has code...
	 			commentOpened = false;
	 			pureList += i;
	 		}
	 		else  										// comment goes on . . . 
	 			multiCommentLines +=1;
	 	}
	 		
		else if(/^[ \t\r\n]*$/ := i)
	 		blankLines +=1;
	 	
	 	else if (/^.*\*\/[\s\t\n]*$/ := i) {   // pianei ta */
      		multiCommentLines +=1;
	 		//println("Skata1: <i>");
	 	}
	 			
	 	else if (/^[^\w]*\/\*.*\*\/[\s\t\n]*$/ := i) {	// pianei ta /* ... */ xwris kodika profanws
      		multiCommentLines +=1;
	 		//println("Skata2: <i>");
	 	}
	 	
	 	else if (/[\s\t\n]*\/\*[^\*\/]*/ := i) {
	 	//else if  (/^[^\w]*\/\*[^\*\/]*$/ :=  i ) {		// pianei ta /* ...............
	 		commentOpened = true;
	 		multiCommentLines +=1;
	 		//println("coment open!");
	 	}
	 	
	/* 	else if (/^[^\w]*\*[^\*\/[\s\t\n]]*$/ :=  i ) {		// pianei ta * ...
	 		multiCommentLines+=1;
	 		println("skata3: <i>");
	 	}
	 	*/
	 	
	 	else if (/^[^\w]*\*.*\*\/[\s\t\n]*$/ := i) {	// pianei ta * .... */ xwris kodika profanws
      		multiCommentLines +=1;
	 	//	println("Skata4: <i>");
	 	}
	 		
	   	else if(/[\s\t\n]*\/\// := i)	//	--> sigoura lathos		**** ME AYTO VELTIWNETAI TO MIKRO...
      	//else if (/^[^\w}{;]*\/\// := i)		// ---> 24643... seems right but wtf?
      		singleCommentLines +=1;
      	else
      		pureList+= i;
     }
     
     
     comments = singleCommentLines + multiCommentLines;
     linesOfCode = totalLines - (blankLines + comments);
	 return pureList;
}