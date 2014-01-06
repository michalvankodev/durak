class durak : Object {
	public static int main (string[] args) {
		stdout.printf("Hello World\n");
		
		Stack my = new Stack();
		stdout.printf("%d", my.remaining_cards());
		
		for (uint i = 0; i < my.remaining_cards(); i++) {
			stdout.printf("%s \n", my.stack.nth_data(i).to_string());
		}
		return 0;
	}
}