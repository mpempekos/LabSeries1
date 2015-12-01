module lab2

import analysis::m3::AST;
import analysis::m3::Core;
import lang::java::m3::AST;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import IO;
import Map;
import List;
import Set;
import Relation;
import util::Eval;

/*
 * Situation point: 
 * 		Type-1 might be working, need to be tested. 
 * 			TODO: create tests for check Type-1
 *		Ignoring already Type (ex: int, char, ...) from java variables
 *			TODO: ignore variables as well
 * 
 */
void run() {
	println("visiting AST...");
	project = |project://smallsql0.21_src|;
	//project = |project://softEvolTest|;
	set[Declaration] projectAST = createAstsFromEclipseProject(project, true);	
	map[node, list[node]] buckets = ();	
	
	// visit AST and put node in is corresponding bucket using is hashvalue	
	visit(projectAST) {		
		case node t: 
			if(treeMass(t) >= 30) { // MassThreshold: why 4 ???				
				node f = normalizeAST(t);
				//iprintln(f);									
				if(f in buckets && buckets[f] != []) {
					buckets[f] += f;
				}
				else {
					buckets[f] = [f];
				}			
				//println("++++++++++");	
			}						
	}
	println("checking for clones...");
	/*for(a <- domain(buckets)) {
		iprintln(size(buckets[a]));
	}*/	
	
	list[tuple[node n1,node n2]] clones = [];
	
	// for each bucket, check for clones	
	for(bucket <- domain(buckets)) {
		clones += lookForClones(buckets[bucket]);
		//println(size(clones));		
	}
	//for (r <- clones) {
		//iprintln(r);
	//}
	
	// print pairs of clones (ugly code)
	println("############################");	
	for(pair <- clones) {		
		if(Statement myDecl := pair.n2) {											
			loc l = myDecl@src;
			nodeLines = readFileLines(l);
			for(s <- nodeLines) println(s);									
		}	
		if(Declaration myDecl := pair.n2) {											
			loc l = myDecl@src;
			nodeLines = readFileLines(l);
			for(s <- nodeLines) println(s);									
		}
		println("...........................");		
		if(Statement myDecl := pair.n1) {											
			loc l = myDecl@src;
			nodeLines = readFileLines(l);
			for(s <- nodeLines) println(s);								
		}	
		if(Declaration myDecl := pair.n1) {											
			loc l = myDecl@src;
			nodeLines = readFileLines(l);
			for(s <- nodeLines) println(s);								
		}
		println("############################");			
	}
	
	println("<size(clones)> pairs of clones");
}

node normalizeAST(node t) {
	/*bottom-up visit(t){
		case TypeSymbol e1 => char()
	}*/
	return visit(t) { // normalize types and variables not working, see prints of ast				
				case Type _ => wildcard() // why wildcard() ??? need reason ???							
				//case Expression _ => \this() // to general, must specify more							
				case \assignment(_,_,_) => \this()
				case \fieldAccess(_,_,_) => \this()
				case \fieldAccess(_,_) => \this()
			}
}

list[tuple[node,node]] lookForClones(list[node] nodes) {	
	println("bucket size: <size(nodes)>");
	list[tuple[node n1, node n2]] clones = [];
	if(size(nodes) > 1) {
		//println("hey!");
		for(i <- [0..size(nodes)]) {
			for(j <- [i+1..size(nodes)]) {
				similarity = compareTrees(nodes[i], nodes[j]);								
				if (similarity >= 0.5) {//SimilarityThreshold: why 0.5 ???
					println("similarity : <similarity>");
					/*visit(nodes[i]){
						case node s1: {														
							for(tup <- clones) {
								if(tup.n1 == s1 || tup.n2 == s1) {
									clones -= tup;
									println("removed pair ");
								}
							} 													
						}
					}*/	
					/*visit(nodes[j]){
						case node s2: {	
							for(tup2 <- clones) {
								if(tup2.n1 == s1 || tup2.n2 == s1) {
									clones -= tup;
									println("removed pair ");
								}
							} 																
						}										
					}*/	
					println("added pair ");															
				    clones += <nodes[i],nodes[j]>;				    
				}
			}	
		}		
	}	
	println("clones found: <size(clones)>");
	return clones;
}

real compareTrees(node t1, node t2) {
	list[node] nodes1 = [];
	list[node] nodes2 = [];
	visit(t1) {
		//case Type _ : continue;
		case node n1: nodes1 += n1;
	}
	visit(t2) {
		//case Type _ : continue;
		case node n2: nodes2 += n2;
	}
	println("nodes1: <size(nodes1)>");	
	println("nodes2: <size(nodes2)>");	
	list[node] nodes = nodes1 & nodes2;
	int S = size(nodes);
	println("S: <S>");		
	int L = size(nodes1 - nodes2);
	println("L: <L>");
	int R = size(nodes2 - nodes1);
	println("R: <R>");
	real similarity = 2.0 * S / (2.0 * S + L + R);
	return similarity;
}

int treeMass(value tree) {
	int mass = 0;
	visit(tree) {
		case node t: {
			mass += 1;			
		}
	}
	return mass;	
}
	
/* ---- Basic Subtree Clone Detection Algorithm ----
	1. Clones={}
	2. For each subtree i:
		If mass(i)>=MassThreshold
		Then hash i to bucket
	3. For each subtree i and j in the same bucket
		If CompareTree(i,j) > SimilarityThreshold
			Then { For each subtree s of i
					 If IsMember(Clones,s)
					 Then RemoveClonePair(Clones,s)
				   For each subtree s of j
					 If IsMember(Clones,s)
					 Then RemoveClonePair(Clones,s)
				   AddClonePair(Clones,i,j)
				  }
				  	  
	Similarity = 2 x S / (2 x S + L + R)
	where:
		S = number of shared nodes
		L = number of different nodes in sub-tree 1
		R = number of different nodes in sub-tree 2
*/