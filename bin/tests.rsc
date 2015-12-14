module tests

import lab2;
import visualization;
import lang::java::m3::AST;

bool runTests() {
	return 
		compareTrees_equalNodesSimilarity1() &&
		normalizeAST_diffNodesToEqual() &&
		treeMass_NodeWithTreeMass1() &&
		defineTypeOfClones_type1() &&
		defineTypeOfClones_type2() &&
		removeSubTreesClones_listWith1Node() &&
		removeChildClones_2Pairs1Child();
}

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