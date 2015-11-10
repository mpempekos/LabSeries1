module cycloComplex

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import analysis::m3::AST;
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
	//M3 myModel = createM3FromEclipseProject(|project://smallsql0.21_src|);
	M3 myModel = createM3FromEclipseProject(|project://hsqldb-2.3.1|);		
	
	myMethods = methods(myModel);
	//println(myMethods);
	list[loc] methodsList = toList(myMethods);
	
	for(int i <- [0..size(methodsList)]) {					
		methodLines = readFileLines(methodsList[i]);		
		list[str] methodLOC = getLOC(methodLines);		
		allLOC += size(methodLOC);
		
		//Declaration methodAST = 
		//println(methodAST);
		
		int mcc = checkMethodCyclomaticComplexity(getMethodASTEclipse(methodsList[i], model=myModel));
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
	
	println("allLOC: <allLOC>");
	
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
   	   	    	  
	//int Statements = (0 | it + 1 | /Statement _ := methodAST);
	//println(Statements);
	
	/*for(int i <- [0..size(methodLOC)]) {

		if(isIfStatement(methodLOC[i])) {
			cc = cc + 1; 			
			lo = countLogicalOperators(methodLOC[i]);
			cc = cc + lo;
			lo = 0;			
		}
		
		if(isElseStatement(methodLOC[i])) cc = cc + 1; 
		
		if(isForLoop(methodLOC[i])) cc = cc + 1; 
		
		if(isWhileLoop(methodLOC[i])) cc = cc + 1; 
		
		if(isCaseStatement(methodLOC[i])) cc = cc + 1; 
		
	}*/
	return cc;
}

/* 
 * TODO: improve match with AST
 *
 */

/*bool isIfStatement(str line) {	
	return contains(line, "if(");
}

bool isElseStatement(str line) {	
	return contains(line, "else");
}

bool isForLoop(str line) {	
	return contains(line, "for(");
}

bool isWhileLoop(str line) {	
	return contains(line, "while(");
}

bool isCaseStatement(str line) {	
	return contains(line, "case");
}*/