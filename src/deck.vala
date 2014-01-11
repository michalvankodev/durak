public class Deck : Object {
		public List<Card> cards = new List<Card>();
		
		public Deck() {
			for (int card_value = 6; card_value < 15; card_value++) {
				this.cards.append(new Card(card_value, Card.C_type.HEARTS));
				this.cards.append(new Card(card_value, Card.C_type.DIAMONDS));
				this.cards.append(new Card(card_value, Card.C_type.SPADES));
				this.cards.append(new Card(card_value, Card.C_type.CLUBS));
			}
			this.shuffle();
		}
		
		public int remaining_cards() {
			return (int)this.cards.length();
		}
		
		private void shuffle() {
			
			for(int i = this.remaining_cards(); i > 0; i--) {
				
				Card to_be_shuffled = this.cards.nth_data((int)Random.int_range(0,i));
				this.cards.remove(to_be_shuffled);
				this.cards.append(to_be_shuffled);
				
			}
		}
		
		public Card push_card() {
			Card pushed = this.cards.nth_data(0);
			this.cards.remove(pushed);
			return pushed;
		}
}