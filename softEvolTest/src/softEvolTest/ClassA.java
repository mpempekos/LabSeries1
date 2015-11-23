
public class ClassA {
	private int a;
	private int b;
	
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
}
