package softEvolTest;

import smallsql.database.ExpressionValue;
import smallsql.database.Integer;
import smallsql.database.SmallSQLException;
import smallsql.database.language.Language;

public class ClassA {
	private int a;
	private int b;
	private int d;
	
//************************* TYPE-1 CLONES *************************
// Identical code fragments except for variations in whitespace, 
// layout and comments.
//*****************************************************************/	
	
	public int type1_A(int a, int d) {
		int age = 0;
		this.a = a;
		System.out.println(this.a);
		if(age == 0) age = 1;
		if(age == 1) age = 2;
		this.d = d;				
		System.out.println(this.a);
		System.out.println(this.a + "+" + this.d + "=");		
		return this.a + this.d;
	}
	
	
		
	public int type1_a(int a, int d) {
		int age = 0;
		this.a = a;
		System.out.println(this.a);
		if(age == 0) age = 1;
		if(age == 1) age = 2;
		this.d = d;				
		System.out.println(this.a);
		System.out.println(this.a + "+" + this.d + "=");		
		return this.a + this.d;
	}	
	
//	public int type1_aaaaa(int a, int d) {
//		int age = 0;
//		this.a = a;
//		System.out.println(this.a);
//		if(age == 0) age = 1;
//		if(age == 1) age = 2;
//		this.d = d;				
//		System.out.println(this.a);
//		System.out.println(this.a + "+" + this.d + "=");		
//		return this.a + this.d;
//	}
//	
//	public int ty_aaaaa(int a, int d) {
//		int age = 0;
//		this.a = a;
//		System.out.println(this.a);
//		if(age == 0) age = 1;
//		if(age == 1) age = 2;
//		this.d = d;				
//		System.out.println(this.a);
//		System.out.println(this.a + "+" + this.d + "=");		
//		return this.a + this.d;
//	}
//		
//	public class ClassB {
//		private int a;
//		private int b;
//		private int d;
//		
//		public int type1_B(int a, int d) {
//			this.a = a;
//			this.d = d;				
//			System.out.println(this.a);
//			System.out.println(this.a + "+" + this.d + "=");		
//			return this.a + this.d;
//		}
//	}
//	
//	public class ClassC {
//		private int a;
//		private int b;
//		private int d;
//		
//		public int type1_B(int a, int d) {
//			this.a = a;
//			this.d = d;				
//			System.out.println(this.a);
//			System.out.println(this.a + "+" + this.d + "=");		
//			return this.a + this.d;
//		}
//	}
//	
//
////************************* TYPE-2 CLONES *************************	
//// Syntactically identical fragments except for variations in 
//// identifiers, literals, types, whitespace, layout and comments.
////*****************************************************************/
//
//	
//	public int type2_A(int a, int b) {
//		int c = 0;
//		this.a = a;
//		this.b = b;		
//		System.out.println(this.a);
//		System.out.println(this.a + "+" + this.b + "=");		
//		return this.a + this.b;
//	}
//	
//	public int type2_a(int a, int b) {
//		float d = 4;
//		this.a = a;
//		this.b = b;				
//		System.out.println(this.a);
//		System.out.println(this.a + "+" + this.b + "=");		
//		return this.a + this.b;
//	}
//	
//	void type2_B () {
//		int x=0;
//		int a=1;
//		int b=2;
//		int c=3;
//		int w=4;
//	}
//	
//	void type2_b () {
//		String y = "ANDRE"; 
//		int a=2;
//		int b=2;
//		int c=3;
//		int i=5;
//	}
//	
//	
////************************* TYPE-3 CLONES *************************	
//// One or more statements can be modified, added, or removed. 
//// Furthermore, the structure of code fragment may be changed 
//// and it may even look or behave slightly different from the 
//// original. This kind of clone is hard to detect.
////*****************************************************************/
//	
//	public int type3_A(int a, int b, int c) {
//		int j = 1;
//		this.a = a;
//		this.b = b;				
//		System.out.println(this.a);
//		System.out.println(this.a + "+" + this.b + "=");		
//		return this.a + this.b;
//	}
//	
//	public int type3_a(int a, int b, int c) {			
//		this.a = a;
//		this.b = b;	
//		int j = 1;
//		System.out.println(this.a);		
//		System.out.println(this.a + "+" + this.b + "=");		
//		return this.a + this.b;
//	}
//	
//	public int type3_B(int a, int b, int c) {
//		int j = 1;
//		this.a = a;
//		this.b = b;				
//		System.out.println(this.a);
//		System.out.println(this.a + "+" + this.b + "=");		
//		return this.a + this.b;
//	}
//	
//	public int type3_b(int a, int b, int c) {			
//		this.a = a;
//		this.b = b;	
//		System.out.println(this.a);		
//		int j = 0;		
//		System.out.println(this.a + "+" + this.b + "=");		
//		return this.a + this.b;
//	}
//	
////*****************************************************************/	
//
//	
//	public int sum2ints045(int a, int b) {
//		int age = 0;
//		if(age == 0) age = 1;
//		if(age == 1) age = 2;
//		if(age == 2) age = 3;
//		this.c = c;
//		this.b = b;	
//		for(int p=0; p<params.size(); p++){
//            if(((ExpressionValue)params.get(p)).isEmpty())
//            	throw SmallSQLException.create(Language.PARAM_EMPTY, new Integer(p+1));
//        }
//		System.out.println(this.c);		
//		System.out.println(this.c + "+" + this.b + "=");	
//		return this.c + this.b;
//	}
//		
//	public int sum2ints20(int a, int b) {
//		int d = 0; this.a = a;		
//		this.b = b;	
//		for(int p=0; p<params.size(); p++){
//            if(((ExpressionValue)params.get(p)).isEmpty())
//            	throw SmallSQLException.create(Language.PARAM_EMPTY, new Integer(p+1));
//        }
//		System.out.println(this.a);
//		System.out.println(this.a + "+" + this.b + "=");		
//		return this.a + this.b;
//	}	
}
