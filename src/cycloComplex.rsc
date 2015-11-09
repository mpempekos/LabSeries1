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
	
	real moderateRiskLOC = 0.0;
	real highRiskLOC = 0.0;	
	real veryhighRiskLOC = 0.0;
	real moderateRiskLOCPercentage = 0.0;
	real highRiskLOCPercentage = 0.0;	
	real veryhighRiskLOCPercentage = 0.0;	
	real allLOC = 0.0;	
	
	str complexityRating = "?";

	//M3 myModel = createM3FromEclipseProject(|project://softEvolTest|);	
	M3 myModel = createM3FromEclipseProject(|project://smallsql0.21_src|);
	
	myMethods = methods(myModel);
	//println(myMethods);
	list[loc] methodsList = toList(myMethods);
	for(int i <- [0..size(methodsList)]) {
		methodLines = readFileLines(methodsList[i]);
		
		list[str] methodLOC = getLOC(methodLines);
		
		allLOC += size(methodLOC);
		
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
	
	moderateRiskLOCPercentage = (moderateRiskLOC / allLOC) * 100;
	highRiskLOCPercentage = (highRiskLOC / allLOC) * 100;	
	veryhighRiskLOCPercentage = (veryhighRiskLOC / allLOC) * 100;
	
	println("moderateRiskLOCPercentage: <moderateRiskLOCPercentage>");
	println("highRiskLOCPercentage: <highRiskLOCPercentage>");
	println("veryhighRiskLOCPercentage: <veryhighRiskLOCPercentage>");
	
	if(moderateRiskLOCPercentage <= 25 && highRiskLOCPercentage == 0 && veryhighRiskLOCPercentage == 0) {
		complexityRating = "++";
	}
	
	else if(moderateRiskLOCPercentage <= 30 && highRiskLOCPercentage <= 5 && veryhighRiskLOCPercentage == 0) {
		complexityRating = "+";
	}
	
	else if(moderateRiskLOCPercentage <= 40 && highRiskLOCPercentage <= 10 && veryhighRiskLOCPercentage == 0) {
		complexityRating = "0";
	}
	
	else if(moderateRiskLOCPercentage <= 50 && highRiskLOCPercentage <= 15 && veryhighRiskLOCPercentage <= 5) {
		complexityRating = "-";
	}
	
	else {
		complexityRating = "--";
	}
	
	println("Complexity rating: <complexityRating>");	
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

		if(isIfStatement(methodLOC[i])) {
			cc = cc + 1; 			
			/*lo = countLogicalOperators(methodLOC[i]);
			cc = cc + lo;
			lo = 0;*/			
		}
		
		if(isElseStatement(methodLOC[i])) cc = cc + 1; 
		
		//if(isForLoop(methodLOC[i])) cc = cc + 1; 
		
		//if(isWhileLoop(methodLOC[i])) cc = cc + 1; 
		
		//if(isSwitch(methodLOC[i])) cc = cc + 1; 
		
	}
	return cc;
}

bool isIfStatement(str line) {	
	return contains(line, "if(");
}

bool isElseStatement(str line) {	
	return contains(line, "else");
}

list[str] getLOC(list[str] source) {
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