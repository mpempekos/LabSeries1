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

Figure formBoxes(ProjectStructure nodee) {

	Figure fig ;
		
	switch (nodee) {
		case folderOrFile(name,N,internalNodes): 
			fig = box(vcat([text(nodee.name),visualize(nodee)]), area(nodee.numberOfFragments));
			
		case fragment(bl, el, l, _):	// fragment(list(clones)) 
			
			fig = box(text("<bl>,<el>"),id("1"),area(1));	// to do --> fillColor...
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
		  	// edw case leaf???		  			  
		  	fig = treemap(figs);		  	
		}			
		//case fragment(name): fig = box(text(name),area(1));
	}	
	return fig;
}
/* src will be the last single node in the tree... */

void runVisualization() {
	list[tuple[loc l1, loc l2, int t]] clones;
	clones = findClones(|project://softEvolTest|, 30); // why 30??
	ProjectStructure tree = createTree(clones, "softEvolTest");	
	println("final tree: <tree>");	
	render(visualize(tree));
}

data ProjectStructure = fragment(int bl, int el, loc l, list[tuple[loc cloneLocation, int typee]] clones)	// insert id again!
| folderOrFile(str name, int numberOfFragments, list[ProjectStructure] internalTrees);


ProjectStructure createTree(list[tuple[loc l1, loc l2, int t]] clonePairs, str rootName) {
	// create root node
	ProjectStructure root = folderOrFile(rootName, 0, []);	
	
	// insert pairs of clones in the tree
	for(pair <- clonePairs) root = insert2Leafs(root, pair, rootName);	
			
	return root;
}

ProjectStructure insert2Leafs(ProjectStructure tree, tuple[loc l1, loc l2, int t] pair, str rootNode) {	
	int pos = findFirst(pair.l1.uri, rootNode);
	str aux = pair.l1.uri[pos+size(rootNode)+1..];	
	list[str] pathForInsertion = split("/",aux);
	tree = insertPathOfNodesAndLeaf(tree, pathForInsertion, pair);
	//println("FIRST ELEM OF PAIR CLONE ADDED: <tree>");
	
	tuple[loc l1, loc l2, int t] reversedPair = <pair.l2, pair.l1, pair.t>;			
	str aux1 = pair.l2.uri[pos+size(rootNode)+1..];		
	list[str] pathForInsertion1 = split("/",aux1);
	tree = insertPathOfNodesAndLeaf(tree, pathForInsertion1, reversedPair);	
	//println("SECOND ELEM OF PAIR CLONE ADDED: <tree>");	
				
	return tree;
}


ProjectStructure insertPathOfNodesAndLeaf(ProjectStructure tree, list[str] pathForInsertion, tuple[loc l1, loc l2, int t] pair) {	
	if(isEmpty(pathForInsertion)) {		// time for add a leaf	
		
		bool flag2 = false;
		for(i <- tree.internalTrees) {			
			if (pair.l1 == i.l) {				
				i.clones += [<pair.l2,pair.t>];
				flag2 = true;
				break;
			}
		}
		
		//println("fragment flag: <flag2>");
		
		if (!flag2) {	// new leaf to be inserted....												
			ProjectStructure fragment = createFragment(pair);
			//println("before: <tree>");
			tree.numberOfFragments = tree.numberOfFragments + 1;			
			tree.internalTrees = tree.internalTrees + fragment;
			//println("leaf: <tree>");
		}
						
		return tree;
	}
	
	else { 		//time for a node			
		bool flag = false;
		
		visit(tree) {		
			// below needs to break....maybe nested staff...				
			case folderOrFile(name, _, _): if (name == pathForInsertion[0] ) flag = true;		
		}
		
		//println(flag);					
			
		if (flag) {	 // Node already existis. add 1 to numberOfFragments			
			//println("Node exists!");						
			//println(tree);		
				
			ProjectStructure originalTree = tree;			
			visit (tree) {
				case folderOrFile(x, y, z) :  if (x == pathForInsertion[0]) tree = folderOrFile(pathForInsertion[0], y, z);				
			}
			
			tree.numberOfFragments = tree.numberOfFragments + 1;
			
			//println("newTree: <tree>");
			
			//for(n <- tree.internalTrees) if(n.name == pathForInsertion[0]) tree = n;			
			
			//return insertPathOfNodesAndLeaf(tree, tail(pathForInsertion), pair);
			return insertInSubTrees(originalTree, insertPathOfNodesAndLeaf(tree, tail(pathForInsertion), pair));		
		}		
		
		else { // Node doesn't exit yet. create it			
			tree.numberOfFragments = tree.numberOfFragments + 1;									
			newNode = folderOrFile(pathForInsertion[0], 0, []);	
			return insertInSubTrees(tree, insertPathOfNodesAndLeaf(newNode, tail(pathForInsertion), pair));
		}		
	}
}

ProjectStructure insertInSubTrees(ProjectStructure tree, ProjectStructure subTree) {
	bool flag = false;
		
	visit(tree.internalTrees) {	
		case folderOrFile(x, y, z) : if(x == subTree.name) flag = true; 
	}
	
	if (!flag) {
		tree.numberOfFragments = tree.numberOfFragments + 1;
		tree.internalTrees = tree.internalTrees + subTree;
	} else { // update list of leaves
	
		//println("Internal trees below...");
		//println(tree.internalTrees);
		ProjectStructure updatedNode = folderOrFile("error", 0, []); 
		visit(tree.internalTrees) {
			case folderOrFile(x, y, z) : if(x == subTree.name) {
				tree.internalTrees = tree.internalTrees - folderOrFile(x, y, z);
				updatedNode = folderOrFile(x, y, subTree.internalTrees);
			}
		}
		tree.numberOfFragments = tree.numberOfFragments + 1;
		tree.internalTrees = tree.internalTrees + updatedNode;
	}
	return tree;
}

ProjectStructure createFragment(tuple[loc l1, loc l2, int t] pair) {	
	return fragment(pair.l1.begin.line, pair.l1.end.line, pair.l1, [<pair.l2, pair.t>]);
}