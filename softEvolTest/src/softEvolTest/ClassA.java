package softEvolTest;

public class ClassA {
	private int a;
	private int b;
	private int d;
	
/************************* TYPE-1 CLONES *************************
Identical code fragments except for variations in whitespace, 
layout and comments.
*****************************************************************/	
	/*
	public int sum2ints3(int a, int d) {
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
		
	public int sum2ints35(int a, int d) {
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
	
	public class ClassB {
		private int a;
		private int b;
		private int d;
		
		public int sum2ints3(int a, int d) {
			this.a = a;
			this.d = d;				
			System.out.println(this.a);
			System.out.println(this.a + "+" + this.d + "=");		
			return this.a + this.d;
		}
	}
	
	public class ClassC {
		private int a;
		private int b;
		private int d;
		
		public int sum2ints3(int a, int d) {
			this.a = a;
			this.d = d;				
			System.out.println(this.a);
			System.out.println(this.a + "+" + this.d + "=");		
			return this.a + this.d;
		}
	}
	*/
/************************* TYPE-2 CLONES *************************	
Syntactically identical fragments except for variations in 
identifiers, literals, types, whitespace, layout and comments.
*****************************************************************/
	
	public int sum2ints2(int a, int b) {
		int c = 0;
		this.a = a;
		this.b = b;		
		System.out.println(this.a);
		System.out.println(this.a + "+" + this.b + "=");		
		return this.a + this.b;
	}
	
	public int sum2ints28(int a, int b) {
		float d = 4;
		this.a = a;
		this.b = b;				
		System.out.println(this.a);
		System.out.println(this.a + "+" + this.b + "=");		
		return this.a + this.b;
	}
	
	void f () {
		int x=0;
		int a=1;
		int b=2;
		int c=3;
		int w=4;
	}
	
	void g () {
		String y = "ANDRE"; 
		int a=2;
		int b=2;
		int c=3;
		int i=5;
	}
	
	
	
/*****************************************************************/	
	/*public int sum2ints(int c, int b) {
		/*int age = 0;
		if(age == 0) age = 1;
		if(age == 1) age = 2;
		if(age == 2) age = 3;
		this.c = c;
		this.b = b;	
		System.out.println(this.c);		
		System.out.println(this.c + "+" + this.b + "=");	
		return this.c + this.b;
	}*/
	
	/*public int sum2ints09(int a, int b) {
		this.c = c;
		this.a = a;
		this.b = b;				
		System.out.println(this.a);
		System.out.println(this.a + "+" + this.b + "=");		
		return this.a + this.b;
	}
		
	public int sum2ints20(int a, int b) {
		int d = 0; this.a = a;		
		this.b = b;		
		System.out.println(this.a);
		System.out.println(this.a + "+" + this.b + "=");		
		return this.a + this.b;
	} */	
}
