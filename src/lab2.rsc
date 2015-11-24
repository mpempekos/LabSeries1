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

void run() {
	project = |project://softEvolTest|;
	set[Declaration] projectAST = createAstsFromEclipseProject(project, true);	
	map[node, list[node]] buckets = ();	
	
	visit(projectAST) {
		// MassThreshold number???		
		case node t: if(treeMass(t) >= 2) {
			if(t in buckets && buckets[t] != []) {
				buckets[t] += t;
			}
			else {
				buckets[t] = [t];				
			}
			//if (size(buckets[t]) == 2) {
				//iprintln(buckets[t]);
			//}
			iprintln(size(buckets[t]));
			println("++++++++++");					
		}
	}
	
	for(bucket <- domain(buckets)) {
		lookForClones(buckets[bucket]);		
	}
}

void lookForClones(list[node] nodes) {
	if(size(nodes) > 1) {
		for(i <- [0..size(nodes)]) {
			for(j <- [i+1..size(nodes)]) {
				similarity = compareTrees(nodes[i], nodes[j]);				
	//			println("similarity : <similarity>");	
			}		
		}
	}
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
	int L = size(toSet(nodes1));
	int R = size(toSet(nodes2));
	//println("L is <L>");
	//println("R is <R>");
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