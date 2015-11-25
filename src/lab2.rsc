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

void run() {
	project = |project://softEvolTest|;
	set[Declaration] projectAST = createAstsFromEclipseProject(project, true);	
	map[node, list[node]] buckets = ();	
	
	visit(projectAST) {		
		case node t: if(treeMass(t) >= 15) { // MassThreshold number???	
			if(t in buckets && buckets[t] != []) {
				buckets[t] += t;
			}
			else {
				buckets[t] = [t];
			}			
			//println("++++++++++");					
		}
	}
	
	/*for(a <- domain(buckets)) {
		iprintln(size(buckets[a]));
	}*/	
	
	list[tuple[node,node]] clones = [];
	
	for(bucket <- domain(buckets)) {
		clones += lookForClones(buckets[bucket]);
		//println(size(clones));		
	}
	//for (r <- clones) {
		//iprintln(r);
	//}
	
	iprintln(size(clones));
}

list[tuple[node,node]] lookForClones(list[node] nodes) {	
	println("list[node] size: <size(nodes)>");
	list[tuple[node n1, node n2]] clones = [];
	if(size(nodes) > 1) {
		println("hey!");
		for(i <- [0..size(nodes)]) {
			for(j <- [i+1..size(nodes)]) {
				similarity = compareTrees(nodes[i], nodes[j]);								
				if (similarity >= 0.5) {//SimilarityThreshold ???
					println("similarity : <similarity>");
					
					/*
					visit(nodes[i]){
						case node s1: {														
							for(tup <- clones) {
								if(tup.n1 == s1 || tup.n2 == s1) {
									clones = delete(clones, tup);
								}
							} 
							//clones -= domainR(clones, {s1}); 
							//clones -= rangeR(clones, {s1}); 							
						}
					}	
					visit(nodes[j]){
						case node s2: {	
							for(tup2 <- clones) {
								if(tup2.n1 == s1 || tup2.n2 == s1) {
									clones = delete(clones, tup2);
								}
							} 									
							//clones -= domainR(clones, {s2}); 
							//clones -= rangeR(clones, {s2});					
						}										
					}	
					
					*/
					//println("Just added a pair");															
				    clones += <nodes[i],nodes[j]>;				    
				}
			}	
		}		
	}	
	println("end: <size(clones)>");
	return clones;
}

real compareTrees(node t1, node t2) {
	list[node] nodes1 = [];
	list[node] nodes2 = [];
	visit(t1) {
		case node n1: nodes1 += n1;
	}
	visit(t2) {
		case node n2: nodes2 += n2;
	}
	list[node] nodes = nodes1 & nodes2;
	int S = size(nodes);	
	//iprintln(nodes);
	//int L = size(toSet(nodes1));
	int L = size(nodes1 - nodes2);
	//int R = size(toSet(nodes2));
	int R = size(nodes2 - nodes1);
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