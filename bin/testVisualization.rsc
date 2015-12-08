module testVisualization

import util::Resources;
import IO;
import List;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import String;
import Set;
import vis:: Figure;
import vis:: Render;


void visualize3() {

ell1 = ellipse(text("method1"),fillColor("pink"),hsize(20));

innerRow1 = [ ellipse(text("method1"),fillColor("red")),
         ellipse(text("method2"),fillColor("white"))
       ];
       
innerRow2 = [ ellipse(text("testMethod"),fillColor("red")),
         ellipse(text("method6"),fillColor("pink"))
       ];
       
innerRow3 = [ ellipse(text("method6"),fillColor("red")),
         ellipse(text("method2"),fillColor("white"))
       ];
       
innerRow4 = [ ellipse(text("method14"),fillColor("red")),
         ellipse(text("method4"),fillColor("pink"))
       ];
       
innerRow5 = [ ellipse(text("draw"),fillColor("pink")),
         ellipse(text("method2"),fillColor("white"))
       ];
       
       grid1 = grid([innerRow1,innerRow2]);
       grid2 = grid([innerRow1, innerRow3]);

row1 = [ ellipse(grid1),
         ellipse(text("file2.c"),fillColor("white")),
         ellipse(grid2)
         //ellipse(text("file3.c"),fillColor("white"))
       ];
row2 = [ ellipse(text("file4.c"),fillColor("white")),
         //ellipse(text("file5.c"),fillColor("white")),
         ellipse(grid([innerRow1])),
         ellipse(text("file6.c"),fillColor("white"))
       ];
       
nodes = [ box(text("file1.c"), id("A"), fillColor("white")),
     	  box(text("method"), id("B"), fillColor("pink")),
     	  box(text("method1"), id("C"), fillColor("pink")),
     	  box(text("method2"), id("D"), fillColor("white")),
     	  box(text("method3"), id("E"), fillColor("red"))
     	  ];
edges = [ edge("A", "B"), edge("A", "C"), edge("A", "D"),
    	  edge("A", "E")
    	]; 
//render(graph(nodes, edges, hint("layered"), std(size(30)), gap(40)));
       
/*row3 = [ ellipse(text("test.c"),fillColor("white")),
         ellipse(text("test2.c"),hsize(15),fillColor("white")),
         ellipse(text("party.c"),fillColor("white")),
         ellipse(text("party.c"),fillColor("white"))
       ]; */
       
row3 = [graph(nodes, edges, hint("layered"), std(size(30)), gap(40)),
		graph(nodes, edges, hint("layered"), std(size(30)), gap(40)),
		graph(nodes, edges, hint("layered"), std(size(30)), gap(40)),
		graph(nodes, edges, hint("layered"), std(size(30)), gap(40))
       ];
       
       
/*row4 = [ ellipse(text("test4.c"),fillColor("white")),
         //ellipse(text("file5.c"),fillColor("white")),
         ellipse(grid([innerRow5])),
         ellipse(text("file6.c"),fillColor("white")),
         //ellipse(text("file7.c"),fillColor("white"))
         ellipse(grid([innerRow2,innerRow5]))
       ];   */
       
       nodes2 = [ box(text("file1.c"), id("A"), fillColor("white"),layer("A")),
     	  box(text("method"), id("B"), fillColor("pink"),layer("B")),
     	  box(text("method1"), id("C"), fillColor("pink"),layer("B")),
     	  box(text("method2"), id("D"), fillColor("white"),layer("B")),
     	  box(text("method3"), id("E"), fillColor("red"),layer("C")),
     	  box(text("method3"), id("F"), fillColor("white"),layer("C")),
     	  box(text("method3"), id("G"), fillColor("pink"),layer("C"))
     	  ];
edges2 = [ edge("A", "B"), edge("A", "C"), edge("A", "D"),
    	  edge("A", "E"),edge("A", "F"),edge("A", "G")
    	]; 
       
       
row4 = [graph(nodes2, edges2, hint("layered"), std(size(30)), gap(40)),
		graph(nodes2, edges2, hint("layered"), std(size(30)), gap(40)),
		graph(nodes2, edges2, hint("layered"), std(size(30)), gap(40)),
		graph(nodes2, edges2, hint("layered"), std(size(30)), gap(40))
       ];
       
       
row5 = [ ellipse(text("test.c"),fillColor("white")),
         ellipse(text("test2.c"),hsize(15),fillColor("white")),
         ellipse(text("party.c"),fillColor("white")),
         ellipse(text("party.c"),fillColor("white")),
         ellipse(text("test2.c"),hsize(15),fillColor("white")),
         ellipse(text("party.c"),fillColor("white"))
       ];
row6 = [ ellipse(text("test4.c"),fillColor("white")),
         ellipse(text("file5.c"),fillColor("white")),
         ellipse(text("file6.c"),fillColor("white")),
         ellipse(text("file7.c"),fillColor("white")),
         ellipse(text("test2.c"),hsize(15),fillColor("white")),
         ellipse(text("party.c"),fillColor("white"))
       ];  
     
   
h = vcat([box(grid([row3,row3]),fillColor("white")),box(grid([row3,row3]),fillColor("white")),box(grid([row5,row6]),fillColor("white"))],std(lineWidth(2)));
render(h);
}

void visualize2() {

ell1 = ellipse(text("method1"),fillColor("pink"),hsize(20));

innerRow1 = [ ellipse(text("method1"),fillColor("red")),
         ellipse(text("method2"),fillColor("white"))
       ];
       
innerRow2 = [ ellipse(text("testMethod"),fillColor("red")),
         ellipse(text("method6"),fillColor("pink"))
       ];
       
innerRow3 = [ ellipse(text("method6"),fillColor("red")),
         ellipse(text("method2"),fillColor("white"))
       ];
       
innerRow4 = [ ellipse(text("method14"),fillColor("red")),
         ellipse(text("method4"),fillColor("pink"))
       ];
       
innerRow5 = [ ellipse(text("draw"),fillColor("pink")),
         ellipse(text("method2"),fillColor("white"))
       ];
       
       grid1 = grid([innerRow1,innerRow2]);
       grid2 = grid([innerRow1, innerRow3]);

row1 = [ ellipse(grid1),
         ellipse(text("file2.c"),fillColor("white")),
         ellipse(grid2)
         //ellipse(text("file3.c"),fillColor("white"))
       ];
row2 = [ ellipse(text("file4.c"),fillColor("white")),
         //ellipse(text("file5.c"),fillColor("white")),
         ellipse(grid([innerRow1])),
         ellipse(text("file6.c"),fillColor("white"))
       ];
       
row3 = [ ellipse(text("test.c"),fillColor("white")),
         ellipse(text("test2.c"),hsize(15),fillColor("white")),
         ellipse(text("party.c"),fillColor("white")),
         ellipse(text("party.c"),fillColor("white"))
       ];
row4 = [ ellipse(text("test4.c"),fillColor("white")),
         //ellipse(text("file5.c"),fillColor("white")),
         ellipse(grid([innerRow5])),
         ellipse(text("file6.c"),fillColor("white")),
         //ellipse(text("file7.c"),fillColor("white"))
         ellipse(grid([innerRow2,innerRow5]))
       ];  
       
row5 = [ ellipse(text("test.c"),fillColor("white")),
         ellipse(text("test2.c"),hsize(15),fillColor("white")),
         ellipse(text("party.c"),fillColor("white")),
         ellipse(text("party.c"),fillColor("white")),
         ellipse(text("test2.c"),hsize(15),fillColor("white")),
         ellipse(text("party.c"),fillColor("white"))
       ];
row6 = [ ellipse(text("test4.c"),fillColor("white")),
         ellipse(text("file5.c"),fillColor("white")),
         ellipse(text("file6.c"),fillColor("white")),
         ellipse(text("file7.c"),fillColor("white")),
         ellipse(text("test2.c"),hsize(15),fillColor("white")),
         ellipse(text("party.c"),fillColor("white"))
       ];  
     
   
h = vcat([box(grid([row1,row2]),fillColor("white")),box(grid([row3,row4]),fillColor("white")),box(grid([row5,row6]),fillColor("white"))],std(lineWidth(2)));
render(h);
}

void visualize() {

ell1 = ellipse(text("method1"),fillColor("pink"),hsize(20));

row1 = [ box(text("file1.c"),fillColor("red")),
         box(text("file2.c"),fillColor("white")),
         box(text("file3.c"),fillColor("pink"))
       ];
row2 = [ box(text("file4.c"),fillColor("white")),
         box(text("file5.c"),fillColor("pink")),
         box(text("file6.c"),fillColor("red"))
       ];
       
row3 = [ box(text("test.c"),fillColor("white")),
         box(text("test2.c"),hsize(15),fillColor("white")),
         box(text("party.c"),fillColor("pink")),
         box(text("party.c"),fillColor("pink"))
       ];
row4 = [ box(text("test4.c"),fillColor("red")),
         box(text("file5.c"),fillColor("pink")),
         box(text("file6.c"),fillColor("red")),
         box(text("file7.c"),fillColor("pink"))
       ];  
       
row5 = [ box(text("test.c"),fillColor("white")),
         box(text("test2.c"),hsize(15),fillColor("white")),
         box(text("party.c"),fillColor("pink")),
         box(text("party.c"),fillColor("pink")),
         box(text("test2.c"),hsize(15),fillColor("white")),
         box(text("party.c"),fillColor("pink"))
       ];
row6 = [ box(text("test4.c"),fillColor("red")),
         box(text("file5.c"),fillColor("pink")),
         box(text("file6.c"),fillColor("red")),
         box(text("file7.c"),fillColor("pink")),
         box(text("test2.c"),hsize(15),fillColor("white")),
         box(text("party.c"),fillColor("pink"))
       ];  
     
   
h = vcat([box(grid([row1,row2]),fillColor("white")),box(grid([row3,row4]),fillColor("white")),box(grid([row5,row6]),fillColor("white"))],std(lineWidth(2)));
render(h);
}


void wtf5() {
c = false; 
Figures ffigures = [ellipse(fillColor("Orange"))];
b = box(fillColor(Color () { return c ? color("red") : color("green"); }),
	onMouseEnter(void () { fswitch(int () {return 0;}, ffigures, fillColor("green")); }), onMouseExit(void () { c = false ; })
	,shrink(0.5));
render(b);
}

void coding() {
t = treemap([box(treemap([vcat([text("package1"),box(vcat([text("file1.c"),ellipse(text("method1"),area(10),fillColor("red")),
	     ellipse(text("method2"),fillColor("pink"))]),area(10)),
	     box(vcat([text("file2.c"),ellipse(text("method1"),area(10),fillColor("pink")),
	     ellipse(text("method2"),fillColor("pink"),area(20))]),area(10),area(20))])]),area(10),fillColor("white")),
	     box(treemap([vcat([text("package2"),box(vcat([text("file3.c"),ellipse(text("method1"),area(10),fillColor("pink")),
	     ellipse(text("method2"),fillColor("pink"),area(20)),ellipse(text("method1"),area(10),fillColor("red")),
	     ellipse(text("method2"),fillColor("pink"))]),area(10)),
	     box(vcat([text("file4.c"),ellipse(text("method1"),area(10),fillColor("pink")),
	     ellipse(text("method2"),fillColor("pink"),area(20))]),area(10),area(20))])]),area(20),fillColor("white")),
	     box(text("package3"),area(70))
     ]);
render(t);
}

void test4() {
t = treemap([box(treemap([text("PACKAGE3"),box(vcat([text("file1.c"),box(text("method1"),area(10),fillColor("red")),
	     box(text("method2"),fillColor("pink"))]),area(10)),
	     box(vcat([text("file2.c"),box(text("method1"),area(10),fillColor("pink")),
	     box(text("method2"),fillColor("pink"),area(20))]),area(10),area(20))]),area(70),fillColor("white"))
     ]);
render(t);
}


void test3() {
t = treemap([box(treemap([vcat([text("PACKAGE1"),box(vcat([text("file1.c"),box(text("method1"),area(10),fillColor("red")),
	     box(text("method2"),fillColor("pink"))]),area(10))])]),area(10),fillColor("white")),
	     //box(vcat([text("file2.c"),ellipse(text("method1"),area(10),fillColor("pink")),
	     //ellipse(text("method2"),fillColor("pink"),area(20))]),area(10))])]),area(10),fillColor("white")),
	     
	     box(treemap([vcat([text("PACKAGE2"),box(vcat([text("file3.c"),box(text("method3"),area(10),fillColor("red"))
	     ]),area(10)),
	     box(vcat([text("file4.c"),box(text("method4"),area(10),fillColor("pink"))
	     ]),area(10),area(20))])]),area(10),fillColor("white"))
	     
	  /*   box(treemap([vcat([text("PACKAGE3"),box(vcat([text("file2.c"),treemap([box(text("method1"),fillColor("red")),
	     box(text("method2"),fillColor("pink")),box(text("method5"),fillColor("pink")),box(text("method53"),fillColor("white")),
	     box(text("method55"),fillColor("red")),box(text("method1"),fillColor("red")),box(text("method3"),fillColor("red")),box(text("method4"),fillColor("white")),box(text("method5"),fillColor("pink")),box(text("method6"),fillColor("pink"))])]),lineColor("blue"),area(20)),
	     
	     box(vcat([text("testFile.c"),treemap([box(text("method11"),area(10),fillColor("pink")),
	     box(text("method21"),area(10),fillColor("red")),box(text("method5"),area(10),fillColor("white")),box(text("method6"),area(10),fillColor("pink"))])]),area(10))
	     ])]),area(70),fillColor("white"))
	     */
	     
	     
	    // box(vcat([text("file2.c"),box(text("method1"),area(10),fillColor("pink")),
	     //box(text("method2"),fillColor("pink"),area(20))]),area(10),area(20))])]),area(70),fillColor("white"))
     ]);
render(t);
}

void wtf4() {

row1 = [ box(text("bla\njada"),fillColor("Red")),
         ellipse(fillColor("Blue")),
         box(fillColor("Yellow"))
       ];
row2 = [ box(ellipse(fillColor("Yellow")),fillColor("Green")),
         box(fillColor("Purple")),
         box(text("blablabalbalba"),fillColor("Orange"))
       ];
render(grid([row1, row2]));

}

void wtf3() {
h = hcat([ellipse(fillColor("mediumblue")),ellipse(fillColor("red")),ellipse(fillColor("red"))],std(lineWidth(2)));
render(h);
h1 = hcat([ellipse(fillColor("mediumblue")),ellipse(fillColor("red")),ellipse(fillColor("red"))],std(lineWidth(2)));
render(h1);
}

void wtf2() {
nodes = [ box(text("A"), id("A"), size(50), fillColor("lightgreen")),
     	  box(text("Q"), id("Q"), size(60), fillColor("orange")),
     	  ellipse( text("C"), id("C"), size(70), fillColor("lightblue")),
     	  ellipse(text("D"), id("D"), size(200, 40), fillColor("violet")),
          box(text("E"), id("E"), size(50), fillColor("silver")),
	  box(text("F"), id("F"), size(50), fillColor("coral"))
     	];
edges = [ edge("A", "Q", lineColor("lightblue")), edge("Q", "C"), edge("Q", "D"), edge("A", "C"),
          edge("C", "E"), edge("C", "F"), edge("D", "E"), edge("D", "F"),
          edge("A", "F")
    	];
h = hcat([ellipse(graph(nodes, edges, hint("layered")),fillColor("mediumblue")),ellipse(fillColor(rgb(0, 0, 205)))],std(lineWidth(2)));
render(h);
//render(graph(nodes, edges, hint("layered"), gap(100)));
}


void wtf() {

e1 = ellipse(text("Rascal", fontSize(20), fontColor("blue")),fillColor("red"));
e3 = ellipse(text("Rascal", fontSize(20), fontColor("blue")),fillColor("green"));
e2 = ellipse(e1, fillColor("white"));
render(e2);

}
