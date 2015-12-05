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

data CTree = leaf(str name)
| noode(str name,int methodsIncluded, list[CTree] internalTrees);

Figure formBoxes(CTree nodee) {

	Figure fig = box(text("shit"));
		
	switch (nodee) {
		case noode(name,N,internalNodes): 
			fig = box(vcat([text(nodee.name),visualize(nodee)]), area(nodee.methodsIncluded));
			
		case leaf(n):
			fig = box(text(n),area(1));	// to do --> fillColor...

	}
	
	return fig;
}


Figure visualize(CTree tree) {
	Figure fig;
	switch (tree) {
		case noode(name,N,internalNodes): { 
			Figures figs = [];
			for (i <- internalNodes){
			  	//figs += visualize(i);
			  	figs += formBoxes(i);
		  	}
		  			  	
		  	fig = treemap(figs);
		  	
		  	//fig = box(treemap(figs));
		}
				
		case leaf(name): fig = box(text(name),area(1));		// todo: fillCOlor--according to pairs it has
	}
		
	return fig;
}


void firstMethod() {
	method5 = leaf("method5");
	method4 = leaf("method4");
	method3 = leaf("method3");
	method2 = leaf("method2");
	method1 = leaf("method1");
	file1 = noode("file1",2,[method1,method2]);
	file2 = noode("file2",1,[method3]);
	file3 = noode("file3",1,[method3]);
	file4 = noode("file4",1,[method4]);
	package1 = noode("package1",2,[file1]);
	package2 = noode("package2",2,[file3,file4]);
	package3 = noode("package3",3,[package2,file2]);
	src = noode("src",4,[package1,package3]);
	
	
	
/*	top-down visit(src) {
		case leaf(n): println("Name of method is <n>!\n");
		case noode(n,b,xs): println("Name of path is <n>!\n");
	} 
	*/
	render(visualize(src));
}