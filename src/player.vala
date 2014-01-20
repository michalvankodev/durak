public class Player : Object {
	private List<Card> hand = new List<Card>();
	
	public void take_card(Card card) {
		this.hand.append(card);
	}
	
	public Card? get_lowest_trump_card(Card.Card_type? trump){
		Card? lowest_trump_card;
		this.hand.foreach((card) => {
			if (card.type == trump) {
				if (lowest_trump_card != null) {
					lowest_trump_card = card;
				}
				else if (card.value < lowest_trump_card.value) {
					lowest_trump_card = card;
				}
			}
		});
		return lowest_trump_card;
	}
}