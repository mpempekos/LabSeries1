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

// currently being tested with project "softEvolTest"

list[str] checkIfJavaFile(loc id) {
	if (id.path[-4..] == "java")  {
		return getLOC(readFileLines(id));	// call method
		}
	else return [];
}

list[str] replaceShit(list[str] codeLines) {
   finalList = [];
   for (i <- codeLines) {
	
	/* check for semi-comments */
		
	if (/\/\// := i) { 					// found //
		i = i[..findFirst(i,"//")];
	}
	
	else if ((/\/\*/ := i) && (/\*\// := i)) {	// found code in between * / and / *
		sub_a = i[..findFirst(i,"/*")];
		sub_b = i[findFirst(i,"*/")+2..];
		i = sub_a + sub_b;
	}
	
	else if (/\/\*/ := i) {					// found code before / *
		i = i[..findFirst(i,"/*")];
	}
	
	else if (/\*\// := i) {					// found code after * /
		i = i[findFirst(i,"*/")+2..];
	}
	
	/* remove tabs and spaces */
	
	tabsRemoved = replaceAll(i,"\t","");
	spacesRemoved = replaceAll(tabsRemoved," ","");
	finalList += spacesRemoved; 
   }
	
   return finalList;
}

void numbDuplicatedLines() {
	int dupFound = 0;
	set[int] dupLines = {};
	list[str] pureCode = [];
	
	loc project = |project://TestProject|;
    //loc project = |project://smallsql0.21_src|;
	myProject = getProject(project);
	
	visit (myProject) {
		case file(loc id): {
				pureCode += checkIfJavaFile(id);
		}
   }
	
	println("I have this to check <pureCode>");
	pureCode = replaceShit(pureCode);
		
	for(int i <- [0..size(pureCode)]) {
		if(i notin dupLines) {
			for(int j <- [i+1..size(pureCode)]) {
				//println("<codeLines[i]>, <codeLines[j]>");
				if(pureCode[i] == pureCode[j]) {
					dupFound = checkFor2EqualBlocks(pureCode, i, j);
					if (dupFound >= 6) {
						for(int k <- [0..dupFound]) {												
							dupLines = dupLines + (i+k);
							dupLines = dupLines + (j+k);			
						}
					}
				}			
			}
		}			
	}
	println("number of duplicated lines: <size(dupLines)>");
}

int checkFor2EqualBlocks(list[str] codeLines, int i, int j) {
	int count = 1;
	for(int k <- [1..size(codeLines)-j]) {						// is this 100% sure???
		//iprintln("<codeLines[i+k]> kai <codeLines[j+k]>");
		if (codeLines[i+k] != codeLines[j+k]) {
			println("counter is <count>");
			println("<codeLines[i+k]> and <codeLines[j+k]>");
			return count;
		}		
		count = count + 1;
	}
	return count;
}

/**** do u need this???? ***/

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


list[str] getLOC(list[str] src) {

	commentOpened = false;
	pureList = [];
	
	for (i <- src) {
			
		if (commentOpened) {
		
			if(/^[ \t\r\n]*$/ := i)	{			// it's a blank line
	 		   //println("skata");
	 		   int a;
	 		}
	 		
	 		else if (/^.*\*\/[\s\t\n]*$/ := i) {	// it's a comment that finishes...
	 			commentOpened = false;
	 			//multiCommentLines +=1;
	 			//println("skata2");
	 		}

	 		else if (/.*\*\// := i) {			// might have code...
	 			i = i[findFirst(i,"*/")+2..];
	 			if (/^[^\w}{;]*\/\// := i)	{	// simple comment follows...
	 				commentOpened = false;
	 				//multiCommentLines+=1;
	 				//println("skata3");
	 			}
	 			else if (/^[ \t\r\n]*$/ := i) {	// nothing follows... {
	 				//multiCommentLines+=1;
	 				commentOpened = false;
	 				//println("skata4");
	 			}
	 			else {
	 			commentOpened = false;						// there is code...
	 			pureList += i;
	 			}
	 			//findFirst(i,"*/");
	 		}
	 		else  			{							// comment goes on . . . 
	 			//multiCommentLines +=1;
	 			//println("comment goes on");
	 			int b;
	 			//println("skata5");
	 			}
	 	}
	 		
		else if(/^[ \t\r\n]*$/ := i) {
	 		//blankLines +=1;
	 		//println("Skata6: <i>");
	 		int c;
 		}
	 	else if (/^.*\*\/[\s\t\n]*$/ := i) {   // pianei ta *  /
      		//multiCommentLines +=1;
	 		//println("Skata7");
	 		int d;
	 	}  
	 			
	 	else if (/^[^\w]*\/\*.*\*\/[\s\t\n]*$/ := i) {	// pianei ta /* ... */ xwris kodika profanws
      		//multiCommentLines +=1;
	 		//println("Skata8: <i>");
	 		int e;
	 	}
	 	
	 	//else if (/[\s\t\n]*\/\*[^\*\/]*/ := i) {
	 	//else if  (/^[^\w]*\/\*[^\*\/]*$/ :=  i ) {		// pianei ta /* ...............
	 	  else if  (/^[^\w]*\/\*/ :=  i ) {	
	 	    if (/\*\//:= i) {
	 	    	//println("skata9");
	 	    	int f;
	 	    }
	 	    else {
	 		commentOpened = true;
	 		//multiCommentLines +=1;
	 		//println("skata10");
	 		}
	 		//println("<i>");
	 	}

	 	
	 	else if (/^[^\w]*\*.*\*\/[\s\t\n]*$/ := i) {	// pianei ta * .... */ xwris kodika profanws
      		//multiCommentLines +=1;
	 		//println("Skata11:");
	 		int g;
	 	}
	 		
	   	//else if(/[\s\t\n]*\/\// := i)	//	--> sigoura lathos		**** ME AYTO VELTIWNETAI TO MIKRO...
      	else if (/^[^\w}{;]*\/\// := i)	{	// ---> 24643... seems right but wtf?
      		// singleCommentLines +=1;
      		//println("Skata12");
      		int h;
      	}
      	else 			// CODE BITCH!
      		pureList+=i;
     }
    return pureList;
}

str getPureCode(str uncleanLine) {	
	trimLine = replaceAll(uncleanLine,"\t","");
	line = replaceAll(trimLine," ","");		
	
	if (/^\/\// := line) {          // case: "// ghkomnyt"
		return "";	
	} 
	
	else if (/\/\/.*$/ := line) {			
		return line[..findFirst(line,"//")];	
	} 
	
	else if (/\/\*/ := line)  {		
		if (findFirst(line, "*/") == -1) {			
			return "";
		} 
		else {		
			if(/.+\/\*.*\*\/.+/ := line) {
				line = line[..findFirst(line, "/*")] + line[findFirst(line, "*/")+2..];
			}
			else if(/^\/\*.*\*\/.*/ := line) {
				line = line[findFirst(line, "*/")+2..];
			} 
			else {// (/.*\/\*.*\*\/$/ := line) 			
				line = line[..findFirst(line, "/*")];
			} 																
			return getPureCode(line);		
		}		 
	}	 
	else {
		return line;
	}
}