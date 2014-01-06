class hello_world : Object {
	public static int main (string[] args) {
		stdout.printf("Hello World\n");
		
		Card my = new Card(11, Card.C_type.HEARTS);
		stdout.printf("card %s", my.to_short_string());
		return 0;
	}
}