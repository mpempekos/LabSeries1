module visualization

import util::Resources;
import IO;
import List;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import String;
import Set;
import vis:: Figure;
import vis:: Render;


/* @andre : finally the iteration is fucking working... i did so many tests...all i need from you to give me (at this point...) is a
	tree representing the structure of the program (instead of a list/set we were talking about)...
	 take a look below at CTree i have created and u will understand...

*/


data ProjectStructure = method(str name)
| folderOrFile(str name,int methodsIncluded, list[ProjectStructure] internalTrees);

Figure formBoxes(ProjectStructure nodee) {

	Figure fig ;
		
	switch (nodee) {
		case folderOrFile(name,N,internalNodes): 
			fig = box(vcat([text(nodee.name),visualize(nodee)]), area(nodee.methodsIncluded));
			
		case method(n):
			fig = box(text(n),area(1));	// to do --> fillColor...

	}
	
	return fig;
}


Figure visualize(ProjectStructure tree) {
	Figure fig;
	switch (tree) {
		case folderOrFile(name,N,internalNodes): { 
			Figures figs = [];
			
			for (i <- internalNodes){
			  	figs += formBoxes(i);
		  	}
		  			  	
		  	fig = treemap(figs);
		  	
		}
				
		//case method(name): fig = box(text(name),area(1));
	}
		
	return fig;
}

/* src will be the last single node in the tree... */


void runVisualization() {
	method5 = method("method5");
	method4 = method("method4");
	method3 = method("method3");
	method2 = method("method2");
	method1 = method("method1");
	file1 = folderOrFile("file1",2,[method1,method2]);
	file2 = folderOrFile("file2",1,[method3]);
	file3 = folderOrFile("file3",2,[method3,method5]);
	file4 = folderOrFile("file4",1,[method4]);
	package1 = folderOrFile("package1",2,[file1]);
	package2 = folderOrFile("package2",3,[file3,file4]);
	package3 = folderOrFile("package3",4,[package2,file2]);
	src = folderOrFile("src",6,[package1,package3]);
	
	
/*	top-down visit(src) {
		case leaf(n): println("Name of method is <n>!\n");
		case noode(n,b,xs): println("Name of path is <n>!\n");
	} 
	*/
	
	render(visualize(src));
}