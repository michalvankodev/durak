public class Card : Object {
	
	public int value { get; private set;}
	public Card_type type { get; private set;}
	
	public enum Card_type {
		HEARTS,
		DIAMONDS,
		SPADES,
		CLUBS;
		
		public string to_string() {
			switch (this) {
				case SPADES:
					return "Spades";

				case HEARTS:
					return "Hearts";

				case DIAMONDS:
					return "Diamonds";

				case CLUBS:
					return "Clubs";

				default:
					assert_not_reached();
			}
		}
	}
	
	public Card(int _value, Card_type _type) {
		this.value = _value;
		this.type = _type;
	}
	
	public string to_string() {
		return this.transfer_value() + " of " + this.type.to_string();
	}
	
	public string to_short_string() {
		return this.transfer_value() + this.type.to_string()[0].to_string().down();
	}
	
	private string transfer_value() {
		if(this.value == 11)
			return "J";
		else if (this.value == 12)
			return "Q";
		else if (this.value == 13)
			return "K";
		else if (this.value == 14)
			return "A";
		else
			return this.value.to_string();
	}
	
	/* TODO: Compare function 
	 This function returns  
	 return  a negative integer, zero, or a positive integer as this object is less than, equal to, or greater than the specified object 
	 according to DURAK's rules.
	 so if the card is trump it wins
	 */
	public int durak_compare_to(Card card1, Card card2, Card_type trump) {
		if (card1.type == card2.type) {
			return card1.value - card2.value;
		}
		else if (card1.type == trump) {
			return -1;
		}
		else return card1.value - card2.value;
	}
	
	
}