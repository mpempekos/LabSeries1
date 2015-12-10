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
import ListRelation;
//import myTree;
import vis::KeySym;

public map[loc,Figure] leavesToBoxes = ();
public Figure fig;
public ProjectStructure originalTree;


/* src will be the last single node in the tree... */

void runVisualization() {
	list[tuple[loc l1, loc l2, int t]] clones;

	clones = findClones(|project://softEvolTest|, 30); // why 30??
	//clones = findClones(|project://smallsql0.21_src|, 30);
	//clones = findClones(|project://hsqldb-2.3.1|, 30);
	ProjectStructure tree = getLastSingleNode(createTree(clones, "softEvolTest"));	
	
	originalTree = tree;
	//println("final tree: <tree>");	
	
	
	render(visualize(tree,[]));
}

ProjectStructure getLastSingleNode(ProjectStructure tree) {
	top-down visit(tree) {
		case folderOrFile(name,numberOfFragments,internalTrees): 
				if (size(internalTrees) != 1) {
					tree = folderOrFile(name,numberOfFragments,internalTrees);
					return tree;
					}
	}

	return tree;
}


Figure visualize(ProjectStructure tree,list[tuple[loc l1, int t]] clones) {
	
	switch (tree) {
		case folderOrFile(name,N,internalNodes): { 
			Figures figs = [];
			
			for (i <- internalNodes){
			  	figs += visualize(i,clones);
		  	}
				  			  
		  	fig = box(vcat([text(name),treemap(figs)]),area(N));	  	
		}			
		
		case fragment(bl, el, l, clones2): {	
		
		//println("Fragment <l> has these clones: <clones2>");
		
			if (l in clones.l1) 
				fig = box(text("<bl>,<el>"),id("<l>"),area(1),fillColor("red"));
		
			else {
			
			c = false;			
			
	//		fig = box(text("<bl>,<el>"),id("<l>"),area(1),fillColor(Color () { return c ? color("yellow") : color("white"); }),
	//onMouseEnter(void () { c = true; colorClones(clones2,originalTree); }), onMouseExit(void () { c = false ; })
	//,shrink(0.5));
	
	
	// BUGGGGG!!
		
	fig = box(text("<bl>,<el>"),id("<l>"),area(1),fillColor("white"),
	onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
		colorClones(clones2,originalTree);
		
		return true;
	}));
	
	// on click....get from map the leaves u want.... and color the boxes
			}		
				leavesToBoxes += (l:fig);
	
		}
	}	
	
	
	return fig;
}


void colorClones(list[tuple[loc cloneLocation, int typee]] clones,ProjectStructure tree) {
	
	leavesToBoxes = ();
	render(visualize(tree,clones));
	
}



data ProjectStructure = fragment(int bl, int el, loc l, list[tuple[loc cloneLocation, int typee]] clones)	// insert id again!
| folderOrFile(str name, int numberOfFragments, list[ProjectStructure] internalTrees);



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
	if(isEmpty(pathForInsertion)) {		// time to add a leaf			
		bool flag2 = false;
		for(i <- tree.internalTrees) {			
			if (pair.l1 == i.l) {			
			
			println("**********************");
			println("Before add: <i.clones>");	
				
				
				i.clones += [<pair.l2,pair.t>];
				
				//below is added indeed...
				
			println("After add: <i.clones>");	
			println("**********************");
			
				flag2 = true;
				break;
			}
		}			
		
		if (!flag2) {	// new leaf to be inserted....												
			ProjectStructure fragment = createFragment(pair);			
			tree.internalTrees = tree.internalTrees + fragment;			
		}
		
		// but in the tree returned it's not...
		println(tree);
						
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