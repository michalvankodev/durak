public class Discard_pile : Object {
	private List<Card> pile = new List<Card>();
	
	public int discarded_cards {
		return (int)this.pile.length();
	}
}