public class Player : Object {
	private List<Card> hand = new List<Card>();
	public string name {get; private set;}
	
	public Player(string _name) {
		this.name = _name;
	}
	public void take_card(Card card) {
		this.hand.append(card);
	}
	public void take_cards(Card[] cards) {
		foreach (Card card in cards) {
			this.take_card(card);
		}
	}
	public void play_card(Card card){
		this.hand.remove(card);
	}
	
	public Card? get_lowest_trump_card(Card.Card_type? trump){
		Card lowest_trump_card = null;
		this.hand.foreach((card) => {
			if (card.card_type == trump) {
				if (lowest_trump_card == null) {
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