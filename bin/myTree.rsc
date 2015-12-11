module myTree

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
import ListRelation;
import visualization;

ProjectStructure createTree(list[tuple[loc l1, loc l2, int t]] clonePairs, str rootName) {
	// create root node
	ProjectStructure root = folderOrFile(rootName, 0, []);	
	
	// insert pairs of clones in the myTree
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
		
		if (!flag2) {	// new leaf to be inserted....												
			ProjectStructure fragment = createFragment(pair);			
			tree.internalTrees = tree.internalTrees + fragment;			
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
			ProjectStructure originalTree = tree;			
			visit (tree) {
				case folderOrFile(x, y, z) :  if (x == pathForInsertion[0]) tree = folderOrFile(pathForInsertion[0], y, z);				
			}
			
			return insertInSubTrees(originalTree, insertPathOfNodesAndLeaf(tree, tail(pathForInsertion), pair));		
		}		
		
		else { // Node doesn't exit yet. create it			
			//tree.numberOfFragments = tree.numberOfFragments + 1;									
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
		subTree.numberOfFragments = subTree.numberOfFragments + 1;
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
		updatedNode.numberOfFragments = updatedNode.numberOfFragments + 1;
		tree.internalTrees = tree.internalTrees + updatedNode;
	}
	
	//tree.numberOfFragments = tree.numberOfFragments + 1;
	return tree;
}

ProjectStructure createFragment(tuple[loc l1, loc l2, int t] pair) {	
	return fragment(pair.l1.begin.line, pair.l1.end.line, pair.l1, [<pair.l2, pair.t>]);
}