module tests

import lab2;
import visualization;
import lang::java::m3::AST;
import IO;
import vis:: Figure;

void runTests() { 
	// lab2.rsc
	assert compareTrees_equalNodesSimilarity1() : "fail compareTrees_equalNodesSimilarity1";
	assert normalizeAST_diffNodesToEqual() : "fail normalizeAST_diffNodesToEqual";
	assert treeMass_NodeWithTreeMass1() : "fail treeMass_NodeWithTreeMass1";
	assert defineTypeOfClones_type1() : "fail defineTypeOfClones_type1";
	assert defineTypeOfClones_type2() : "fail defineTypeOfClones_type2";
	assert removeSubTreesClones_listWith1Node() : "fail removeSubTreesClones_listWith1Node";
	assert removeChildClones_2Pairs1Child() : "fail removeChildClones_2Pairs1Child";
	// visualization.rsc
	assert createTree_NoPairs() : "fail createTree_NoPairs";
	assert createTree_OnePair() : "fail createTree_OnePair";
	assert insert2Leaves_1EmptyTree1Pair() : "fail insert2Leaves_1EmptyTree1Pair";
	assert insertPathOfNodesAndLeaf_1Node1Leaf() : "fail insertPathOfNodesAndLeaf_1Node1Leaf";
	assert insertInSubTrees_1SubTree() : "fail insertInSubTrees_1SubTree";
	assert createFragment_test() : "fail createFragment_test";
	assert visualize_1Box() : "fail visualize_1Box";
}

//////////////
// lab2.rsc //
//////////////

bool compareTrees_equalNodesSimilarity1() {
	node n1 = \int();
	return 1.0 == compareTrees(n1, n1);	
}

bool normalizeAST_diffNodesToEqual() {
	node n1 = \int();
	node n2 = \boolean();
	n1 = normalizeAST(n1);
	node n3 = normalizeAST(n2);	
	return n1 != n2 && n1 == n3;
}

bool treeMass_NodeWithTreeMass1() {
	node n1 = \int();
	return 1 == treeMass(n1);	
}

bool defineTypeOfClones_type1(){		
	Statement n1 = \return();
	n1@src = |file:///C:/junit/TestAlterTable2.java|(1126,573,<41,4>,<50,5>);
	list[node] l = [n1, n1];
	t = defineTypeOfClones(l);
	return t[0].t == 1;
}

bool defineTypeOfClones_type2(){
	Statement n1 =\label("abc", \return());
	n1@src = |file:///C:/junit/TestAlterTable2.java|(1126,573,<41,4>,<50,5>);
	Statement n2 = \label("cba", \return());
	n2@src = |file:///C:/junit/TestAlterTable2.java|(1126,573,<41,4>,<50,5>);
	list[node] l = [n1, n2];
	t = defineTypeOfClones(l);
	return t[0].t == 2;
}

bool removeSubTreesClones_listWith1Node() {
	node n1 = \assert(\null());
	node n2 = \null();
	int t = 1;
	return [] == removeSubTreesClones(n1, [<n2, n2, t>]);
}

bool removeChildClones_2Pairs1Child() {
	list[tuple[node, node, int]] p = []; 
	node n1 = \assert(\null());	
	int t = 1;	
	p += [<n1, n1, t>];
	node n2 = \null();	
	p += [<n2, n2, t>];
	return [<n1, n1, t>] == removeChildClones(p);
}
//list[tuple[loc l1, loc l2, int t]] findClones(loc project) {
//bool defineTypeOfClones_type3(){
//}

///////////////////////
// visualization.rsc //
///////////////////////

//getLastSingleNode
bool visualize_1Box() {
	ProjectStructure tree = folderOrFile("junit", 0, []);
	loc l1 = |file:///C:/junit/TestAlterTable2.java|(1126,573,<41,4>,<50,5>);
	int t = 1;
	tuple[loc l1, int t] pair = <l1, t>;
	loc selectedFigLoc = |file:///C:/junit/TestAlterTable2.java|(1126,573,<41,4>,<50,5>);	
	Figure fig = treemap([],area(0), fillColor(rgb(94, 237, 111)));
	return fig == visualize(tree, [pair], selectedFigLoc);
}
//getColorFromType 
//colorClonedBox
bool createTree_NoPairs() {
	str rootName = "junit";	
	return folderOrFile(rootName, 0, []) == createTree([], rootName);
}

bool createTree_OnePair() {
	loc f1 = |file:///C:/junit/TestAlterTable2.java|(1126,573,<41,4>,<50,5>);
	loc f2 = |file:///C:/junit/TestAlterTable2.java|(2472,575,<71,4>,<80,5>);
	int t = 1;
	str rootName = "junit";	
	list[tuple[loc cloneLocation, int typee]] clones1 = [<f2, t>];
	list[tuple[loc cloneLocation, int typee]] clones2 = [<f1, t>];
	int bl1 = 41;
	int el1 = 50;
	int bl2 = 71;
	int el2 = 80;
	str subTreeName = "TestAlterTable2.java";
	int numberOfFragments = 2;
	ProjectStructure leaf1 = fragment(bl1, el1, f1, clones1);
	ProjectStructure leaf2 = fragment(bl2, el2, f2, clones2);
	ProjectStructure subTree = folderOrFile(subTreeName, numberOfFragments, [leaf1, leaf2]);	
	ProjectStructure tree = folderOrFile(rootName, 0, [subTree]);	
	return tree == createTree([<f1, f2, t>], rootName);
}

bool insert2Leaves_1EmptyTree1Pair() {
	str rootName = "junit";
	ProjectStructure tree = folderOrFile(rootName, 0, []);
	loc l1 = |file:///C:/junit/TestAlterTable2.java|(1126,573,<41,4>,<50,5>);
	loc l2 = |file:///C:/junit/TestAlterTable2.java|(2472,575,<71,4>,<80,5>);
	int t = 1;
	tuple[loc l1, loc l2, int t] pair = <l1, l2, t>;
	list[tuple[loc cloneLocation, int typee]] clones1 = [<l2, t>];
	list[tuple[loc cloneLocation, int typee]] clones2 = [<l1, t>];
	int bl1 = 41;
	int el1 = 50;
	int bl2 = 71;
	int el2 = 80;
	str subTreeName = "TestAlterTable2.java";
	int numberOfFragments = 2;
	ProjectStructure leaf1 = fragment(bl1, el1, l1, clones1);
	ProjectStructure leaf2 = fragment(bl2, el2, l2, clones2);
	ProjectStructure subTree = folderOrFile(subTreeName, numberOfFragments, [leaf1, leaf2]);	
	ProjectStructure expectedTree = folderOrFile(rootName, 0, [subTree]);	
	return expectedTree == insert2Leaves(tree, pair, rootName);
}

bool insertPathOfNodesAndLeaf_1Node1Leaf() {
	str rootName = "junit";
	ProjectStructure tree = folderOrFile(rootName, 0, []);
	list[str] pathForInsertion = ["TestAlterTable2.java"];
	loc l1 = |file:///C:/junit/TestAlterTable2.java|(1126,573,<41,4>,<50,5>);
	loc l2 = |file:///C:/junit/TestAlterTable2.java|(2472,575,<71,4>,<80,5>);
	int t = 1;
	tuple[loc l1, loc l2, int t] pair = <l1, l2, t>;
	fragmentAdded = false;
	list[tuple[loc cloneLocation, int typee]] clones1 = [<l2, t>];
	int bl1 = 41;
	int el1 = 50;
	str subTreeName = "TestAlterTable2.java";
	int numberOfFragments = 1;
	ProjectStructure leaf1 = fragment(bl1, el1, l1, clones1);
	ProjectStructure subTree = folderOrFile(subTreeName, numberOfFragments, [leaf1]);	
	ProjectStructure expectedTree = folderOrFile(rootName, 0, [subTree]);	
	return <expectedTree, true> == insertPathOfNodesAndLeaf(tree, pathForInsertion, pair, fragmentAdded); 
}

bool insertInSubTrees_1SubTree() {
	str rootName = "junit";
	ProjectStructure tree = folderOrFile(rootName, 0, []);
	loc l1 = |file:///C:/junit/TestAlterTable2.java|(1126,573,<41,4>,<50,5>);
	loc l2 = |file:///C:/junit/TestAlterTable2.java|(2472,575,<71,4>,<80,5>);
	int t = 1;
	tuple[loc l1, loc l2, int t] pair = <l1, l2, t>;
	fragmentAdded = true;
	list[tuple[loc cloneLocation, int typee]] clones1 = [<l2, t>];
	int bl1 = 41;
	int el1 = 50;
	str subTreeName = "TestAlterTable2.java";
	int numberOfFragments = 1;
	ProjectStructure leaf1 = fragment(bl1, el1, l1, clones1);
	ProjectStructure subTree = folderOrFile(subTreeName, numberOfFragments, [leaf1]);	
	tuple[ProjectStructure, bool] pairSubTreeFragmentAdded = <subTree, fragmentAdded>;	
	ProjectStructure expectedTree = folderOrFile(rootName, 0, [subTree]);
	return <expectedTree, fragmentAdded> == insertInSubTrees(tree, pairSubTreeFragmentAdded);	
}

bool createFragment_test() {
	loc l1 = |file:///C:/junit/TestAlterTable2.java|(1126,573,<41,4>,<50,5>);
	loc l2 = |file:///C:/junit/TestAlterTable2.java|(2472,575,<71,4>,<80,5>);
	int t = 1;
	int bl1 = 41;
	int el1 = 50;
	list[tuple[loc cloneLocation, int typee]] clones1 = [<l2, t>];
	tuple[loc l1, loc l2, int t] pair = <l1, l2, t>;
	ProjectStructure leaf1 = fragment(bl1, el1, l1, clones1);
	return leaf1 == createFragment(pair);
}