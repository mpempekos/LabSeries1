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
	//println("number of duplicated lines: <size(dupLines)>");

}

int checkFor2EqualBlocks(list[str] codeLines, int i, int j) {
	//println("Found 2 equal lines");
	//println("i is <i> and j is <j>");
	//println("Equal lines are <codeLines[i]> and <codeLines[j]>");
	int count = 1;
	//println("i is <i> and j is <j>");
	for(int k <- [1..size(codeLines)-j]) {	
		//iprintln("<codeLines[i+k]> kai <codeLines[j+k]>");
		if (codeLines[i+k] != codeLines[j+k]) {
			return count;
		}		
		//println("Found another line!");
		count = count + 1;
	}
	return count;
}


list[str] code2listLines(M3 model) {
	myClasses = classes(model);
	c = toList(myClasses);
	list[str] classSrc = [];
	
	println(c);;
	
	for (i <- [0..size(c)]) 
		classSrc = readFileLines(c[i]); // WARNING: JUST RETURNIG FIRST CLASS
	//println("Here2: <classSrc>");
	return classSrc;
}


list[str] purifyCode(list[str] src) {

	commentOpened = false;
	pureList = [];
	
	for (i <- src) {
			
		if (commentOpened) {
			if(/^[ \t\r\n]*$/ := i)				// it's a blank line
	 		   println("skata");
	 		else if (/^.*\*\/[\s\t\n]*$/ := i) {	// it's a comment that finishes...
	 			commentOpened = false;
	 			//multiCommentLines +=1;
	 		}

	 		else if (/.*\*\// := i) {			// might have code...
	 			i = i[findFirst(i,"*/")+2..];
	 			if (/^[^\w}{;]*\/\// := i)	{	// simple comment follows...
	 				commentOpened = false;
	 				//multiCommentLines+=1;
	 			}
	 			else if (/^[ \t\r\n]*$/ := i) {	// nothing follows... {
	 				//multiCommentLines+=1;
	 				commentOpened = false;
	 			}
	 			else {
	 			commentOpened = false;						// there is code...
	 			pureList += i;
	 			}
	 			//findFirst(i,"*/");
	 		}
	 		else  			{							// comment goes on . . . 
	 			//multiCommentLines +=1;
	 			println("comment goes on");
	 			}
	 	}
	 		
		else if(/^[ \t\r\n]*$/ := i)
	 		//blankLines +=1;
	 		println("Skata4: <i>");
	 	else if (/^.*\*\/[\s\t\n]*$/ := i) {   // pianei ta */
      		//multiCommentLines +=1;
	 		println("Skata1: <i>");
	 	}
	 			
	 	else if (/^[^\w]*\/\*.*\*\/[\s\t\n]*$/ := i) {	// pianei ta /* ... */ xwris kodika profanws
      		//multiCommentLines +=1;
	 		println("Skata2: <i>");
	 	}
	 	
	 	//else if (/[\s\t\n]*\/\*[^\*\/]*/ := i) {
	 	//else if  (/^[^\w]*\/\*[^\*\/]*$/ :=  i ) {		// pianei ta /* ...............
	 	  else if  (/^[^\w]*\/\*/ :=  i ) {	
	 	    if (/\*\//:= i) println("skata!");
	 	    else {
	 		commentOpened = true;
	 		//multiCommentLines +=1;
	 		//println("coment open at <i>");
	 		}
	 		//println("<i>");
	 	}

	 	
	 	else if (/^[^\w]*\*.*\*\/[\s\t\n]*$/ := i) {	// pianei ta * .... */ xwris kodika profanws
      		//multiCommentLines +=1;
	 		println("Skata4: <i>");
	 	}
	 		
	   	//else if(/[\s\t\n]*\/\// := i)	//	--> sigoura lathos		**** ME AYTO VELTIWNETAI TO MIKRO...
      	else if (/^[^\w}{;]*\/\// := i)		// ---> 24643... seems right but wtf?
      		// singleCommentLines +=1;
      		println("Skata4: <i>");
      	else 			// CODE BITCH!
      		pureList+=i;
     }
     
//     comments = singleCommentLines + multiCommentLines;
  //   linesOfCode = totalLines - (blankLines + comments);
	 return pureList;
}