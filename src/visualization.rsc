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
import lab2;


/* @andre : finally the iteration is fucking working... i did so many tests...all i need from you to give me (at this point...) is a
	tree representing the structure of the program (instead of a list/set we were talking about)...
	 take a look below at CTree i have created and u will understand...

*/

//data ProjectStructure = fragment(int il, int fl, loc location, list[tuple[loc cloneLocation, int typee]])
//| folderOrFile(str name,int fragmentsIncluded, list[ProjectStructure] internalTrees);

Figure formBoxes(ProjectStructure nodee) {

	Figure fig ;
		
	switch (nodee) {
		case folderOrFile(name,N,internalNodes): 
			fig = box(vcat([text(nodee.name),visualize(nodee)]), area(nodee.fragmentsIncluded));
			
		case fragment(n):	// fragment(list(clones)) 
			fig = box(text(n),id("1"),area(1));	// to do --> fillColor...
			// give an id = src/package1/file1/fragment1
			// onClick = for(i « list(clones)) » id
			

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
				
		//case fragment(name): fig = box(text(name),area(1));
	}
		
	return fig;
}

/* src will be the last single node in the tree... */


void runVisualization() {
	//fragment13 = fragment("fragment5");
	//fragment12 = fragment("fragment4");
	//fragment11 = fragment("fragment3");
	//fragment10 = fragment("fragment2");
	//fragment9 = fragment("fragment4");
	//fragment8 = fragment("fragment3");
	//fragment7 = fragment("fragment2");
	//fragment6 = fragment("fragment1");
	//fragment5 = fragment("fragment5");
	//fragment4 = fragment("fragment4");
	//fragment3 = fragment("fragment3");
	//fragment2 = fragment("fragment2");
	//fragment1 = fragment("fragment1");
	//file1 = folderOrFile("file1",2,[fragment1,fragment2,fragment3,fragment4,fragment5,fragment6,fragment7,fragment8,fragment9,fragment10,fragment11,fragment12]);
	//file2 = folderOrFile("file2",1,[fragment3]);
	//file3 = folderOrFile("file3",2,[fragment3,fragment5]);
	//file4 = folderOrFile("file4",1,[fragment4]);
	//package1 = folderOrFile("package1",2,[file1]);
	//package2 = folderOrFile("package2",3,[file3,file4]);
	//package3 = folderOrFile("package3",4,[package2,file2]);
	//src = folderOrFile("src",6,[package1,package3]);
	
	
/*	top-down visit(src) {
		case leaf(n): println("Name of fragment is <n>!\n");
		case noode(n,b,xs): println("Name of path is <n>!\n");
	} 
	*/
	
	list[tuple[loc l1, loc l2, int t]] clones;
	clones = findClones(|project://softEvolTest|, 30); // why 30??
	ProjectStructure tree = createTree(clones, "softEvolTest");
	
	println(tree);
	
	render(visualize(tree));
}

data ProjectStructure = fragment(int bl, int el, loc id, list[tuple[loc cloneLocation, int typee]] clones)
| folderOrFile(str name, int numberOfFragments, list[ProjectStructure] internalTrees);

// <|file:///C:/Users/andre/OneDrive/Documents/GitHub/LabSeries1/softEvolTest/src/softEvolTest/ClassA.java|(508,281,<18,1>,<28,2>),
//  |file:///C:/Users/andre/OneDrive/Documents/GitHub/LabSeries1/softEvolTest/src/softEvolTest/ClassA.java|(796,281,<30,1>,<40,2>),2>

ProjectStructure createTree(list[tuple[loc l1, loc l2, int t]] clonePairs, str rootNode) {
	ProjectStructure tree = folderOrFile(rootNode, 0, []);
	
	println(tree);
		
	for(pair <- clonePairs) {
		//str uri_1 = pair.n1.uri;
		//str uri_2 = pair.n2.uri;
		//int bl_1 = pair.n1.BL; 	
		//int el_1 = pair.n1.EL;
		//int bl_2 = pair.n2.BL; 	
		//int el_2 = pair.n2.EL; 
		//list[str] nodes1 = parseToListOfNodes(uri_1);
		//list[str] nodes2 = parseToListOfNodes(uri_2);	 	
			
		tree = insert2Leafs(tree, pair, rootNode);
		//println(tree);
		
		//if (fragmentInTree(tree, pair.l1)) {
		//	tree = updateTree(tree, pair.l1, pair.l2, pair.t); 	
		//} else {
		//	tree = insertNewLeaf(tree, nodes1, bl_1, el_1, pair.n1);
		//	tree = updateTree(tree, pair.l1, pair.l2, pair.t); 
		//}
		//
		//if (fragmentInTree(tree, pair.l2)) {
		//	tree = updateTree(tree, pair.l2, pair.l1, pair.t); 	
		//} else {
		//	tree = insertNewLeaf(tree, nodes2, bl_2, el_2, pair.n2);
		//	tree = updateTree(tree, pair.l2, pair.l1, pair.t); 
		//}				
	}
	return tree;
}

ProjectStructure insert2Leafs(ProjectStructure tree, tuple[loc l1, loc l2, int t] pair, str rootNode) {
	list[str] aux = split(rootNode,pair.l1.uri);		
	list[str] pathForInsertion = split("/",aux[1]);
	list[str] aux1 = split(rootNode,pair.l2.uri);		
	list[str] pathForInsertion1 = split("/",aux1[1]);
	//str prevNode = rootNode;
	//ProjectStructure currentNode = tree;
	
	//for(n <- pathForInsertion) {
	//
	//	if (n in currentNode.internalTrees) {
	//		currentNode.numberOfFragments += 1;
	//		position = indexOf(currentNode.internalTrees, n);
	//		currentNode = currentNode.internalTrees[position];
	//	}
	//	
	//	else {
	//		currentNode.numberOfFragments += 1;
	//		currentNode.internalTrees += folderOrFile(n, 0, []);
	//		position = indexOf(currentNode.internalTrees, n);
	//		currentNode = currentNode.internalTrees[position];
	//	}
	//	
	//	//currentNode = visitTreeAndInsertNodeIfNecessary(currentNode, n);
	//
	//	 //if(!nodeInTree(tree, n)) {
	//	 //	tree = insertNewNode(tree, prevNode, n);
	//	 //} 
	//	 //else {
	//	 //	//tree = incrementNodeCounter(tree, prevNode);		 	
	//	 //}
	//	 //prevNode = n;
	//}
	
	tree = insertPathOfNodesAndLeaf(tree, pathForInsertion, pair);	
	//tree = insertPathOfNodesAndLeaf(tree, pathForInsertion1, pair);	
		
	return tree;
}


//ProjectStructure insertNewFragment(ProjectStructure tree, str last(pathForInsertion), tuple[loc l1, loc l2, int t] pair) {
//	
//}

ProjectStructure insertPathOfNodesAndLeaf(ProjectStructure tree, list[str] pathForInsertion, tuple[loc l1, loc l2, int t] pair) {

	//println(tree);
	if(isEmpty(pathForInsertion)) {		// time for a leaf....
	
		println("leaf");
	
		bool flag2 = false;
		for(i <- tree.internalTrees) {
			if (pair.l1 == i.id) {
				i.clones += <l2,t>;
				flag2 = true;
				break;
			}
		}
		
		if (flag2) {						// new leaf to be inserted....
			tree.numberOfFragments += 1;
			ProjectStructure fragment = createFragment(pair);
			tree.internalTrees += fragment;
		}
		return tree;
	}
	
	else { 		//time for a node
	
		println("node");
		
		bool flag = false;
		for(i <- tree.internalTrees) {
		
			//println(i.name);
			//println(pathForInsertion[0]);
			
			if (i.name == pathForInsertion[0]) {
				flag = true;
				break;
			}
		}
		
		//if(pathForInsertion[0] in tree.internalTrees.name) {
		//if (flag) {	
		//	tree.numberOfFragments += 1;
		//	position = indexOf(tree.internalTrees, n);
		//	tree = tree.internalTrees[position];
		//	return insertPathOfNodesAndLeaf(tree, tail(pathForInsertion), pair);
		//}		
		//else {
		//	tree.numberOfFragments += 1;
		//	tree.internalTrees = tree.internalTrees + folderOrFile(pathForInsertion[0], 0, []);
		//	position = indexOf(tree.internalTrees, n);
			
		if (flag) {			
			tree.numberOfFragments += 1;
			for(n <- tree.internalTrees) if(n.name == pathForInsertion[0]) tree = n;
			return insertPathOfNodesAndLeaf(tree, tail(pathForInsertion), pair);
		}		
		else {
			//println("hey");
			tree.numberOfFragments += 1;
			tree.internalTrees = tree.internalTrees + folderOrFile(pathForInsertion[0], 0, []);
			for(n <- tree.internalTrees) if(n.name == pathForInsertion[0]) tree = n;		
			
					
			//println("shit");
			//println(tree);
			
			return insertPathOfNodesAndLeaf(tree, tail(pathForInsertion), pair);
		}
		
		//	return insertPathOfNodesAndLeaf(tree, tail(pathForInsertion), pair);
		//}
	}
}

ProjectStructure createFragment(tuple[loc l1, loc l2, int t] pair) {
	int bl = pair.l1.BL; 	
	int el = pair.l1.EL;
	id = pair.l1;
	clones = [<pair.l2, pair.typee>];
	return fragment(bl, el, id, clones);
}

//ProjectStructure incrementNodeCounter(ProjectStructure tree, str n) {
//	return visit(tree) {
//		case folderOrFile(n, numbNodes, _) => folderOrFile(n, numbNodes + 1 , _)	
//	}
//}

//ProjectStructure insertNewNode(ProjectStructure tree, str prevNode, str newNode) {
//	return visit(tree) {
//		case folderOrFile(prevNode, numbNodes, nodes) => folderOrFile(prevNode, numbNodes + 1 , nodes + folderOrFile(newNode, 0, []))	
//	}
//}

//bool nodeInTree(ProjectStructure tree, str n) {
//	top-down visit(tree) {
//				case folderOrFile(n, _, l) : return true;
//	}
//}

//ProjectStructure insertNode(ProjectStructure)

//bool fragmentInTree(ProjectStructure tree, loc l) {
//	visit(tree) {
//		case fragment(_, _, l, _) : return true;
//	}
//}
//
//ProjectStructure updateTree(ProjectStructure tree, loc l1, loc l2, int typee) {
//	return visit(tree) {
//		case fragment(_, _, l1, clones) => fragment(_, _, l1, clones + <l2,typee>)		
//	}
//}

//void test () {
//	loc project = |file:///C:/Users/andre/OneDrive/Documents/GitHub/LabSeries1/softEvolTest/src/softEvolTest/ClassA.java|(508,281,<18,1>,<28,2>);
//	str a = project.uri;
//	println(a);
//}