package softEvolTest;

public class Class1 {
	private int a;
	private int b;
	
	public static void main( String[] args ) {
		int a = 1;
		int b = 2;		
		System.out.println(a + b);
	}
	
	public int sum2ints(int a, int b) {
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
	
	public boolean complexity() {
		boolean p = true;
		if(p) {
			return p;	
		}
		
		if(p) {
			p = true;
		} else {
			p = true;
		}
		return false;
	}
}
