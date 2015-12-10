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
	
	public int type1_aaaa(int a, int d) {
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
		
	
}
