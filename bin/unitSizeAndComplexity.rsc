module unitSizeAndComplexity

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import analysis::m3::AST;
import IO;
import Set;
import List;
import String;

void checkUnitSizeANDcheckCyclomaticComplexity() {
	real us_moderateRiskLOC = 0.0;
	real us_highRiskLOC = 0.0;	
	real us_veryhighRiskLOC = 0.0;
	real cc_moderateRiskLOC = 0.0;
	real cc_highRiskLOC = 0.0;	
	real cc_veryhighRiskLOC = 0.0;	
	real allLOC = 0.0;	
	str unitSizeRating = "?";	
	str complexityRating = "?";	

	println("creating M3 model...");
	M3 myModel = createM3FromEclipseProject(|project://smallsql0.21_src|);	
	//M3 myModel = createM3FromEclipseProject(|project://hsqldb-2.3.1|);
	println("M3 model created");		
	myMethods = methods(myModel);		
	list[loc] methodsLocs = toList(myMethods);
	
	int totalNumbMethods = size(methodsLocs);
	int currentAnalizedMethod = 0;
	
	for(loc methodLoc <- methodsLocs) {	
		println("Analyzed <currentAnalizedMethod> out of <totalNumbMethods> methods");				
		methodLines = readFileLines(methodLoc);	
		
		list[str] methodLOC = [];			
		for(line <- methodLines) {		
			pureLine = getPureCode(line);
			if (size(pureLine) > 0) methodLOC += pureLine; 	
		}		
				
		allLOC += size(methodLOC);	
		
		// Unit Size Metric
		methodSize = size(methodLOC);				
 		
 		if(methodSize > 20) {
 			if (methodSize > 50) {
 				if (methodSize > 100) {
 					us_veryhighRiskLOC += methodSize;
 				}
 				else {
 					us_highRiskLOC += methodSize;
 				}
			}
			else {
				us_moderateRiskLOC += methodSize; 
			}
		}		
		
		// Complexity Metric
		mcc = checkMethodCyclomaticComplexity(getMethodASTEclipse(methodLoc, model=myModel));		
 		
 		if(mcc > 10) {
 			if (mcc > 20) {
 				if (mcc > 50) {
 					cc_veryhighRiskLOC += size(methodLOC);
 				}
 				else {
 					cc_highRiskLOC += size(methodLOC); 
 				}
			}
			else {
				cc_moderateRiskLOC += size(methodLOC); 
			}
		}
		currentAnalizedMethod += 1;
	}
	
	println("allLOC: <allLOC>");	
	
	println("****************");
	println("UNIT SIZE METRIC");
	println("****************");
	
	println("us_moderateRiskLOC: <us_moderateRiskLOC>");
	println("us_highRiskLOC: <us_highRiskLOC>");
	println("us_veryhighRiskLOC: <us_veryhighRiskLOC>");
	
	unitSizeRating = calculateRating(us_moderateRiskLOC, us_highRiskLOC, us_veryhighRiskLOC, allLOC);
	println("Unit size rating: <unitSizeRating>");	
	
	println("*****************");
	println("COMPLEXITY METRIC");
	println("*****************");
	
	println("cc_moderateRiskLOC: <cc_moderateRiskLOC>");
	println("cc_highRiskLOC: <cc_highRiskLOC>");
	println("cc_veryhighRiskLOC: <cc_veryhighRiskLOC>");	
	
	complexityRating = calculateRating(cc_moderateRiskLOC, cc_highRiskLOC, cc_veryhighRiskLOC, allLOC);	
	println("Cyclomatic Complexity rating: <unitSizeRating>");	
}

str calculateRating(real moderateRiskLOC, real highRiskLOC, real veryhighRiskLOC, real allLOC) {
	str rating = "?";

	moderateRiskLOCPercentage = (moderateRiskLOC / allLOC) * 100;
	highRiskLOCPercentage = (highRiskLOC / allLOC) * 100;	
	veryhighRiskLOCPercentage = (veryhighRiskLOC / allLOC) * 100;
	
	println("moderateRiskLOCPercentage: <moderateRiskLOCPercentage>");
	println("highRiskLOCPercentage: <highRiskLOCPercentage>");
	println("veryhighRiskLOCPercentage: <veryhighRiskLOCPercentage>");	
	
	if(moderateRiskLOCPercentage <= 25 && highRiskLOCPercentage <= 0.0000000000001 && veryhighRiskLOCPercentage <= 0.0000000000001) {
		rating = "++";
	}
	
	else if(moderateRiskLOCPercentage <= 30 && highRiskLOCPercentage <= 5 && veryhighRiskLOCPercentage <= 0.0000000000001) {
		rating = "+";
	}
	
	else if(moderateRiskLOCPercentage <= 40 && highRiskLOCPercentage <= 10 && veryhighRiskLOCPercentage <= 0.0000000000001) {
		rating = "o";
	}
	
	else if(moderateRiskLOCPercentage <= 50 && highRiskLOCPercentage <= 15 && veryhighRiskLOCPercentage <= 5) {
		rating = "-";
	}
	
	else {
		rating = "--";
	}
	
	return rating;
}

/* 
 * Cyclomatic Complexity of a Method: Number of decision points + number of logical operators + 1
 *
 * 		decision points: if, else, cases, loop, etc
 *		logical operators: || and &&
 *	
 *
 * TODO: consider number of logical operators as well?
 *
*/
int checkMethodCyclomaticComplexity(Declaration methodAST) {
	
	int cc = 1;	
	
	visit(methodAST) {
		case \if(Expression condition, Statement thenBranch): cc += 1; 
		case \if(Expression condition, Statement thenBranch, Statement elseBranch): cc += 2;     
		case \case(Expression expression): cc += 1; 
		case \foreach(Declaration parameter, Expression collection, Statement body): cc += 1; 
		case \for(list[Expression] initializers, Expression condition, list[Expression] updaters, Statement body): cc += 1; 
		case \for(list[Expression] initializers, list[Expression] updaters, Statement body): cc += 1; 
		case \defaultCase(): cc += 1; 
		case \while(Expression condition, Statement body): cc += 1;
		case \do(Statement body, Expression condition): cc += 1;  		
   	};
   	   	    	  	
	return cc;
}

// problem: /*      "int a;" is considered line of code
//			int a;
//			*/
str getPureCode(str uncleanLine) {	
	trimLine = replaceAll(uncleanLine,"\t","");
	line = replaceAll(trimLine," ","");		
	
	if (/^\/\// := line) return ""; // "// jiuvuyb"
			
	else if (/\/\*/ := line)  { // contains "/*"
				
		if (findFirst(line, "*/") == -1) return ""; // doesn't contain "*/"
		
		else {
				
			if(/.+\/\*.*\*\/.+/ := line) { // "jneigneijn /* hbuerv */ iuhriurgu"
				line = line[..findFirst(line, "/*")] + line[findFirst(line, "*/")+2..];
			}
			
			else if(/^\/\*.*\*\/.*/ := line) line = line[findFirst(line, "*/")+2..];
		
			else line = line[..findFirst(line, "/*")]; // (/.*\/\*.*\*\/$/ := line)
																	
			return line; //getPureCode(line);		
		}		 
	}	
	
	else if (/\*\// := line) return line[findFirst(line, "*/")+2..]; //getPureCode(line[findFirst(line, "*/")+2..]);	
	
	else if (/\/\/.*$/ := line) return line[..findFirst(line,"//")];	
	
	else return line;
}

