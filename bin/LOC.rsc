module LOC

import util::Resources;
import IO;
import List;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import Set;

/************************
**** @author: Spiros ****
************************/

/* this works... TODO below...
   1. remove duplicates from list
   2. put it in a loop
   3. check for given programs
   4. delete some java_programs
*/


void maintest2() {
	model = createM3FromEclipseProject(|project://TestProject|);
	myClasses = classes(model);
	c = toList(myClasses);
	classSrc = readFileLines(c[0]);
	b = readFileLines(c[1]);
	c = readFileLines(c[2]);
	d = readFileLines(c[3]);
	println(<d>);
	println(<c>);
	println(<b>);
	println(<classSrc>);	
}


//edw pairnw ola ta files...
// an to kanw etsi, na chekarw mono ta .java arxeia

void helpFunc(loc id) {
	println("<id> kai to path einai <id.path>");
	if (id.path[-4..] == "java") main(id);
}

void maintest() {

    loc project = |project://TestProject|;
	myProject = getProject(project);
	
	visit (myProject) {
		case file(loc id): helpFunc(id);
   }
}

// edw swsta ypologizw gia ena arxeio tis grammes...

void main(loc id) {

	// na pairnei location apo user?
	loc project = |project://TestProject|;
	//getProject(project);	// exw resources

	//sourceCode = readFileLines(|project://TestProject/src/CClass.java|);
	sourceCode = readFileLines(id);
	println("Total lines are <getTotalLines(sourceCode)> and 
	comment lines are <getCommentLines(sourceCode)> and
	single comment lines are <getSingleCommentLines(sourceCode)> and
	blank lines are <getBlankLines(sourceCode)> ");
}

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