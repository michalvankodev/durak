public class Player : Object {
	private List<Card> hand = new List<Card>();
	
	public void take_cards(Card[] cards) {
		for (Card card in cards) {
			this.hand.append(card);
		}
	}
	
}