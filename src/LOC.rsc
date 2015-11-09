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

/*   Small file: comm: 8981   loc: 24048				Big file: comm: 74364    loc: 168836

------------------------------------------------ New method ----------------------------------------------------------------

LOC are 22795    ----->   1253 f%^&^% lines...				LOC are 169246 ---> 410 lines missing....
blank lines are 5394										blank lines are 56829

*/


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
   println("*** LOC are <linesOfCode> ****");
   println("comments are <comments>");
   println("blank lines are <blankLines>");
}


list[int] checkFile(loc id) {
	if (id.path[-4..] == "java")  
		return countLinesOfFile(id);
		else 
			return [];
}


 list[int] countLinesOfFile(loc id) {
	loc project = |project://TestProject|;
	//sourceCode = readFileLines(|project://TestProject/src/CClass.java|);
	sourceCode = readFileLines(id);
	
	singleCommentLines=0;	totalLines =0;	blankLines =0; multiCommentLines =0;
	totalLines = size(sourceCode);
	commentOpened = false;
	
	for (i <- sourceCode) {
			
		if (commentOpened) {
			if(/^[ \t\r\n]*$/ := i)				// it's a blank line
	 		   blankLines +=1;
	 		else if (/^.*\*\/[\s\t\n]*$/ := i) {	// it's a comment that finishes...
	 			commentOpened = false;
	 			multiCommentLines +=1;
	 		}
	 		//else if (/^.*\*\/[\w]*$/ := i)				// it has code...
	 		else if (/.*\*\// := i) {			// kleinei alla exei kati akoma meta...
	 			//commentOpened = false;
	 			i = i[findFirst(i,"*/")+2..];
	 			if (/^[^\w}{;]*\/\// := i)	{	// simple comment follows...
	 				commentOpened = false;
	 				multiCommentLines+=1;
	 			}
	 			else if (/^[ \t\r\n]*$/ := i) {	// nothing follows... {
	 				multiCommentLines+=1;
	 				commentOpened = false;
	 			}
	 			else commentOpened = false;						// there is code...
	 			//findFirst(i,"*/");
	 			}
	 		else  			{							// comment goes on . . . 
	 			multiCommentLines +=1;
	 			println("comment goes on");
	 			}
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
	 	
	 	//else if (/[\s\t\n]*\/\*[^\*\/]*/ := i) {
	 	//else if  (/^[^\w]*\/\*[^\*\/]*$/ :=  i ) {		// pianei ta /* ...............
	 	  else if  (/^[^\w]*\/\*/ :=  i ) {	
	 	    if (/\*\//:= i) println("skata!");
	 	    else {
	 		commentOpened = true;
	 		multiCommentLines +=1;
	 		println("coment open at <i>");
	 		}
	 		//println("<i>");
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
     }
     
     comments = singleCommentLines + multiCommentLines;
     linesOfCode = totalLines - (blankLines + comments);
	 return [linesOfCode,comments,blankLines];
}
