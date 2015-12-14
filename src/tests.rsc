module tests

import lab2;
import visualization;
import lang::java::m3::AST;
import IO;

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
	node n1 = \int();	
	list[node] l = [n1, n1];
	t = defineTypeOfClones(l);
	return t[0].t == 1;
}

bool defineTypeOfClones_type2(){
	node n1 = \int();
	node n2 = \boolean();
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

//bool defineTypeOfClones_type3(){
//}

//findClones

///////////////////////
// visualization.rsc //
///////////////////////

//getLastSingleNode

//visualize

//getColorFromType

//colorClonedBox

//data ProjectStructure = fragment(int bl, int el, loc l, list[tuple[loc cloneLocation, int typee]] clones)
//| folderOrFile(str name, int numberOfFragments, list[ProjectStructure] subFolders);

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

// tuple[ProjectStructure tree, bool fragmentAdded] insertPathOfNodesAndLeaf(ProjectStructure tree, list[str] pathForInsertion, tuple[loc l1, loc l2, int t] pair, bool fragmentAdded) {	

// tuple[ProjectStructure,bool] insertInSubTrees(ProjectStructure tree, tuple[ProjectStructure subTree, bool fragmentAdded] pairSubTreeFragmentAdded) {

// ProjectStructure createFragment(tuple[loc l1, loc l2, int t] pair) {	
