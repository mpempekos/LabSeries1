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
 *		* Type-1 and Type-2 clones probably done  		
 * 				TODO: create tests for Type-1 and Type-2
 *		* Question: Already Finding Clone Sequences??? test
 *		* Changed hash function to treeMass. Consequences:
 *				Detecting Type-3 clones but just clones with changed 
 *					position lines
 *				inefficiency: comparing a lot of garbage
 *				problem: leaving out important comparations:
 *					when |lines added - lines removed| != 0 
 *					(still type-3 clones right???)
 */
void run() {
	println("visiting AST...");
	//sproject = |project://hsqldb-2.3.1|;
	project = |project://smallsql0.21_src|;
	//project = |project://softEvolTest|;
	set[Declaration] projectAST = createAstsFromEclipseProject(project, true);	
	map[node, list[node]] buckets = ();	
	
	// visit AST and put node in is corresponding bucket using is hashvalue	
	visit(projectAST) {		
		case node t: 
			if(Declaration _ := t || Statement _ := t) { // explain why???
				mass = treeMass(t);
				if(mass >= 30) { // MassThreshold: why 30 ???				
					node f = normalizeAST(t);
					//iprintln(f);									
					if(f in buckets && buckets[f] != []) {
						buckets[f] += f;
					}
					else {
						buckets[f] = [f];
					}								
				}
			}						
	}
	println("checking for clones...");
	//for(a <- domain(buckets)) println(size(buckets[a]));	
	
	list[tuple[node n1,node n2]] newClones = [];
	//node domain(buckets)
	
	// for each bucket, check for clones	
	for(bucket <- domain(buckets)) {
		newClones += lookForClones(buckets[bucket]);		
		//println(size(clones));		
	}	
	
	println("removing child clones...");
	clones = removeChildClones(newClones);
	
	// print pairs of clones (ugly code)
	println("############################");	
	for(pair <- clones) {				
		if(Statement myDecl := pair.n1) {													
			loc l = myDecl@src;
			println("loc: <l>");
			println("...........................");
			nodeLines = readFileLines(l);
			for(s <- nodeLines) println(s);								
		}	
		if(Declaration myDecl := pair.n1) {											
			loc l = myDecl@src;
			println("loc: <l>");
			println("...........................");
			nodeLines = readFileLines(l);
			for(s <- nodeLines) println(s);										
		}
		println("############################");	
		if(Statement myDecl := pair.n2) {												
			loc l = myDecl@src;
			println("loc: <l>");
			println("...........................");
			nodeLines = readFileLines(l);
			for(s <- nodeLines) println(s);								
		}	
		if(Declaration myDecl := pair.n2) {											
			loc l = myDecl@src;
			println("loc: <l>");
			println("...........................");
			nodeLines = readFileLines(l);
			for(s <- nodeLines) println(s);										
		}
		println("############################");	
		println("############################");
		println("############################");		
	}
	
	println("<size(clones)> pairs of clones found");
}

list[tuple[node n1,node n2]] removeChildClones(list[tuple[node n1,node n2]] clones) {
	list[tuple[node n1,node n2]] finalClones = clones;	
	for(pairClones <- clones) {	
		//println("//");	
		//aux = removeSubTreesClones(pairClones.n1, finalClones);	COMMENT ONLY TEMPORARLY!!!	
		//for(pairClones2 <- aux) println("<treeMass(pairClones2.n1)>:<treeMass(pairClones2.n2)>");
		//println("##");
		finalClones = removeSubTreesClones(pairClones.n2, finalClones);	// JUST CONSIDERING 1 ELEM OF TUPLE BECAUSE THEY ARE EQUAL	 
	}
	return finalClones;
}	

list[tuple[node n1,node n2]] removeSubTreesClones(node cloneTree, list[tuple[node n1,node n2]] clones) {	
	//println("<treeMass(cloneTree)> , <size(clones)>");		
	visit(cloneTree){
		case node s1: {	
			if (treeMass(cloneTree) != treeMass(s1)) {
				//println("node size: <treeMass(s1)>");															
				for(tup <- clones) {
					if(tup.n1 == s1 || tup.n2 == s1) {
						//println("size:<treeMass(s1)>");						
						clones -= tup;					
					}
				}
			}																	
		}
	}
	return clones;
}

node normalizeAST(node t) {
	return visit(t) { // normalize types and variables not working, see prints of ast				
				case Type _ => wildcard() // why wildcard() ??? need reason ???														
				case str _ => "" // probably to much generalized???
				case int _ => 1	
				//case bool _ => true				
			}
}

list[tuple[node,node]] lookForClones(list[node] nodes) {	
	//println("bucket size: <size(nodes)>");
	list[tuple[node n1, node n2]] clones = [];
	real pairs = 1.0;
	real allSim = 0.0;
	if(size(nodes) > 1) {
		//println("hey!");
		for(i <- [0..size(nodes)]) {
			for(j <- [i+1..size(nodes)]) {
				//similarity = compareTrees(nodes[i], nodes[j]);
				//allSim += similarity;	
				//pairs += 1;
				////println("similarity : <similarity>");							
				//if (similarity >= 0.9) {//SimilarityThreshold: why 0.9 ???														
				    clones += <nodes[i],nodes[j]>;				    				   
				//}
			}	
		}		
	}	
	//println(allSim/pairs);
	//println("clones found: <size(clones)>");
	//cleanClones = removeChildClones(clones);
	return clones;//cleanClones;
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
	//println("nodes1: <size(nodes1)>");	
	//println("nodes2: <size(nodes2)>");	
	list[node] nodes = nodes1 & nodes2;
	int S = size(nodes);
	//println("S: <S>");		
	int L = size(nodes1 - nodes2);
	//println("L: <L>");
	int R = size(nodes2 - nodes1);
	//println("R: <R>");
	real similarity = 2.0 * S / (2.0 * S + L + R);
	return similarity;
}

int treeMass(node tree) {
	int mass = 0;
	visit(tree) {
		case node t: {
			mass += 1;			
		}
	}
	return mass;	
}

/*
find type-3 clones using Program Dependence Graph (PDG) 
and Program Slicing:

Step 1: Find relevant procedures/methods
Step 2: Find pair of vertices with equivalent
syntactic structure
Step 3: Find clones
Step 4: Group clones
*/