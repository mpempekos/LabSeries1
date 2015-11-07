module LOC

import util::Resources;
import IO;
import List;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;

/************************
**** @author: Spiros ****
************************/

<<<<<<< HEAD
=======
/* this works... TODO below...
   1. remove duplicates from list
   2. put it in a loop
   3. check for given programs
*/

>>>>>>> b10dacf40e10e4f470b9112d4db4f132f444c95e

list[int] helpFunc(loc id) {
	if (id.path[-4..] == "java")  
		return countLinesOfFile(id);
		else 
			return [];
}

// Small file: comm: 8981   loc: 24048
// Big file: comm: 74364    loc: 168836

/*
LOC are 24139    ----->  91 f%$^&%& lines missing!!!
comments are 8890
blank lines are 5394
*/

/*
LOC are 180586 	------>  11750 f%^&%^&% lines missing!!!
comments are 66712
blank lines are 56829  --->  301 f%$^$%^%$ lines...? wtf?
*/


void cloc() {
	//loc project = |project://TestProject2|;
    //loc project = |project://TestProject|;
    loc project = |project://hsqldb-2.3.1|;
    //loc project = |project://smallsql0.21_src|;
	myProject = getProject(project);
	
	linesOfCode = 0; comments = 0;	blankLines = 0;
	list[int] results;
	visit (myProject) {
		case file(loc id): {
				results = helpFunc(id);
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


 list[int] countLinesOfFile(loc id) {
	loc project = |project://TestProject|;
	//getProject(project);	// exw resources
	//sourceCode = readFileLines(|project://TestProject/src/CClass.java|);
	sourceCode = readFileLines(id);
	
	singleCommentLines=0;	totalLines =0;	blankLines =0; multiCommentLines =0;
	totalLines = size(sourceCode);
	
	for (i <- sourceCode) {
	 	if(/^[ \t\r\n]*$/ := i)
	 		blankLines +=1;
	 	else if (/^[\s\t\n]*\/*$*\*\/[\s\t\n]*$/ := i) {   // pianei ta */
      		multiCommentLines +=1;
	 		println("Skata1: <i>");
	 		}		
	 	else if (/^[^\w]*\/\*.*\*\/[\s\t\n]*$/ := i) {	// pianei ta /* ... */ xwris kodika profanws
      		multiCommentLines +=1;
	 		println("Skata2: <i>");
	 	}
	 	else if  (/^[^\w]*\/\*[^\*\/]*$/ :=  i ) {		// pianei ta /* ...............
	 		multiCommentLines +=1;
	 		println("<i>");
	 	}
	 	else if (/^[^\w]*\*[^\*\/[\s\t\n]]*$/ :=  i ) {		// pianei ta * ...
	 		multiCommentLines+=1;
	 		println("skata3: <i>");
	 		}
	 	else if (/^[^\w]*\*.*\*\/[\s\t\n]*$/ := i) {	// pianei ta * .... */ xwris kodika profanws
      		multiCommentLines +=1;
	 		println("Skata4: <i>");
	 	}
	 		
	 		/* below is the one that "worked yesterday"
	    else if (/((\s|\/*)(\/\*|\s\*)|[^\w,\;]\s\/*\/)/ := i) {
      		multiCommentLines += 1;
      		println("skata2");
      		}   */
	 	//else if (/[\s\t\n]+\/*$*\*\/[\s\t\n]+$/ := i)
      		//multiCommentLines +=1;
      	else if(/\/\// := i)
      		singleCommentLines +=1;
     }
     
     comments = singleCommentLines + multiCommentLines;
     linesOfCode = totalLines - (blankLines + comments);
	 return [linesOfCode,comments,blankLines];
}

// below methods to be removed...

int getBlankLines(list[str] source_file) {
	 count = 0;
	 for (i <- source_file)
	 	if(/^[ \t\r\n]*$/ := i)
	 	count +=1;
	 return count;
}

int getTotalLines(list[str] file) {
	return size(file);
}

public int getCommentLines(list[str] file){
  n = 0;
  for(s <- file)
    if(/((\s|\/*)(\/\*|\s\*)|[^\w,\;]\s\/*\/)/ := s)   
    // new below...
    //if (/[\s\t\n]+\/*$*\*\/[\s\t\n]+$/ := s)
      n +=1;
  return n;
}

public int getSingleCommentLines(list[str] file){	
  n = 0;
  for(s <- file)
    if(/\/\// := s)  
      n +=1;
  return n;
}
