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


// @ Andre: almost everything is done...i managed to return to the main method the actual root of the tree...but the problem is as i told u
//on whats app that this is always null...take a look at lines 225-232....the insertion seems ok.... we have to see y it is not working...
// to be continued tomorrow....
// also take a look at line 253 - 260....

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
		  	
		  	// edw case leaf???
		  			  	
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
	
	println("***************************");
	println("**Final fuckin tree below**");
	println("***************************");
	
	println(tree);
	
	//render(visualize(tree));
}

data ProjectStructure = fragment(int bl, int el, list[tuple[loc cloneLocation, int typee]] clones)	// insert id again!
| folderOrFile(str name, int numberOfFragments, list[ProjectStructure] internalTrees, list [ProjectStructure] previous);


ProjectStructure createTree(list[tuple[loc l1, loc l2, int t]] clonePairs, str rootNode) {
	ProjectStructure tree = folderOrFile(rootNode, 0, [], []);
	
	println(tree);
		
	//for(pair <- clonePairs) {
	
		pair = clonePairs[0];
			
		tree = insert2Leafs(tree, pair, rootNode);		// i changed this...
		
					
	//}
	return tree;
}

ProjectStructure insert2Leafs(ProjectStructure tree, tuple[loc l1, loc l2, int t] pair, str rootNode) {	
	int pos = findFirst(pair.l1.uri, rootNode);
	str aux = pair.l1.uri[pos+size(rootNode)+1..];	
	list[str] pathForInsertion = split("/",aux);
	str aux1 = pair.l2.uri[pos+size(rootNode)+1..];		
	list[str] pathForInsertion1 = split("/",aux1);
	
	println(pathForInsertion);
	
	tree = insertPathOfNodesAndLeaf(tree, pathForInsertion, pair);	
	//tree = insertPathOfNodesAndLeaf(tree, pathForInsertion1, pair);	
		
	return tree;
}


ProjectStructure insertPathOfNodesAndLeaf(ProjectStructure tree, list[str] pathForInsertion, tuple[loc l1, loc l2, int t] pair) {

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
		
		if (!flag2) {						// new leaf to be inserted....
			println("I am inserting a leaf...");
			tree.numberOfFragments += 1;
			ProjectStructure fragment = createFragment(pair);
			tree.internalTrees = tree.internalTrees + fragment;
		}
		
		
		// y the fuck do we return this?????		
		
		while (!isEmpty(tree.previous)) {
		
		println("ektypwnw to previous...");
		println(tree.previous);
		println("...................");
		
			tree = tree.previous[0];
		
		}
		
		return tree;
	}
	
	else { 		//time for a node
	
		
		bool flag = false;
		
		visit(tree.internalTrees) {
		
			// below needs to break....maybe nested staff...
					
			case folderOrFile(name,numberOfFragments, internalTrees, previous): if (name == pathForInsertion[0] ) flag = true;
		
		}
		
		
		// below just DOES NOT WORK!
		
	/*	for(i <- tree.internalTrees) {
		
			println(i.name);
			//println(pathForInsertion[0]);		
			
			if (i.name == pathForInsertion[0]) {
				flag = true;
				break;
			}   
		}*/

			
		if (flag) {		
		
			println("Node exists!");	
			tree.numberOfFragments += 1;
			for(n <- tree.internalTrees) if(n.name == pathForInsertion[0]) tree = n;
			return insertPathOfNodesAndLeaf(tree, tail(pathForInsertion), pair);
		}		
		
		else {
			println("Node doesnt exist! I will add <pathForInsertion[0]>");
			tree.numberOfFragments += 1;
			
			
			tree.internalTrees = tree.internalTrees + folderOrFile(pathForInsertion[0], 0, [], []+tree);
			
			
			//for(n <- tree.internalTrees) if(n.name == pathForInsertion[0]) tree = n;					////
			
			println("After insertion");
			println("for the tree <tree> i have <tree.internalTrees>");
		
			
			visit(tree.internalTrees) {
		
			// below needs to break....maybe nested staff...
					
			case folderOrFile(name,numberOfFragments, internalTrees,previous): if (name == pathForInsertion[0] ) tree = folderOrFile(name,numberOfFragments, internalTrees,previous);
		
		}
			
			return insertPathOfNodesAndLeaf(tree, tail(pathForInsertion), pair);
		}
		
	}
}

ProjectStructure createFragment(tuple[loc l1, loc l2, int t] pair) {

	/* wtf r u doin here????? */
	int bl = 0; int el = 0;
	//int bl = pair.l1.BL; 	
	//int el = pair.l1.EL;
	
	// only for now remove this....	// from the type of the leaf as well...
	
	//id = pair.l1;
	
	clones = [<pair.l2, pair.t>];
	return fragment(bl, el, clones);	// needs an id
}

//ProjectStructure incrementNodeCounter(ProjectStructure tree, str n) {
//	return visit(tree) {
//		case folderOrFile(n, numbNodes, _) => folderOrFile(n, numbNodes + 1 , _)	
//	}
//}


//bool nodeInTree(ProjectStructure tree, str n) {
//	top-down visit(tree) {
//				case folderOrFile(n, _, l) : return true;
//	}
//}

//bool fragmentInTree(ProjectStructure tree, loc l) {
//	visit(tree) {
//		case fragment(_, _, l, _) : return true;
//	}
//}
//
//void test () {
//	loc project = |file:///C:/Users/andre/OneDrive/Documents/GitHub/LabSeries1/softEvolTest/src/softEvolTest/ClassA.java|(508,281,<18,1>,<28,2>);
//	str a = project.uri;
//	println(a);
//}