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
 * Steps:
 * 		1- Visit project AST and put nodes to buckets
 *			1.1- Normalize node to find type-2 clones
 *		2- For each bucket, check in pairs for clones
 * 			2.1- 
 *
 * Situation point: 
 * 		Type-1 might be working, need to be tested. 
 * 			TODO: create tests for check Type-1
 *		Ignoring already Type (ex: int, char, ...) from java variables
 *			TODO: ignore variables as well
 * 		TODO: Find Clone Sequences
 *		Problem: Not removing child clones (clones inside clones)
 * 		Problem: Similarity nort working
 */
void run() {
	println("visiting AST...");
	//project = |project://smallsql0.21_src|;
	project = |project://softEvolTest|;
	set[Declaration] projectAST = createAstsFromEclipseProject(project, true);	
	map[node, list[node]] buckets = ();	
	
	// visit AST and put node in is corresponding bucket using is hashvalue	
	visit(projectAST) {		
		case node t: 
			if(treeMass(t) >= 30) { // MassThreshold: why _ ???				
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
		newClones = lookForClones(buckets[bucket]);
		/*for(clonePair <- newClones) {
			removeSubTrees(newClones);
			
		}*/		
		clones += newClones;
		//println(size(clones));		
	}			
	
	// print pairs of clones (ugly code)
	println("############################");	
	for(pair <- clones) {		
		if(Statement myDecl := pair.n2) {											
			loc l = myDecl@src;
			println("loc: <l>");
			println("############################");
			nodeLines = readFileLines(l);
			for(s <- nodeLines) println(s);									
		}	
		if(Declaration myDecl := pair.n2) {											
			loc l = myDecl@src;
			println("loc: <l>");
			println("############################");
			nodeLines = readFileLines(l);
			for(s <- nodeLines) println(s);									
		}
		println("...........................");		
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
	}
	
	println("<size(clones)> pairs of clones");
}

/*list[tuple[node n1,node n2]] removeChildClones(list[tuple[node n1,node n2]] clones) {
	list[tuple[node n1,node n2]] finalClones = clones;	
	for(pairClones <- clones) {	
		println("//");	
		aux = removeSubTreesClones(pairClones.n1, finalClones);		
		//for(pairClones2 <- aux) println("<treeMass(pairClones2.n1)>:<treeMass(pairClones2.n2)>");
		println("##");
		finalClones = removeSubTreesClones(pairClones.n2, aux);		 
	}
	return finalClones;
}	

list[tuple[node n1,node n2]] removeSubTreesClones(node cloneTree, list[tuple[node n1,node n2]] clones) {	
	println("<treeMass(cloneTree)> , <size(clones)>");	
	visit(cloneTree){
		case node s1: {	
			println("node size: <treeMass(s1)>");															
			for(tup <- clones) {
				if(tup.n1 == s1 || tup.n2 == s1) {
					println("size:<treeMass(s1)>");						
					clones -= tup;					
				}
			} 																	
		}
	}
	return clones;
}*/

node normalizeAST(node t) {
	/*bottom-up visit(t){
		case TypeSymbol e1 => char()
	}*/
	return visit(t) { // normalize types and variables not working, see prints of ast				
				/*
				
				All nodes to be normalized for type-2 clones::
				
				data Declaration:
				
				\enum(str name, list[Type] implements, list[Declaration] constants, list[Declaration] body)
      			\enumConstant(str name, list[Expression] arguments, Declaration class)
     			\enumConstant(str name, list[Expression] arguments)
     			\class(str name, list[Type] extends, list[Type] implements, list[Declaration] body)
				\interface(str name, list[Type] extends, list[Type] implements, list[Declaration] body)    			
    			\method(Type \return, str name, list[Declaration] parameters, list[Expression] exceptions, Statement impl)
    			\method(Type \return, str name, list[Declaration] parameters, list[Expression] exceptions)
    			\constructor(str name, list[Declaration] parameters, list[Expression] exceptions, Statement impl)
    			\import(str name)
    			\package(str name)
    			\package(Declaration parentPackage, str name)    	
    			\typeParameter(str name, list[Type] extendsList)
    			\annotationType(str name, list[Declaration] body)
    			\annotationTypeMember(Type \type, str name)
    			\annotationTypeMember(Type \type, str name, Expression defaultBlock)    
    			\parameter(Type \type, str name, int extraDimensions)
    			\vararg(Type \type, str name)	
    				
    			data Expression :
    			    		
    			\characterLiteral(str charValue)    		    	
    			\fieldAccess(bool isSuper, Expression expression, str name)
    			\fieldAccess(bool isSuper, str name)
    			\instanceof(Expression leftSide, Type rightSide)
    			\methodCall(bool isSuper, str name, list[Expression] arguments)
    			\methodCall(bool isSuper, Expression receiver, str name, list[Expression] arguments)
    			\number(str numberValue)
    			\stringLiteral(str stringValue)    			
    			\variable(str name, int extraDimensions)
    			\variable(str name, int extraDimensions, Expression \initializer)
    			\simpleName(str name)
    			\markerAnnotation(str typeName)
    			\normalAnnotation(str typeName, list[Expression] memberValuePairs)
    			\memberValuePair(str name, Expression \value)             
    			\singleMemberAnnotation(str typeName, Expression \value)
 	
				*/
				case Type _ => wildcard() // why wildcard() ??? need reason ???							
				//case Expression _ => \this() // to general, must specify more							
				case \assignment(_,_,_) => \this()
				case \fieldAccess(_,_,_) => \this()
				case \fieldAccess(_,_) => \this()
				case \type(_) => \this()
				case \declarationStatement(_) => \break()
			}
}

list[tuple[node,node]] lookForClones(list[node] nodes) {	
	//println("bucket size: <size(nodes)>");
	list[tuple[node n1, node n2]] clones = [];
	if(size(nodes) > 1) {
		//println("hey!");
		for(i <- [0..size(nodes)]) {
			for(j <- [i+1..size(nodes)]) {
				similarity = compareTrees(nodes[i], nodes[j]);								
				if (similarity >= 0.0) {//SimilarityThreshold: why 0.5 ???
					println("similarity : <similarity>");					
					//println("added pair ");
					//clones = removeChildClones(clones); // I don't know if is working																			
				    clones += <nodes[i],nodes[j]>;				    				   
				}
			}	
		}		
	}	
	//println("clones found: <size(clones)>");
	//cleanClones = removeChildClones(clones);
	return clones;//cleanClones;
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