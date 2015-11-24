package softEvolTest;

public class ClassA {
	private int a;
	private int b;
	private int c;
	
	public int sum2ints(int a, int b) {
		this.a = a;
		this.b = b;	
		System.out.println(this.a);		
		System.out.println(this.a + "+" + this.b + "=");	
		return this.a + this.b;
	}
	
	public int sum2ints3(int a, int b) {
		this.a = a;
		this.b = b;		
		System.out.println(this.a);
		System.out.println(this.a + "+" + this.b + "=");		
		return this.a + this.b;
	}
	
	public int sum2ints2(int a, int b) {
		this.a = a;
		this.b = b;		
		System.out.println(this.a);
		System.out.println(this.a + "+" + this.b + "=");		
		return this.a + this.b;
	}
	
	public int sum2ints5(int a, int b) {
		this.a = a;
		this.b = b;				
		return this.a + this.b;
	}
	
	public int sum2ints6(int a, int b) {
		this.a = a;
		this.b = b;				
		return this.a + this.b;
	}
	
	public int sum2ints7(int a, int b) {
		this.a = a;
		this.b = b;				
		return this.a + this.b;
	}
	
	
	public int sum2ints9(int a, int b, int c) {
		this.b = b;	
		this.c = c;
		return this.a + this.b;
	}
	
	public int sum2ints8(int a, int b, int c) {
		this.b = b;
		this.c = c;
		return this.a + this.b;
	}
}
