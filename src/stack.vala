public class Stack : Object {
		public List<Card> stack = new List<Card>();
		
		public Stack() {
			for (int card_value = 6; card_value < 15; card_value++) {
				this.stack.append(new Card(card_value, Card.C_type.HEARTS));
				this.stack.append(new Card(card_value, Card.C_type.DIAMONDS));
				this.stack.append(new Card(card_value, Card.C_type.SPADES));
				this.stack.append(new Card(card_value, Card.C_type.CLUBS));
			}
			this.shuffle();
		}
		
		public int remaining_cards() {
			return (int)this.stack.length();
		}
		
		private void shuffle() {
			
			for(int i = this.remaining_cards(); i > 0; i--) {
				
				Card to_be_shuffled = this.stack.nth_data((int)Random.int_range(0,i));
				this.stack.remove(to_be_shuffled);
				this.stack.append(to_be_shuffled);
				
			}
		}
}