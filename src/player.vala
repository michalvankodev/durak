public class Player : Object {
	private List<Card> hand = new List<Card>();
	
	public void take_card(Card card) {
		this.hand.append(card);
	}
	
}