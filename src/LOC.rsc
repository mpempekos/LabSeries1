module LOC

import util::Resources;
import IO;
import List;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import String;

/************************
**** @author: Spiros ****
************************/


void cloc() {
	//loc project = |project://TestProject2|;
    //loc project = |project://hsqldb-2.3.1|;
    loc project = |project://smallsql0.21_src|;
	myProject = getProject(project);
	
	linesOfCode = 0; comments = 0;	blankLines = 0;
	list[int] results;
	visit (myProject) {
		case file(loc id): {
				results = checkFile(id);
				if (results != []) {
					linesOfCode += results[0];
					comments += results[1];
					blankLines += results[2];
				}
		}
   }
   println("*** Lines Of Code are <linesOfCode> ****");
   //println("comments are <comments>");
   //println("blank lines are <blankLines>");
}


list[int] checkFile(loc id) {
	if (id.path[-4..] == "java")  
		return countLinesOfFile(id);
	else 
		return [];
}


list[int] countLinesOfFile(loc id) {
	loc project = |project://TestProject|;
	sourceCode = readFileLines(id);
	
	singleCommentLines=0;	totalLines =0;	blankLines =0; multiCommentLines =0;
	totalLines = size(sourceCode);
	commentOpened = false;
	
	for (i <- sourceCode) {
			
		if (commentOpened) {					// a comment has been opened from previous line
			
			if(/^[ \t\r\n]*$/ := i)				// blank line
	 		   blankLines +=1;
	 		else if (/^.*\*\/[\s\t\n]*$/ := i) {	// found * / and nothing else
	 			commentOpened = false;
	 			multiCommentLines +=1;
	 		}
	 		else if (/.*\*\// := i) {			// found * / and sth follows...
	 			
	 			i = i[findFirst(i,"*/")+2..];
	 			
	 			if (/^[^\w}{;]*\/\// := i)	{	// simple comment follows...	**** TO DO CHECK THIS *****
	 				commentOpened = false;
	 				multiCommentLines+=1;
	 			}
	 			else if (/^[ \t\r\n]*$/ := i) {		// nothing follows... 		**** TO DO CHECK THIS **** duplicate?
	 				multiCommentLines+=1;
	 				commentOpened = false;
	 			}
	 			else commentOpened = false;		// there is code...
	 		}
	 		
	 		else  	{							// comment goes on . . . 
	 			multiCommentLines +=1;
	 			println("comment goes on");
	 		}
	 	}
	 		
		else if(/^[ \t\r\n]*$/ := i)			// blank line
	 		blankLines +=1;
	 	
	 	else if (/^.*\*\/[\s\t\n]*$/ := i) {   // * /	**** TO DO CHECK ****	duplicate
      		multiCommentLines +=1;
	 	}
	 			
	 	else if (/^[^\w]*\/\*.*\*\/[\s\t\n]*$/ := i) {	// found /* ... */ no code following
      		multiCommentLines +=1;
	 	}
	 	
	 	//else if  (/^[^\w]*\/\*[^\*\/]*$/ :=  i ) {		// pianei ta /* ...............
	 	else if  (/^[^\w]*\/\*/ :=  i ) {				// found /*...
	 	    if (/\*\//:= i) 
	 	    	println("skata!");
	 	    else {
	 			commentOpened = true;
	 			multiCommentLines +=1;
	 		}
	 	}
	 		 	
	 	else if (/^[^\w]*\*.*\*\/[\s\t\n]*$/ := i) {	// found * .... */ no code following  *** TO DO CHECK ***
      		multiCommentLines +=1;
	 	}
	 		
	   	//else if(/[\s\t\n]*\/\// := i)
      	else if (/^[^\w}{;]*\/\// := i)		// single comment line
      		singleCommentLines +=1;
     }
     
     comments = singleCommentLines + multiCommentLines;
     linesOfCode = totalLines - (blankLines + comments);
	 return [linesOfCode,comments,blankLines];
}