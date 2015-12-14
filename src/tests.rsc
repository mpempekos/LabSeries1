module tests

import lab2;
import visualization;
import lang::java::m3::AST;

void runTests() {
	
}

bool compareTrees_equalNodesSimilarity1() {
	node n1 = \int();
	node n2 = \int();
	return 1.0 == compareTrees(n1, n2);	
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

//removeSubTreesClones

bool defineTypeOfClones_type1(){
	node n1 = \int();
	node n2 = \int();
	list[node] l = [n1, n2];
	t = defineTypeOfClones(l);
	//t[0].
}

//removeChildClones

//findClones